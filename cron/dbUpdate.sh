#!/bin/sh

FILENAME=medied_$(date '+%Y-%m-%d-%H%M').sql
MINIO_DATA_DIR=/opt/medied/data/minio/data
MINIO_BUCKET_NAME=dbdump

docker run --rm --link postgres:postgres --network=## -v $MINIO_DATA_DIR/$MINIO_BUCKET_NAME/:/pgdump -e PGPASSWORD="admin" postgres pg_dump -f /pgdump/$FILENAME -h postgres -U admin ## 2>&1
gzip $MINIO_DATA_DIR/$MINIO_BUCKET_NAME/$FILENAME
