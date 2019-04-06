#/usr/bin/env bats

load helpers/environment
load helpers/assert_file
load helpers/assertions/all

setup () {
    # @todo: fix test for [] since it breaks the grep assertion
    
    __setup_environment
    __create_run_directory
    export BATS_VARIABLE='nstapelbroek-was-here'
}

@test "Replacing a normal symlink" {
    FILE=$BATS_RUN_DIR/files/symlink_to_singleline.txt
    run /bin/sh $BATS_BINARY_DIR/instateEnvironment.sh $FILE
    assert_success "Replacing {container.env.BATS_VARIABLE} with $BATS_VARIABLE in $FILE"
    assert_file_refute_contains $FILE {container.env.BATS_VARIABLE}
    assert_file_contains $FILE $BATS_VARIABLE
}

@test "Replacing a symlink to a symlink" {
    FILE=$BATS_RUN_DIR/files/symlink_to_symlink
    run /bin/sh $BATS_BINARY_DIR/instateEnvironment.sh $FILE
    assert_success "Replacing {container.env.BATS_VARIABLE} with $BATS_VARIABLE in $FILE"
    assert_file_refute_contains $FILE {container.env.BATS_VARIABLE}
    assert_file_contains $FILE $BATS_VARIABLE
}

@test "Replacing a dead_symlink" {
    FILE=$BATS_RUN_DIR/files/dead_symlink
    ln -s $BATS_RUN_DIR/files/does_not_exists $FILE
    run /bin/sh $BATS_BINARY_DIR/instateEnvironment.sh $FILE
    assert_failure
    rm -rf $FILE
}

@test "Replacing a non existing file" {
    FILE=$BATS_RUN_DIR/files/does_not_exist
    run /bin/sh $BATS_BINARY_DIR/instateEnvironment.sh $FILE
    assert_failure
}