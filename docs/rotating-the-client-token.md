# Rotating the API client token

This repo is public: never commit or paste the token value.

## 1. Branch from main

```sh
cd ~/code/monolithium
git switch main
git pull --ff-only
git switch -c rotate-client-token
```

## 2. Generate a token

```sh
ruby -rsecurerandom -e 'print SecureRandom.hex(64)' | pbcopy
```

## 3. Save it in 1Password

Paste it into the `MLI_CLIENT_TOKEN` entry of the `zsh-private-exports` item.

## 4. Update the credentials

Run [`credit`][credit] and replace `client_token` under `default`.

## 5. Ship it

Commit `config/credentials.yml.enc`, open a PR, merge, and deploy.

## 6. Check the old token is refused

Every shell still has the old token, so this should return `404`:

```sh
http --headers https://app.jonallured.com/api/v1/work_days X-MLI-CLIENT-TOKEN:$MLI_CLIENT_TOKEN
```

## 7. Regenerate the exports

```sh
cd ~/code/dotfiles
./setup
```

In a new shell, run the step 6 command again. It should return `200`.

## 8. Update the Time Clock app

Update the token in the app's settings at [developer.lametric.com][lametric],
then install the new version on the device.

[credit]: https://github.com/jonallured/dotfiles/blob/main/rcm/zsh/aliases
[lametric]: https://developer.lametric.com
