# Monolithium [![CI Badge][badge]][action_page]

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

### Artsy Viewer

This page displays a new artwork from Artsy every hour. It's meant to be pulled
up on a second screen and be there for you to glace at occasionally throughout
the day.

### Faring Direball

Due to a quirk in how Gruber does his feed, [Feedbin][feedbin] and other RSS
readers send you to the article he's commenting on instead of his post. I hate
this. So I mirror his feed and remove that quirk so that it links to his post
instead.

### Post Bin

I got it in my head that I should have an API endpoint I can post to and then
read what the server was sent. There are services out there that do this for you
but why not build your own!

### Reading List

Logging things is something I love and it's no different with reading. This page
tracks the books I've read each year. It uses an API to fetch the page counts
for each book and computes a pages per day pace.

### Wishlist

Amazon has wishlist functionality but I wanted to build my own so that's what
this is: a list of things I want with buttons that can be used to indicate that
an item has been purchased already without spoiling the surprise.

### Update Queue

I feel strongly about keeping my projects up-to-date, so I made a thing to keep
track of which apps are due for an update. It's really just a list of projects
with timestamps to keep track of update state.

[action_page]: https://github.com/jonallured/monolithium/actions/workflows/main.yml
[badge]: https://github.com/jonallured/monolithium/actions/workflows/main.yml/badge.svg
[feedbin]: https://github.com/feedbin/feedbin-api
