# Monolithium [![CircleCI][badge]][circleci]

This is my personal little Rails monolith where I keep all the little things
that I've built for myself.

## Dum Reader

I love RSS so much I made an RSS reader that rides on top of [the Feedbin
API][feedbin]. It was the project that I used to learn React and is something
that I use every day!

## Forty API

Monolithium is also my API server for [Forty][forty-macos], my personal time
tracking app.

## Update Queue

I feel strongly about keeping my projects up-to-date, so I made a thing to keep
track of which apps are due for an update. It's really just a list of projects
with timestamps to keep track of update state.

## Faring Direball

Due to a quirk in how Gruber does his feed, Feedbin and other RSS readers send
you to the article he's commenting on instead of his post. I hate this. So I
mirror his feed and remove that quirk so that it links to his post instead. Did
I mention I'm crazy about RSS?

## Rando

I run a Star Wars-themed modified NFL survivor pool called The Rando Calrissian
Football Pool. That is a sentence that I never get used to writing. Monolithium
is both the home of the website for this pool and also serves as the API server
for the [iOS client app][rando_admin].

[badge]: https://circleci.com/gh/jonallured/monolithium.svg?style=svg
[circleci]: https://circleci.com/gh/jonallured/monolithium
[feedbin]: https://github.com/feedbin/feedbin-api
[forty-macos]: https://github.com/jonallured/forty-macos
[rando_admin]: https://github.com/jonallured/rando_admin
