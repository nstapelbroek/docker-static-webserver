#/usr/bin/env bats

load helpers/environment
load helpers/assert_file
load helpers/assertions/all

setup () {
    __setup_environment
    __create_run_directory
    export BATS_VARIABLE='\&\^\\'
    export BATS_VARIABLE_SECOND='\&\^\\'
}

@test "Replacing a single sed-escaped-character variable on a single line" {
    FILE=$BATS_RUN_DIR/files/singleline.txt
    run /bin/sh $BATS_BINARY_DIR/instateEnvironment.sh $FILE
    assert_success
    assert_file_refute_contains $FILE {container.env.BATS_VARIABLE}
    assert_file_contains $FILE $BATS_VARIABLE
}

@test "Replacing multiple sed-escaped-character variables on a single line" {
    FILE=$BATS_RUN_DIR/files/singleline-multimatches.txt
    run /bin/bash $BATS_BINARY_DIR/instateEnvironment.sh $FILE
    assert_success
    assert_file_refute_contains $FILE {container.env.BATS_VARIABLE}
    assert_file_contains $FILE $BATS_VARIABLE
    assert_file_refute_contains $FILE {container.env.BATS_VARIABLE_SECOND}
    assert_file_contains $FILE $BATS_VARIABLE_SECOND
}

@test "Replacing a single sed-escaped-character variable on multiple lines" {
    FILE=$BATS_RUN_DIR/files/multiline.txt
    run /bin/sh $BATS_BINARY_DIR/instateEnvironment.sh $FILE
    assert_success
    assert_file_refute_contains $FILE {container.env.BATS_VARIABLE}
    assert_file_contains $FILE $BATS_VARIABLE
}

@test "Replacing multiple sed-escaped-character variables on multiple lines" {
    FILE=$BATS_RUN_DIR/files/multiline-multimatches.txt
    run /bin/sh $BATS_BINARY_DIR/instateEnvironment.sh $FILE
    assert_success
    assert_file_refute_contains $FILE {container.env.BATS_VARIABLE}
    assert_file_contains $FILE $BATS_VARIABLE
    assert_file_refute_contains $FILE {container.env.BATS_VARIABLE_SECOND}
    assert_file_contains $FILE $BATS_VARIABLE_SECOND
}

