FROM ubuntu:16.10

RUN mkdir -p /serving/bin && \
    mkdir -p /serving/conf && \
    mkdir -p /serving/tmp && \
    mkdir -p /serving/log && \
    mkdir -p /serving/model

COPY ./rootfs/ /
COPY ./bin /serving/bin/
COPY ./conf /serving/conf/

ENV APP_NAME="tf-serving" \
    IMAGE_VERSION="0.6.0" \
    PATH="/serving/bin:$PATH" \
    TENSORFLOW_SERVING_MODEL_NAME="inception" \
    TENSORFLOW_SERVING_PORT_NUMBER="9000"

WORKDIR /serving

VOLUME /serving/conf
VOLUME /serving/model

EXPOSE 9000

CMD ["/run.sh"]
