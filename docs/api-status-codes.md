# API status codes

Every `/api/v1` endpoint should answer the same way for the same kind of
problem. The financial account and financial statement endpoints follow all
of this; books, boops and work days still return 400 for validation failures
and move to 422 in a follow-up.

## The codes

| Code | Means | Example | Body |
|---|---|---|---|
| 200 | It worked | a GET, or an update | the record or records |
| 201 | A record was created | a POST | the new record |
| 400 | The request itself is broken | a missing root param, an unknown filter, a date that doesn't parse | `{"error": "..."}` |
| 404 | The thing named doesn't exist, or the caller has no token | `/financial_statements/0`, an unknown `financial_account_id` | `{"error": "..."}`, or empty without a token |
| 422 | The request is well formed but the data breaks a rule | a second statement for the same month, a `period_start_on` that isn't the 1st, an account name that's taken | `{"error": "..."}` |

The 400 and 422 line comes down to who has to change something. A 400 means
the client is building requests wrong, so the fix is in the code that sends
them. A 422 means the request was fine but this data can't be saved, so the
same request with different data would work. In Rails terms, a 400 is
`ActionController::ParameterMissing` or `IndexQuery::InvalidParam`, and a 422
is `ActiveRecord::RecordInvalid`.

Use the `:unprocessable_content` symbol for 422. Rack 3.1 renamed it, and
`:unprocessable_entity` is deprecated.

## Updates use PATCH

An update changes only the fields it's sent, which is what PATCH means, so
PATCH is the verb for updates. Write routes with `resources`, write
hand-rolled update routes with `patch`, and write request specs as
`describe "PATCH /api/v1/..."` with `patch` calls. `resources` also routes PUT
to `update`, and that's fine to accept, but nothing in the project should be
written as PUT.

## Why the codes don't leak anything

A common worry with status codes is enumeration: if a login endpoint returns
one code for "no such email" and another for "wrong password", anybody can
use it to find out which emails exist. Monolithium avoids that by making the
token check come first.

`ApiController` runs `validate_client_token` before any action. Without a
valid token, every request gets a bare 404 with no body, the same response a
route that doesn't exist gets. A caller without the token can't see a 400, a
422 or a 404 with a message, so it can't tell whether a record exists or
whether a route is real.

Only callers holding the token see the codes in the table above, and the
token already lets them read everything through the index endpoints. Telling
a token holder "that month is already taken" tells them nothing they couldn't
GET.

The code is open source, so param names, validations and error messages are
public anyway. What has to stay private is the data, and the data sits behind
the token.

## Endpoints without a token

These skip `validate_client_token`, so anybody can reach them:

- `POST /api/v1/raw_hooks`
- `POST /api/v1/boops`
- `GET /api/v1/decode_jwt`
- `GET /api/v1/ping`
- `GET /api/v1/word_rot/killswitch`

The enumeration worry does apply here. An unauthenticated endpoint must not
answer differently depending on what's stored: no uniqueness or existence
validation whose message reaches the caller, and no 404 that depends on a
lookup. Today raw_hooks and boops are the only ones that write. RawHook
validates presence only and Boop validates format only, so neither can say
whether a record exists. Check this list before adding a uniqueness
validation to either model, or before skipping the token check on a new
endpoint.
