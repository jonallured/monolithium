# Monolithium [![CircleCI][badge]][circleci]

This is my personal Rails monolith where I keep things that I've built for
myself.

### Start a Server

```
$ ./bin/start
```

### Open a Console

```
$ ./bin/console
```

### Run all the tests

```
$ bundle exec rake
```

## Projects

Because this is a monolith I'm free to bolt on whatever random functionality I
want!

### Update Queue

I feel strongly about keeping my projects up-to-date, so I made a thing to keep
track of which apps are due for an update. It's really just a list of projects
with timestamps to keep track of update state.

### Faring Direball

Due to a quirk in how Gruber does his feed, [Feedbin][feedbin] and other RSS
readers send you to the article he's commenting on instead of his post. I hate
this. So I mirror his feed and remove that quirk so that it links to his post
instead.

[badge]: https://circleci.com/gh/jonallured/monolithium.svg?style=svg
[circleci]: https://circleci.com/gh/jonallured/monolithium
[feedbin]: https://github.com/feedbin/feedbin-api
