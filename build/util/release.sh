#! /bin/bash

TAG=release-$(date +%s)

echo "Releasing tag: $TAG"
git tag $TAG
git push origin tag $TAG
