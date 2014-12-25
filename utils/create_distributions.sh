#!/bin/bash
set -e
FPM="bundle exec fpm"
mkdir -p _dist
MAINTAINER=$(git show HEAD --pretty='%aN <%aE>' -s)
if [ -n "$CI_PULL_REQUESTS" ]; then
    VERSION="pr"
    RELEASE="$CIRCLE_BUILD_NUM"
elif [ -n "$CIRCLE_BRANCH" ]; then
    VERSION=$(echo "$CIRCLE_BRANCH" | tr '[:lower:]' '[:upper:]')
    RELEASE="$CIRCLE_BUILD_NUM"
else
    VERSION="dev"
    RELEASE=$(git describe 2>/dev/null || (git rev-list HEAD | wc -l | tr -d ' '))
fi
function package {
    $FPM -s dir \
         -n srweb \
         -C _site \
         --force \
         --license MIT \
         --version "$VERSION" \
         --iteration "$RELEASE" \
         --vendor "Student Robotics" \
         --maintainer "$MAINTAINER" \
         --description "Student Robotics website content" \
         --architecture all \
         --url 'https://www.studentrobotics.org/cgit/srweb.git/' \
         $*
}
package -t rpm \
        --rpm-os linux \
        --rpm-use-file-permissions \
        --rpm-user wwwcontent \
        --rpm-group apache \
        --package "_dist/srweb-$VERSION-$RELEASE.rpm" \
        -d shadow-utils \
        --before-install utils/create_user_fedora.sh \
        --directories /var/www/html \
        .=/var/www/html
package -t tar \
        --package "_dist/srweb-$VERSION-$RELEASE.tar.gz" \
        .="/srweb-$VERSION-$RELEASE"

