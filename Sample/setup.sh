#!/bin/bash 

PROJECT_NAME="TruePokemonSampleApp"

# Install Mise, if not installed.
if ! brew ls --versions mise > /dev/null 2>&1; then
  echo "mise not found in Homebrew, installing..."
  brew install mise
fi

# Install Tuist, if not installed.
if ! command -v tuist &> /dev/null; then
  echo "tuist not found, installing via mise..."
  mise install tuist
fi

# Delete current Xcode Project.
rm -rf $PROJECT_NAME.xcodeproj
rm -rf $PROJECT_NAME.xcworkspace

# Generate the tuist project.
mise x -- tuist install
mise x -- tuist generate
