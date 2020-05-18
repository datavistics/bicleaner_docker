# From https://github.com/cadia-lvl/SMT/blob/25adb952293e9bb78d15350a3afb3f0a1f2cd09c/moses/Dockerfile
################################################################################
# Moses and MGIZA
################################################################################
FROM haukurp/moses-smt:1.1.0

################################################################################
# KENLM
################################################################################
ENV KENLM_TOOLS=/opt/kenlm_tools
# https://github.com/kpu/kenlm/blob/master/BUILDING
ENV KENLM_PACKAGES="build-essential \
     cmake \
     libboost-system-dev \
     libboost-thread-dev \
     libboost-program-options-dev \
     libboost-test-dev \
     libeigen3-dev \
     zlib1g-dev \
     libbz2-dev \
     liblzma-dev"
WORKDIR /opt

RUN apt update \
    && apt install -q -y ${KENLM_PACKAGES} \
    && git clone https://github.com/kpu/kenlm.git \
    && cd kenlm \
    && mkdir -p build \
    && cd build \
    && cmake .. \
    && make -j 4 \
    && mkdir -p ${KENLM_TOOLS} \
    && cp ./bin/* ${KENLM_TOOLS} \
    && cd /opt \
    && rm -rf kenlm \
    && apt autoremove -y -q

RUN export PATH=${PATH}:${KENLM_TOOLS}


################################################################################
# Bifixer and Bicleaner and tmxt
################################################################################
ENV PYTHON_PACKAGES="python3.7-dev python3-pip gcc"
RUN apt update \
    && apt install -q -y ${PYTHON_PACKAGES}

RUN git clone https://github.com/bitextor/bifixer.git
RUN git clone http://github.com/sortiz/tmxt
RUN python3.7 -m pip install -r ./bifixer/requirements.txt
RUN python3.7 -m pip install bicleaner
RUN git clone https://github.com/bitextor/bicleaner

RUN python3.7 -m pip install https://github.com/kpu/kenlm/archive/master.zip
RUN python3.7 -m pip install -r tmxt/requirements.txt
ENV PATH="/opt/kenlm_tools:/opt/bin:/opt/moses_tools:${PATH}"