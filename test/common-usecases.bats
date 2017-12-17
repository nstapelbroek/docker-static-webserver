#/usr/bin/env bats

load helpers/environment
load helpers/assert_file
load helpers/assertions/all

setup () {
    __setup_environment
    __create_run_directory
}

@test "Replacing content within a CSS file" {
    FILE=$BATS_RUN_DIR/files/minified.css
    export BACKGROUND_COLOR=#000
    run /bin/sh $BATS_BINARY_DIR/instateEnvironment.sh $FILE
    assert_success "Replacing {container.env.BACKGROUND_COLOR} with $BACKGROUND_COLOR in $FILE"
    assert_file_refute_contains $FILE {container.env.BACKGROUND_COLOR}
    assert_file_contains $FILE background-color:#000;
}

@test "Replacing content within a JS file" {
    FILE=$BATS_RUN_DIR/files/minified.js
    export SOMEVAR="testing123"
    run /bin/sh $BATS_BINARY_DIR/instateEnvironment.sh $FILE
    assert_success "Replacing {container.env.SOMEVAR} with testing123 in $FILE"
    assert_file_refute_contains $FILE {container.env.SOMEVAR}
    assert_file_contains $FILE "loaded with envrionment var " + "testing123";
}

@test "Replacing content within a JSON file" {
    FILE=$BATS_RUN_DIR/files/config.json
    export BACKEND_EU_URL=https://eu.someservice.com
    export BACKEND_EU_PRIORITY=10
    export BACKEND_NA_URL='"https://na.someservice.com"' #also notice the wrapping values here
    export BACKEND_NA_PRIORITY=12
    run /bin/sh $BATS_BINARY_DIR/instateEnvironment.sh $FILE
    assert_success
    assert_file_refute_contains $FILE {container.env.BACKEND_EU_URL}
    assert_file_refute_contains $FILE {container.env.BACKEND_EU_PRIORITY}
    assert_file_refute_contains $FILE {container.env.BACKEND_NA_URL}
    assert_file_refute_contains $FILE {container.env.BACKEND_NA_PRIORITY}
    assert_file_contains $FILE '"location": "https://eu.someservice.com",'
    assert_file_contains $FILE '"priority" : 10'
    assert_file_contains $FILE '"location": "https://na.someservice.com",'
    assert_file_contains $FILE '"priority" : 12'
}

@test "Replacing content within a HTML file" {
    FILE=$BATS_RUN_DIR/files/webpage.html
    export GREETING="World"
    run /bin/sh $BATS_BINARY_DIR/instateEnvironment.sh $FILE
    assert_success "Replacing {container.env.GREETING} with $GREETING in $FILE"
    assert_file_refute_contains $FILE {container.env.GREETING}
    assert_file_contains $FILE '<h1>Hello World!</h1>'
}
