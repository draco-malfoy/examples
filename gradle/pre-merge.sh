#!/bin/bash -e
BUILD_NAME=${GITHUB_RUN_ID:=local-$(date +%s)}

pip3 install --user launchable~=1.0 > /dev/null

export PATH=~/.local/bin:$PATH

launchable verify

launchable record build --name "$BUILD_NAME" --source ..

launchable subset --target 25% --build "$BUILD_NAME" gradle src/test/java > subset.txt

cat subset.txt

function record() {
  launchable record tests --build "$BUILD_NAME" gradle build/test-results/test
}

trap record EXIT

./gradlew test $(< subset.txt)
