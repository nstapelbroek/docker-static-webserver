#/usr/bin/env bats

load helpers/environment
load helpers/assert_file
load helpers/assertions/all

setup () {
    __setup_environment
    __create_run_directory
}

@test "Gracefully warns when a variable is undefined" {
    FILE=$BATS_RUN_DIR/files/multiline-multimatches.txt
    run /bin/sh $BATS_BINARY_DIR/instateEnvironment.sh $FILE
    assert_success
    assert_file_contains $FILE {container.env.BATS_VARIABLE}
    assert_file_contains $FILE {container.env.BATS_VARIABLE_SECOND}
    assert_output_contains "Could not replace {container.env.BATS_VARIABLE} due to a missing environment variable"
    assert_output_contains "Could not replace {container.env.BATS_VARIABLE_SECOND} due to a missing environment variable"
}