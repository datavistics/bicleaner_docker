# From https://github.com/cadia-lvl/SMT/blob/25adb952293e9bb78d15350a3afb3f0a1f2cd09c/moses/Dockerfile
################################################################################
# Moses and MGIZA
################################################################################
FROM haukurp/moses-smt:1.1.0

ENV PYTHON_PACKAGES="python3.7-venv python3.7-dev python3-pip gcc"
RUN apt update \
    && apt install -q -y ${PYTHON_PACKAGES}

RUN python3.7 -m venv /opt/venv


################################################################################
# KENLM
################################################################################
ENV KENLM_TOOLS=/opt/kenlm_tools
# https://github.com/kpu/kenlm/blob/master/BUILDING
# https://github.com/kpu/kenlm/issues/79#issuecomment-272701974 took too much effort to find...
ENV KENLM_PACKAGES="build-essential \
     cmake \
     libboost-system-dev \
     libboost-thread-dev \
     libboost-program-options-dev \
     libboost-test-dev \
     libeigen3-dev \
     zlib1g-dev \
     libbz2-dev \
     libboost-all-dev \
     liblzma-dev"
WORKDIR /opt

RUN apt update \
    && apt install -q -y ${KENLM_PACKAGES} \
    && git clone https://github.com/kpu/kenlm.git \
    && cd kenlm \
    && mkdir -p build \
    && /opt/venv/bin/python -m pip install . --install-option="--max_order 7" \
    && cd build \
    && cmake ..  -DKENLM_MAX_ORDER=7 -DCMAKE_INSTALL_PREFIX:PATH=/opt/venv -DBUILD_TESTING=0 \
    && make -j 4 \
    && make build_binary
#    && mkdir -p ${KENLM_TOOLS} \
#    && cp ./bin/* ${KENLM_TOOLS} \
#    && cd /opt \
#    && rm -rf kenlm \
#    && apt autoremove -y -q

RUN export PATH="${PATH}:/opt/kenlm/build/bin"


################################################################################
# Bifixer and Bicleaner and tmxt
################################################################################
RUN git clone https://github.com/bitextor/bifixer.git
RUN git clone http://github.com/sortiz/tmxt
RUN /opt/venv/bin/python -m pip install -r ./bifixer/requirements.txt
RUN /opt/venv/bin/python -m pip install bicleaner
RUN git clone https://github.com/bitextor/bicleaner

RUN /opt/venv/bin/python -m pip install https://github.com/kpu/kenlm/archive/master.zip
RUN /opt/venv/bin/python -m pip install -r tmxt/requirements.txt
#ENV PATH="/opt/bin:/opt/moses_tools:${PATH}"