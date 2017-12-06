#/usr/bin/env bats

load helpers/environment
load helpers/assert_file
load helpers/assertions/all

setup () {
    __setup_environment
    __create_run_directory
    export BATS_VARIABLE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    export BATS_VARIABLE_SECOND=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
}

@test "Replacing a single alphanumeric variable on a single line" {
    FILE=$BATS_RUN_DIR/files/singleline.txt
    run /bin/bash $BATS_BINARY_DIR/instateEnvironment.sh $FILE
    assert_success "Replacing {container.env.BATS_VARIABLE} with $BATS_VARIABLE in $FILE"
    assert_file_refute_contains $FILE {container.env.BATS_VARIABLE}
    assert_file_contains $FILE $BATS_VARIABLE
}

@test "Replacing multiple alphanumeric variables on a single line" {
    FILE=$BATS_RUN_DIR/files/singleline-multimatches.txt
    run /bin/bash $BATS_BINARY_DIR/instateEnvironment.sh $FILE
    assert_success
    assert_output_contains "Replacing {container.env.BATS_VARIABLE} with $BATS_VARIABLE in $FILE"
    assert_output_contains "Replacing {container.env.BATS_VARIABLE_SECOND} with $BATS_VARIABLE_SECOND in $FILE"
    assert_file_refute_contains $FILE {container.env.BATS_VARIABLE}
    assert_file_contains $FILE $BATS_VARIABLE
    assert_file_refute_contains $FILE {container.env.BATS_VARIABLE_SECOND}
    assert_file_contains $FILE $BATS_VARIABLE_SECOND
}

@test "Replacing a single alphanumeric variable on multiple lines" {
    FILE=$BATS_RUN_DIR/files/multiline.txt
    run /bin/bash $BATS_BINARY_DIR/instateEnvironment.sh $FILE
    assert_success
    assert_output_contains "Replacing {container.env.BATS_VARIABLE} with $BATS_VARIABLE in $FILE"
    assert_file_refute_contains $FILE {container.env.BATS_VARIABLE}
    assert_file_contains $FILE $BATS_VARIABLE
}

@test "Replacing multiple alphanumeric variables on multiple lines" {
    FILE=$BATS_RUN_DIR/files/multiline-multimatches.txt
    run /bin/bash $BATS_BINARY_DIR/instateEnvironment.sh $FILE
    assert_success
    assert_output_contains "Replacing {container.env.BATS_VARIABLE} with $BATS_VARIABLE in $FILE"
    assert_output_contains "Replacing {container.env.BATS_VARIABLE_SECOND} with $BATS_VARIABLE_SECOND in $FILE"
    assert_file_refute_contains $FILE {container.env.BATS_VARIABLE}
    assert_file_contains $FILE $BATS_VARIABLE
    assert_file_refute_contains $FILE {container.env.BATS_VARIABLE_SECOND}
    assert_file_contains $FILE $BATS_VARIABLE_SECOND
}

