FROM ubuntu:24.04

LABEL version="1.0"
LABEL description="Docker File for LCarlin Personal DataWare House based on Python."
LABEL org.opencontainers.image.title="LCarlin Personal DataWareHouse" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.description="Projeto ETL em Python para processamento de planilhas e geração de relatórios." \
      org.opencontainers.image.authors="Luiz Carlin <luiz.carlin@gmail.com>" \
      org.opencontainers.image.vendor="Luiz Carlin - São Paulo, Brasil"

RUN apt update && \
    apt install -y software-properties-common curl git build-essential zlib1g-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev libncursesw5-dev xz-utils tk-dev

RUN curl -O https://www.python.org/ftp/python/3.13.5/Python-3.13.5.tgz && \
    tar -xzf Python-3.13.5.tgz && \
    cd Python-3.13.5 && \
    ./configure --enable-optimizations && \
    make -j$(nproc) && \
    make altinstall && \
    cd .. && rm -rf Python-3.13.5*

RUN ln -s /usr/local/bin/python3.13 /usr/local/bin/python

RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python

COPY files_to_containner/ /app/
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Setar timezone para America/Sao_Paulo
ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

CMD ["python", "PersonalDataWareHouse.py"]
