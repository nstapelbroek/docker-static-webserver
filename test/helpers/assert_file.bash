#!/usr/bin/env sh

assert_file_refute_contains () {
  local haystack="$1"
  local needle="$2"
  if grep -q "$needle" $haystack; then
    {
        echo "expected:       $(cat $haystack)"
        echo "not to contain: $needle"
    } | flunk
  fi
}

assert_file_contains() {
    local haystack="$1"
    local needle="$2"
    if ! grep -q "$needle" $haystack; then
        {
            echo "expected:       $(cat $haystack)"
            echo "to contain: $needle"
        } | flunk
    fi
}