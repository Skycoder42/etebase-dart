#!/bin/bash
set -eo pipefail

mkdir -p .git/hooks

cat << EOF > .git/hooks/pre-commit
#!/bin/bash
set -eo pipefail

echo '=== Checking etebase ==='
pushd packages/etebase > /dev/null
dart run dart_pre_commit
popd > /dev/null

echo '=== Checking etebase_flutter ==='
pushd packages/etebase_flutter > /dev/null
dart run dart_pre_commit
popd > /dev/null
EOF
chmod a+x .git/hooks/pre-commit
