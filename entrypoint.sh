#!/bin/bash

# input validation
if [[ -z "${TAG}" ]]; then
   echo "No tag name supplied"
   exit 1
fi

if [[ -z "${GITHUB_TOKEN}" ]]; then
   echo "No github token supplied"
   exit 1
fi

if [[ -z "${SHA}" ]]; then
   echo "No SHA supplied"
   exit 1
fi

# push the tag to github
git_refs_url=$(jq .repository.git_refs_url $GITHUB_EVENT_PATH | tr -d '"' | sed 's/{\/sha}//g')

echo "**pushing tag $TAG to repo $GITHUB_REPOSITORY with refs_url $git_refs_url"

else
  # create new tag
  curl -s -X POST $git_refs_url \
  -H "Authorization: token $GITHUB_TOKEN" \
  -d @- << EOF

  {
    "ref": "refs/tags/$TAG",
    "sha": "$SHA"
  }
EOF
