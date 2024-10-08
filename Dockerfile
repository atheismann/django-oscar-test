FROM python:3.11
ENV PYTHONUNBUFFERED 1

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs npm

COPY ./requirements.txt /requirements.txt
RUN pip3 install -r /requirements.txt

RUN groupadd -r django && useradd -r -g django django
COPY . /app
RUN chown -R django /app

WORKDIR /app

RUN make install

USER django

RUN make build_sandbox

RUN cp --remove-destination /app/src/oscar/static/oscar/img/image_not_found.jpg /app/sandbox/public/media/

ENV PGSSLCERT /tmp/postgresql.crt

EXPOSE 8080

WORKDIR /app/sandbox/
CMD uwsgi --ini uwsgi.ini
