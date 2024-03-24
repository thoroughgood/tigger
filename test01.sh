#!/bin/dash
PATH="$PATH:$(pwd)"

# Create a temporary directory for the test.
test_dir="$(mktemp -d)"
cd "$test_dir" || exit 1

# Create some files to hold output.

expected_output="$(mktemp)"
actual_output="$(mktemp)"

# Remove the temporary directory when the test is done.

trap 'rm "$expected_output" "$actual_output" -rf "$test_dir"' INT HUP QUIT TERM EXIT

#create tigger repository


cat > "$expected_output" <<EOF
Initialized empty tigger repository in .tigger
EOF

tigger-init > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

#create file

echo "First line" > a

#tigger add error
cat > "$expected_output" <<EOF
usage: tigger-add <filenames>
EOF

tigger-add > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi


#proper tigger add

cat > "$expected_output" <<EOF
EOF

tigger-add a > "$actual_output" 2>&1

#things

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi



#tigger-add error again
cat > "$expected_output" <<EOF
tigger-add: error: can not open 'b'
EOF

tigger-add b > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

#empty string

cat > "$expected_output" <<EOF
tigger-add: error: invalid filename ' '
EOF

tigger-add " " > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

echo "Passed test"
exit 0