#!/bin/bash

# Install Tuist, if not installed.
if ! command -v tuist &> /dev/null
then
    echo "Tuist not found, installing..."
    curl -Ls https://install.tuist.io | bash
fi

# Delete current Xcode Project.
rm -rf $PROJECT_NAME.xcodeproj

# Generate the tuist project.
tuist install
tuist generate
