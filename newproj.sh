#!/usr/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <project_name>"
    exit 1
fi

if ! [[ "$1" =~ ^[a-z]+$ ]]; then
    echo "Error: Project name must be a lowercase word."
    exit 1
fi

set -x #echo on
git ls-files | xargs sed -i -e "s/Greeter/${1^}/g"
git ls-files | xargs sed -i -e "s/greeter/${1,,}/g"
git ls-files | xargs sed -i -e "s/GREETER/${1^^}/g"
mkdir -p ./src/${1,,}
mkdir -p ./src/lib${1,,}
mkdir -p ./include/${1,,}
mv ./src/greeter/main.cpp ./src/${1,,}/main.cpp
mv ./src/greeter/CMakeLists.txt ./src/${1,,}/CMakeLists.txt
mv ./src/libgreeter/greeter.cpp ./src/lib${1,,}/${1,,}.cpp
mv ./include/greeter/greeter.h ./include/${1,,}/${1,,}.h
mv ./test/src/greeter.cpp ./test/src/${1,,}.cpp
rmdir ./src/greeter
rmdir ./src/libgreeter
rmdir ./include/greeter
mv README.md BUILDING.md
cat <<EOF
All done, you probably want to run:

   git add -A && git diff --staged

And if you're happy, something like:

   git commit -m "Initial commit for $1."

Otherwise, revert with

   git reset --hard HEAD && git clean -fd

EOF

