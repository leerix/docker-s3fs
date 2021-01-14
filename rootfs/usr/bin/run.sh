#!/usr/bin/env sh

key=$AWS_ACCESS_KEY_ID
secret=$AWS_SECRET_ACCESS_KEY

if [ -z ${key+x} ] || [ -z ${secret+x} ]; then
  true
else
  echo $key:$secret > ${HOME}/.passwd-s3fs
  chmod 0600 ${HOME}/.passwd-s3fs
fi


s3fs $BUCKET $MOUNT_DIR -f ${URL:+-o url=$URL} ${ENDPOINT:+-o endpoint=$ENDPOINT} ${MOUNT_ACCESS}
