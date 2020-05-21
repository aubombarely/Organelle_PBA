##################################################
# Software:  Organelle_PBA
# Version:   v1.0.8
# Build cmd: docker build -t aubombarely/organelle_pba .
# Run cmd:   docker run -v $PWD:/data Organelle_PBA -h
##################################################

FROM conda/miniconda3

WORKDIR /installation/

RUN apt-get -qq update && apt-get -qq -y install wget git bzip2 python-minimal build-essential
RUN conda config --add channels defaults && \
    conda config --add channels bioconda && \
    conda config --add channels conda-forge
RUN conda install -y -q perl-bioperl perl-bioperl-run perl-perl4-corelibs blast blasr seqtk samtools bedtools

COPY vendor/sprai-0.9.9.23.tar.gz vendor/wgs-8.3rc2-Linux_amd64.tar.gz /installation/

# RUN wget -q https://sourceforge.net/projects/wgs-assembler/files/wgs-assembler/wgs-8.3/wgs-8.3rc2-Linux_amd64.tar.bz2 && \
#     tar jxf wgs-8.3rc2-Linux_amd64.tar.bz2
RUN tar zxf wgs-8.3rc2-Linux_amd64.tar.gz
ENV CA_PATH /installation/wgs-8.3rc2/Linux-amd64/bin

RUN tar zxf sprai-0.9.9.23.tar.gz && \
    cd sprai-0.9.9.23 && \
    python2 ./waf configure --prefix=/usr/local && \
    python2 ./waf build && \
    python2 ./waf install

COPY vendor/SSPACE-LongRead.pl OrganelleRef_PBA /usr/local/bin/

# link bash to /bin/sh
RUN echo 'no' | dpkg-reconfigure dash

WORKDIR /data/

CMD OrganelleRef_PBA -h
