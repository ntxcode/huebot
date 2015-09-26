Huebot :alien:
==============

Your experimental, lightweight, moody (but useful) and customizable chat bot for Slack.

## Install steps

1. Sets the `SLACK_BOT_TOKEN` environment variable. It must be a bot token, and [you can create one here](https://my.slack.com/services/new/bot)
2. Start it running `mix run --no-halt` in your server.
3. Profit

## Plugins

### Github

By default the Github integration plugin is enabled, currectly we have these modules:

* ListPullRequests

#### Configuration

Just generates and sets the `GITHUB_ACCESS_TOKEN` environment variable.

### Zupper

It integrates with our not-released deployer.

#### Configuration

To configure it, just set `ZUPPER_HOOK_URL` to the Zupper's
default hook URL.

## Roadmap

* [ ] Ability to schedule jobs
* [ ] Send formatted Slack messages
* [ ] Redis integration for persistence
* [ ] Test coverage :flushed:

## Gibe me contributionz pls

1. Fork it
2. Create your feature branch from master
3. Do your stuff
4. Open a Pull Request with a good description
5. Thank you <3
