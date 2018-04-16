#!/bin/bash

if [ "$TRAVIS_PULL_REQUEST" = "false" ] ; then
    echo "not pull request"
else
    URL=$(curl -s http://127.0.0.1:4040/status | grep -P "http://.*?ngrok.io" -oh)"/vnc_auto.html"
    COMMENT="View it ${URL} for $1"
    curl -H "Authorization: token $GITHUB_OAUTH_TOKEN" -X POST -d "{\"body\": \"$COMMENT\"}" "https://api.github.com/repos/${TRAVIS_REPO_SLUG}/issues/${TRAVIS_PULL_REQUEST}/comments"
fi