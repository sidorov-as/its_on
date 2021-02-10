#!/bin/bash

if [ -z "$1" ]
  then
    echo "No argument supplied"
    exit 1
elif [ $1 = "test" ]
  then
    exec make check
    exit $?
elif [ $1 = "run" ]
  then
    alembic upgrade head
    rm -rf /srv/www/its_on/static
    cp -r /its_on/its_on/static /srv/www/its_on
    exec gunicorn --bind 0.0.0.0:8081 \
                  --capture-output \
                  --workers 3 \
                  --access-logfile - \
                  --error-logfile - \
                  --log-level info \
                  --worker-class aiohttp.GunicornUVLoopWebWorker \
                  its_on.main:init_gunicorn_app
    exit $?
else
  echo "Invalid argument"
  exit 1
fi
