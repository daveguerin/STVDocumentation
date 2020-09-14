#! /bin/sh

set -e

cd ~/Xcode/@SwiftPackages/STV/

# module_version: 6.0.1(2)
OLD_MODULE_VERSION=$(yq read .jazzy.yaml module_version)

echo "\n\n**** STVDocumentation "$OLD_MODULE_VERSION

VERSION=`echo $OLD_MODULE_VERSION | awk -F "(" '{print $1}'`

OLD_BUILD=`echo $OLD_MODULE_VERSION | awk -F "(" '{print $2}'`

OLD_BUILD=`echo $OLD_BUILD | awk -F ")" '{print $1}'`

NEW_BUILD=$(($OLD_BUILD + 1))

NEW_MODULE_VERSION="${VERSION}(${NEW_BUILD})"

# deletes the copyright line, which is the last line
sed -i '' '/^copyright/d' .jazzy.yaml

DATE=`(date +"%Y%m%d")`

YEAR=`(date +"%Y")`

COPYRIGHT="copyright: \"[STV ${NEW_MODULE_VERSION}](https://github.com/daveguerin/STV/) ${DATE}<br />&copy; Copyright 2010 - 2015 [Sensible Cocoa](http://sensiblecocoa.com/)<br />&copy; Copyright 2019 - ${YEAR} [dgApps](http://dgapps.ie/)<br />[STV](https://github.com/daveguerin/STV/) and it's [Documentation](https://github.com/daveguerin/STVDocumentation/) are licensed under a [MIT License](https://github.com/daveguerin/STV/blob/master/License/STV.txt)\""

echo "\n**** STVDocumentation Updating to "$NEW_MODULE_VERSION

yq write -i .jazzy.yaml module_version "${NEW_MODULE_VERSION}"

#yq had problems with ' and " and ` so this appends the copyright line to the bottom of the file
echo "${COPYRIGHT}" >> .jazzy.yaml

STV="STV "

# replaces the first line with STV 6.0.1(2) for example
sed -i '' '1 s/^#.*$/'"# $STV $NEW_MODULE_VERSION"'/' DOCUMENTATION.md


jazzy

echo "\n**** STVDocumentation Committing STV"

COMMIT_MESSAGE="STVDocumentation Updated to ${NEW_MODULE_VERSION}"

git add .jazzy.yaml
git add DOCUMENTATION.md
git commit -m "$COMMIT_MESSAGE"

echo "\n**** STVDocumentation Pushing STV"

git push GitHub main


echo "\n**** STVDocumentation Committing STVDocumentation"

cd ~/Xcode/@Documentation/STVDocumentation/

git add --all

git commit -m "$COMMIT_MESSAGE"


echo "\n**** STVDocumentation Tagging STVDocumentation"


git tag -a "${NEW_MODULE_VERSION}" -m "${NEW_MODULE_VERSION}"


echo "**** STVDocumentation Pushing STVDocumentation"

git push GitHub main --tags


echo "\n\n**** STVDocumentation Updated ****\n\n\n\n\n\n\n"



