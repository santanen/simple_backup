# simple_backup
An rsync/ssh based backup script with configuration options for multiple endpoints and directory structures each. *Simple_backup* is inspired by Mike Rubel's http://www.mikerubel.org/computers/rsync_snapshots/. Read it to understand the approach.

##Features

- full rolling backups with hard links between unchanged objects (save space)
- uses rsync locally and over ssh
- supports multiple "endpoints", thus syncing from multiple servers
- supports multiple sync locations (directories) per endpoint
- rolling sync and snapshot style (e.g. rolling daily and snapshot every week)

##Requirements

Simple_backup relies on [rsync](https://rsync.samba.org/) and common binaries (see common.config for details). For SSH-syncing you'll need [ssh](http://www.openssh.com/) obviously and a [functional public key setup with your endpoints](http://linuxconfig.org/passwordless-ssh).

##Usage

1. Clone the repo to your hard drive
2. Make common configurations to common.config (e.g. where you want to put your backups etc.)
3. Create an endpoint directory by copying the www.example.com.d directory and give it a name that ends with `.d`
4. Configure your endpoint by editing in the endpoint's directory `endpoint.config` and entering required settings.
5. **IF** you want to run a remote command automatically prior to the backup procedure itself, keep the `endpoint_script.sh`and put your commands there (example: dump your database to a file to be backed up). Otherwise delete the file!!!!!!!!!
6. **Make sure your public key authentication via SSH works to your endpoint**.
7. Repeate steps 3-6 for each endpoint.
8. Run `./simple_backup.sh` to make first run. If it works, you may do it again and observe how your backup directory is populated.
9. To make a snapshot, run `./simple_backup.sh [snapshot_name]`. [snapshot_name] can be e.g. weekly or monthly or whatever. Your backup directory will start building snapshots with that name.
10. Once everything works from the command line, I recommend preparing meaningful **cron jobs** to get things automated.

## Notes

1. Rolling backups as well as snapshots are statically defined to keep 4 consecutive versions, not more or less. The amount of consecutive versions to be kept in the backup archive should be set in the configuration file(s), but that is for later...
2. Be careful with slashes `/` in the directory listings etc. I should have added a bit more automatic prettyfying in the scripts...
3. I use rolling backups on a daily basis and on top of that weekly and monthly snapshots. Thus I have always approx 4 months of pretty decent backups available.



