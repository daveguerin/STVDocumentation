#! /bin/sh

set -e

cd ~/Xcode/@SwiftPackages/STV/

# module_version: 6.0.1 (2)
OLD_MODULE_VERSION=$(yq read .jazzy.yaml module_version)

echo "\n\n**** STVDocumentation "$OLD_MODULE_VERSION

VERSION=`echo $OLD_MODULE_VERSION | awk -F "(" '{print $1}'`

OLD_BUILD=`echo $OLD_MODULE_VERSION | awk -F "(" '{print $2}'`

OLD_BUILD=`echo $OLD_BUILD | awk -F ")" '{print $1}'`

NEW_BUILD=$(($OLD_BUILD + 1))

NEW_MODULE_VERSION="${VERSION}(${NEW_BUILD})"

echo "\n**** STVDocumentation Updating to "$NEW_MODULE_VERSION

yq write -i .jazzy.yaml module_version "${NEW_MODULE_VERSION}"

jazzy

echo "\n**** STVDocumentation Committing STV"

COMMIT_MESSAGE="STVDocumentation Updated to ${NEW_MODULE_VERSION}"

git add .jazzy.yaml
git commit -m "$COMMIT_MESSAGE"

echo "\n**** STVDocumentation Pushing STV"

git push GitHub master


echo "\n**** STVDocumentation Committing STVDocumentation"

cd ~/Xcode/@Documentation/STVDocumentation/

git add --all

git commit -m "$COMMIT_MESSAGE"


echo "\n**** STVDocumentation Tagging STVDocumentation"


git tag -a "${NEW_MODULE_VERSION}" -m "${NEW_MODULE_VERSION}"


echo "**** STVDocumentation Pushing STVDocumentation"

git push GitHub master --tags


echo "\n\n**** STVDocumentation Updated ****\n\n\n\n\n\n\n"
