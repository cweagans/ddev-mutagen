# ddev-mutagen

Uses mutagen to sync files into and out of a ddev web container and completely bypasses osxfs or nfs.

**NOTE**: ddev is getting built-in mutagen support. See https://github.com/cweagans/ddev-mutagen/issues/7 for details. When mutagen support lands in ddev, this project will be archived.

## Requirements

This script requires ddev **v1.14.0** or newer. This method **will not work** with any ddev version older than that.

## Usage

1. Read the setup script. It's really short and won't take you very much time.
2. No, seriously. Go read it. You're about to pipe commands from a stranger on the internet into your computer.
3. `curl https://raw.githubusercontent.com/cweagans/ddev-mutagen/master/setup.sh | bash`
