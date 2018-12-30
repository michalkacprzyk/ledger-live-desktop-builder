# ledger-live-desktop-builder

## What?
Automated build of the Ledger Live Desktop software (https://github.com/LedgerHQ/ledger-live-desktop) inside of a Docker container.

## Why?
As the issue (https://github.com/LedgerHQ/ledger-live-desktop/issues/942) details, at the moment there is no official way to make certain that the Linux binary application file, downloaded to an user machine, is intact.

## How?

Assuming that [Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/) is already installed, and the current working directory is the one of this cloned repository.
```
docker build -t local/ledger-live-desktop .
docker run -it --rm -v $(pwd):/host/ local/ledger-live-desktop
```
Should be able to produce a fresh application file in the current working directory.

## What if?

- I do not guarantee anything, just publish my code as I stumbled on the issue myself, and thought it may be useful to somebody.
- If you do not want to wait around 15 minutes, and trust their automatic build process, it is possible to get the final binary straight from (https://hub.docker.com/r/mkusanagi/ledger-live-desktop).
