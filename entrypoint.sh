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

if [[ -z "${MESSAGE}" ]]; then
   echo "No MESSAGE supplied"
   exit 1
fi

# push the tag to github
# git_refs_url=$(jq .repository.git_refs_url $GITHUB_EVENT_PATH | tr -d '"' | sed 's/{\/sha}//g')
git_refs_url="https://api.github.com/repos/${GITHUB_REPOSITORY}/git/refs"
git_tags_url="https://api.github.com/repos/${GITHUB_REPOSITORY}/git/tags"

echo "**pushing tag $TAG to repo $GITHUB_REPOSITORY with refs_url ${git_refs_url} and tags url ${git_tags_url}"

response=$(curl -s -X POST $git_tags_url \
-H "Authorization: token $GITHUB_TOKEN" \
-d @- << EOF

{
  "tag": "$TAG",
  "object": "$SHA",
  "message": "$MESSAGE",
  "type": "commit"
}
EOF
)

tag_sha=$(jq -r '.sha' <(echo "$response"))

echo created the tag ${tag_sha}

#   # create new ref
curl -s -X POST $git_refs_url \
-H "Authorization: token $GITHUB_TOKEN" \
-d @- << EOF

{
  "ref": "refs/tags/$TAG",
  "sha": "$tag_sha"
}
EOF


