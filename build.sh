#!/bin/zsh

if [[ ! -v ASOC_ARCH_PATH ]];
then
  echo "Set ASOC_ARCH_PATH var!"
  return
fi

rm -rf ./public/documentation/*
cp -r ${ASOC_ARCH_PATH}/* ./public/documentation/
mv ./public/documentation/dochub.yaml ./public/documentation/root.yaml
docker-compose build nginx --no-cache
docker save dochub:latest -o dochub.img

