#!/usr/bin/env sh

__setup_environment () {
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    export BATS_BINARY_DIR=$DIR/../../files/bin
    export BATS_ORIGINAL_FILES_DIR=$DIR/../files
    export BATS_RUN_DIR=$DIR/../run
}

__create_run_directory() {
    mkdir -p $BATS_RUN_DIR/files
    cp -rf $BATS_ORIGINAL_FILES_DIR $BATS_RUN_DIR
}