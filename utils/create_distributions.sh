#!/bin/bash
set -e
FPM="bundle exec fpm"
mkdir -p _dist
MAINTAINER=$(git show HEAD --pretty='%aN <%aE>' -s)
VERSION=$(git describe --always)
function package {
    $FPM -s dir \
         -n srweb \
         -C _site \
         --force \
         --license MIT \
         --version "$VERSION" \
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
        --package "_dist/srweb-$VERSION.rpm" \
        --directories /var/www/html \
        .=/var/www/html
package -t tar \
        --package "_dist/srweb-$VERSION.tar.gz" \
        .="/srweb-$VERSION"

