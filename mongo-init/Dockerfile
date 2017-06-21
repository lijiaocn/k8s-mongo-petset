FROM mongo
MAINTAINER lijiaocn <lijiaocn@foxmail.com>

WORKDIR /

ENV  DELETE_EXSITING_DATA  no

ENV  MONGODB_HIDDEN_USER  forbiddenchangesystemroot
ENV  MONGODB_HIDDEN_PWD   forbbiden

ENV  MONGODB_DEF_USER  systemroot
ENV  MONGODB_DEF_PWD   sys123root

COPY entrypoint.sh /

CMD ["/bin/bash", "/entrypoint.sh"]
