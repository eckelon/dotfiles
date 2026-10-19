#!/bin/bash
# Helium ships with Sparkle auto-update; upgrades must go through Homebrew only
# (`brew upgrade --cask helium-browser`), otherwise the app replaces itself and
# brew's Caskroom version drifts.
set -euo pipefail

defaults write net.imput.helium SUEnableAutomaticChecks -bool false
defaults write net.imput.helium SUAutomaticallyUpdate -bool false
