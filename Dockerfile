FROM buildpack-deps:wheezy

ADD h8300.c.patch /root/
ADD minirc.dfl /etc/minicom/

RUN buildDeps='minicom' \
	&& set -x \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends \
  && cd /usr/src \
  && curl -SL "http://ftp.gnu.org/gnu/binutils/binutils-2.19.1.tar.bz2" -o binutils.tar.bz2 \
  && curl -SL "http://ftp.gnu.org/gnu/gcc/gcc-3.4.6/gcc-3.4.6.tar.bz2" -o gcc.tar.bz2 \
  && mkdir -p /usr/src/binutils \
  && tar -xvf binutils.tar.bz2 -C /usr/src/binutils --strip-components=1 \
  && rm binutils.tar.bz2* \
  && cd /usr/src/binutils \
  && ./configure --target=h8300-elf --disable-nls --disable-werror \
  && make \
  && make install \
  && cd /usr/src \
  && mkdir -p /usr/src/gcc \
  && tar -xvf gcc.tar.bz2 -C /usr/src/gcc --strip-components=1 \
  && rm gcc.tar.bz2* \
  && cd /usr/src/gcc \
  && patch -u ./gcc/config/h8300/h8300.c < /root/h8300.c.patch \
  && ./configure --target=h8300-elf --disable-nls --disable-threads \
  --disable-shared --enable-languages=c \
  && make \
  && make install
