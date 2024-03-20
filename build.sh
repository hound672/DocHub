#!/bin/zsh

if [[ ! -v ASOC_ARCH_PATH ]];
then
  echo "Set ASOC_ARCH_PATH var!"
  return
fi

rm -rf ./public/documentation/*
cp -r ${ASOC_ARCH_PATH}/* ./public/documentation/

