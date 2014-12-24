#!/bin/bash
getent passwd wwwcontent >/dev/null || \
    useradd -r -d /var/wwwcontent -s /sbin/nologin \
    -c 'Owner of all/most web content' wwwcontent

