FROM node:0.10.46

RUN apt-get install -y make

RUN npm install -g phantomjs-prebuilt
RUN npm install -g casperjs

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

ENTRYPOINT ["/bin/bash"]

ENV MYSQL_HOST="DB_Server"
ENV MYSQL_USER="operations"
ENV MYSQL_PASSWORD="5TTnvuTDJJSq6"

