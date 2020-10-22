FROM ubuntu:16.04
MAINTAINER Soo Lee (duplexa@gmail.com)

# 1. general updates & installing necessary Linux components
RUN apt-get update -y && apt-get install -y \
        bzip2 \
        gcc \
        git \
        less \
        libncurses-dev \
        make \
        time \
        unzip \
        vim \
        wget \
        zlib1g-dev \
        liblz4-tool \
        libcurl4-openssl-dev \
        libssl-dev

# installing conda
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && bash Miniconda3-latest-Linux-x86_64.sh -p /miniconda3 -b
ENV PATH=/miniconda3/bin:$PATH
RUN conda update -y conda \
    && rm Miniconda3-latest-Linux-x86_64.sh

#Setting the enviroment
COPY environment.yml .
RUN conda env update -n root --file environment.yml

# supporting UTF-8
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

#Setting working directory & path
WORKDIR /usr/local/bin

# wrapper
COPY scripts/ .
RUN chmod +x run*.sh

# default command
CMD ["ls","/usr/local/bin"]
