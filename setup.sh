#!/bin/bash

#
# Automatically configures mutagen sync for the current .ddev project.
#

echo "=> Checking ddev project"
if [ ! -d ".ddev" ]; then
  echo "[!] This does not appear to be a ddev project."
  echo "    Please run 'ddev config' and then re-run this script."
  exit 1
fi

echo "=> Checking to make sure mutagen and jq are installed"
if ! type "mutagen" > /dev/null 2>&1; then
  echo "  => mutagen is not installed. running 'brew install mutagen-io/mutagen/mutagen'"
  echo "     If you do not want to do this, press Ctrl+C in the next 5 seconds"
  sleep 5
  brew install mutagen-io/mutagen/mutagen
fi
if ! type "jq" > /dev/null 2>&1; then
  echo "  => jq is not installed. running 'brew install jq'"
  echo "     If you do not want to do this, press Ctrl+C in the next 5 seconds"
  sleep 5
  brew install jq
fi

echo "=> Setting up mutagen sync script in the current ddev project"
echo "  => Downloading mutagen hook script from:"
echo "     https://raw.githubusercontent.com/cweagans/ddev-mutagen/master/mutagen"
[ -d ".ddev/commands/host" ] || mkdir -p .ddev/commands/host
curl -s https://raw.githubusercontent.com/cweagans/ddev-mutagen/master/mutagen > .ddev/commands/host/mutagen
chmod +x .ddev/commands/host/mutagen

# If hooks are already present, let's not break their config.
if cat .ddev/config.yaml | grep "^hooks:" > /dev/null; then
  echo "=> It looks like you already have active hooks in your .ddev/config.yaml."
  echo "   To finish setup, you'll need to add/merge the following config into"
  echo "   what you already have configured:"
  echo
  echo
  cat << EOF
no_project_mount: true
hooks:
  pre-start:
    # Make sure we don't already have a session running; it can confuse syncing
    - exec-host: "ddev mutagen stop"
  post-start:
    # Start the mutagen sync process for this project.
    - exec-host: "ddev mutagen start"
  pre-stop:
    # Terminate the mutagen sync process for this project.
    - exec-host: "ddev mutagen stop
EOF
  echo
  echo
# Otherwise, we can safely just tack this onto the end of the .ddev/config.yaml and
# we're good to go.
else
  echo "=> Setting up .ddev/config.yaml to run the mutagen sync script"
  cat >> .ddev/config.yaml <<'config'
no_project_mount: true
hooks:
  post-start:
    # Start the mutagen sync process for this project.
    - exec-host: "ddev mutagen start"
  pre-stop:
    # Terminate the mutagen sync process for this project.
    - exec-host: "ddev mutagen stop"
config
fi

echo
echo "All set! Run 'ddev start' to start using mutagen."
echo
