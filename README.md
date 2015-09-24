# simple_backup
An rsync/ssh based backup script with configuration options for multiple endpoints and directory structures for each. *Simpe_backup* is inspired by Mike Rubel's http://www.mikerubel.org/computers/rsync_snapshots/. Read it to understand the approach.

##Features

- full rolling backups with hard links between unchanged objects (save space)
- uses rsync locally and over ssh
- supports multiple "endpoints", thus syncing from multiple servers
- supports multiple sync locations (directories) per endpoint
- rolling sync and snapshot style (e.g. rolling daily and snapshot every week)

##Requirements

Simple_backup relies on rsync and common binaries (see common.config for details). For SSH-syncing you'll need ssh obviously and a functional public key setup with your endpoints.

##Usage
