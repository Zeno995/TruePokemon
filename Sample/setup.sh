#!/bin/bash

# Delete current Xcode Project.
rm -rf $PROJECT_NAME.xcodeproj

# Generate the tuist project.
tuist install
tuist generate
