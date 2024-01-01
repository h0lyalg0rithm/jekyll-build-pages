#!/bin/bash

####################################################################################################
#
# Calls github-pages executable to build the site using allowed plugins and supported configuration
#
####################################################################################################

SOURCE_DIRECTORY=${GITHUB_WORKSPACE}/$INPUT_SOURCE
DESTINATION_DIRECTORY=${GITHUB_WORKSPACE}/$INPUT_DESTINATION
PAGES_GEM_HOME=$BUNDLE_APP_CONFIG
GITHUB_PAGES_BIN=$PAGES_GEM_HOME/bin/github-pages
JEKYLL_BIN="bundle exec jekyll"
DISABLE_WHITELIST=true

# Set environment variables required by supported plugins
export JEKYLL_ENV="production"
export PAGES_REPO_NWO=$GITHUB_REPOSITORY
export JEKYLL_BUILD_REVISION=$INPUT_BUILD_REVISION
export PAGES_API_URL=$GITHUB_API_URL

# Set verbose flag
if [ "$INPUT_VERBOSE" = 'true' ]; then
  VERBOSE='--verbose'
else
  VERBOSE=''
fi

# Set future flag
if [ "$INPUT_FUTURE" = 'true' ]; then
  FUTURE='--future'
else
  FUTURE=''
fi

# Enter source code directory
{ cd "$SOURCE_DIRECTORY" || { echo "::error::pages gem not found"; exit 1; }; }

# Install required gems
bundle install -j8

# Run the command, capturing the output
build_output="$($JEKYLL_BIN build --trace "$VERBOSE" "$FUTURE" --source "$SOURCE_DIRECTORY" --destination "$DESTINATION_DIRECTORY")"

# Capture the exit code
exit_code=$?

if [ $exit_code -ne 0 ]; then
  # Remove the newlines from the build_output as annotation not support multiline
  error=$(echo "$build_output" | tr '\n' ' ' | tr -s ' ')
  echo "::error::$error"
else
  # Display the build_output directly
  echo "$build_output"
fi

# Exit with the captured exit code
exit $exit_code
