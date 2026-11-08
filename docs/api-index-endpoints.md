# API index endpoints

Index endpoints that include `Indexable` share one set of rules. The query
itself is built by `IndexQuery` from allowlists declared on the model. At the
moment the financial endpoints follow these rules; books, boops and work days
don't yet.

## On the model

```ruby
def self.default_index_sort
  "-posted_on"
end

def self.index_filters
  {financial_account_id: :id, posted_on: :date}
end

def self.index_sorts
  %w[amount_cents posted_on]
end
```

## Filters

Each filter is named after the column it filters, and the query param uses
that name. Every kind ends in `where(column => value)`; the kind only decides
how the param is checked and converted:

| Kind | Accepts | Becomes |
|---|---|---|
| `:date` | `YYYY`, `YYYY-MM` or `YYYY-MM-DD` | the whole year, the whole month, or that one day |
| `:id` | a positive integer | that integer |
| an Array | one of its values | that value |

So `?posted_on=2024-03` returns everything posted in March 2024. A date that
doesn't exist, like `2023-02-29`, is a 400. A filter that matches nothing
returns an empty array, not a 404.

## Sorting

`sort=posted_on` is ascending and `sort=-posted_on` descending; several fields
are comma separated, as in `sort=-posted_on,amount_cents`. Only fields in
`index_sorts` are allowed. `id` is always added as a final tiebreaker in the
direction of the last field, so pages stay stable.

## Paging

`page` and `per_page` are positive integers, and `per_page` is at most 100.
Responses stay plain JSON arrays. Paging details are in headers:

- `X-Total-Count`: every matching record, across all pages
- `X-Next-Page`: the next page number, left out on the last page

## Bad input

Unknown params and invalid values return a 400 with `{"error": "..."}`, so a
typo doesn't quietly return everything.

## Adding an endpoint

```ruby
class FinancialTransactionsController < Api::V1Controller
  include Indexable

  index_model FinancialTransaction

  expose(:financial_transactions) { index_query.records }
end
```
