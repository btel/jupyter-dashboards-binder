FROM debian:8.5

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# install packages

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates

# create user

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

USER ${NB_USER}


RUN wget --quiet https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p $HOME/anaconda && \
    rm ~/anaconda.sh

ENV PATH $HOME/anaconda/bin:$PATH

# install jupyter-dashboards
RUN conda config --add channels conda-forge
RUN conda install jupyter_dashboards

# copy contents of dir
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

WORKDIR ${HOME}
