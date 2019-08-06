FROM python:3.7-alpine

EXPOSE 8000

RUN mkdir /app
WORKDIR /app

RUN apk update -q \
 && apk add --no-cache \
    py3-gunicorn \
    py3-psycopg2 \
    py3-raven \
 && pip3 install --no-cache-dir \
    pipenv \
    python-memcached

ENV PYTHONPATH=/usr/lib/python3.7/site-packages:/usr/local/lib/python3.7/site-packages

ADD Pipfile Pipfile.lock ./
RUN pipenv install --system --deploy

ADD . .

CMD while ! nc -z postgres 5432; do sleep 1; done \
 && ./manage.py migrate \
 && ./manage.py collectstatic --no-input \
 && gunicorn \
    --bind 0.0.0.0 \
    testproject.wsgi
