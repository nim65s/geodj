FROM alpine:edge

EXPOSE 8000

RUN mkdir /app
WORKDIR /app

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories \
 && apk update -q \
 && apk add --no-cache \
    gdal \
    geos \
    postgis \
    proj \
    py3-gunicorn \
    py3-psycopg2 \
    py3-raven \
 && pip3 install --no-cache-dir \
    pipenv \
    python-memcached \
 && ln -s /usr/lib/libproj.so.15 /usr/lib/libproj.so

ADD Pipfile Pipfile.lock ./
RUN pipenv install --system --deploy

CMD while ! nc -z postgres 5432; do sleep 1; done \
 && ./manage.py migrate \
 && ./manage.py collectstatic --no-input \
 && gunicorn \
    --bind 0.0.0.0 \
    testproject.wsgi

ADD . .
