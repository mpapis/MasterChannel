# Master Channel

KDE Plazma widget alfor changing Master Channel, changes pulse audio
default channel, changes currently playing sink inputs (sounds) to the
new channel and sets `kmix` Master Channel.

## Installation

    curl -LO https://github.com/mpapis/MasterChannel/archive/master.tar.gz
    tar xzf master.tgz
    plasmapkg -i MasterChannel-master

## Requirements

- `RubyQt`
- installed `pacmd` command
- running `dbus` is required for `kmix` interaction

## Extra configurations

To prevent reseting playbacks to wrong channels after setting new
default - `module-stream-restore restore_device=false` has to be set in
`/etc/pulse/default.pa`:

    load-module module-stream-restore restore_device=false

In case `load-module module-stream-restore` was already there - only
update the line.

# Uninstallation

    plasmapkg -i MasterChannel
