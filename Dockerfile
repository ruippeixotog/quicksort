FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

# update and upgrade packages already installed
RUN apt-get -y update
RUN apt-get -y upgrade

# install requirements for installing compilers and dependencies
RUN apt-get -y install build-essential wget curl unzip software-properties-common \
  cabal-install libghc-zlib-dev libghc-zlib-bindings-dev libghc-terminfo-dev \
  libpython-dev clang-3.6

RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.6 100 && \
  update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.6 100

# add external Debian repositories and update packages
RUN apt-add-repository -y ppa:swi-prolog/stable && \
  apt-get -y update

# install compiler and interpreter packages
RUN apt-get -y install \
  openjdk-7-jdk ruby nodejs ghc smlnj php5-cli racket swi-prolog \
  mono-complete fsharp gcc-multilib nasm clisp erlang golang lua5.2 mono-vbnc \
  gfortran fp-compiler

# install Scala
ENV SCALA_VERSION 2.11.7

RUN wget http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.deb && \
  dpkg -i scala-$SCALA_VERSION.deb && \
  rm scala-$SCALA_VERSION.deb

# install Groovy
RUN curl -s http://get.sdkman.io | bash && \
  bash -c "source /root/.sdkman/bin/sdkman-init.sh && yes | sdk install groovy"

# install Rust
RUN wget https://static.rust-lang.org/rustup.sh && \
  bash rustup.sh -y --channel=stable && \
  rm rustup.sh

# install Idris
RUN cabal update && \
 cabal install cabal && \
 cabal install idris

ENV PATH /root/.cabal/bin:$PATH

# install Clojure
ENV CLOJURE_VERSION 1.7.0

RUN wget -P /opt http://central.maven.org/maven2/org/clojure/clojure/$CLOJURE_VERSION/clojure-$CLOJURE_VERSION.jar && \
  echo "java -jar /opt/clojure-$CLOJURE_VERSION.jar \$@" > /usr/local/bin/clojure && \
  chmod +x /usr/local/bin/clojure

# build Joy
RUN mkdir /var/lib/joy && cd /var/lib/joy && \
  wget http://webstat.latrobe.edu.au/url/www.kevinalbrecht.com/code/joy-mirror/joy.tar.gz && \
  tar zxvf joy.tar.gz && make && \
  ln -s /var/lib/joy/joy /usr/local/bin

# install Kotlin
ENV KOTLIN_VERSION 1.0.0-beta-2423

RUN wget https://github.com/JetBrains/kotlin/releases/download/build-$KOTLIN_VERSION/kotlin-compiler-$KOTLIN_VERSION.zip && \
  unzip -d /opt kotlin-compiler-$KOTLIN_VERSION.zip && \
  ln -s /opt/kotlinc/bin/kotlinc /usr/local/bin && \
  ln -s /opt/kotlinc/bin/kotlin /usr/local/bin && \
  rm kotlin-compiler-$KOTLIN_VERSION.zip

# install IO
RUN wget http://iobin.suspended-chord.info/linux/iobin-linux-x64-deb-current.zip && \
  unzip -d /io iobin-linux-x64-deb-current.zip && \
  dpkg -i /io/*.deb && \
  rm -r /io iobin-linux-x64-deb-current.zip

# install Swift
ENV SWIFT_VERSION 2.2-SNAPSHOT-2015-12-01-b

RUN mkdir -p /opt/swift && \
  wget https://swift.org/builds/ubuntu1404/swift-$SWIFT_VERSION/swift-$SWIFT_VERSION-ubuntu14.04.tar.gz && \
  tar zxvf swift-$SWIFT_VERSION-ubuntu14.04.tar.gz -C /opt/swift --strip-components=1 && \
  rm swift-$SWIFT_VERSION-ubuntu14.04.tar.gz

ENV PATH /opt/swift/usr/bin:$PATH

# install Nim
ENV NIM_VERSION 0.14.2

RUN mkdir /opt/nim && cd /opt/nim && \
  wget http://nim-lang.org/download/nim-$NIM_VERSION.tar.xz && \
  tar xf nim-$NIM_VERSION.tar.xz && rm nim-$NIM_VERSION.tar.xz && \
  cd nim-$NIM_VERSION && ./build.sh && cd .. \
  ln -s /opt/nim/nim-$NIM_VERSION/bin/nim /usr/local/bin

# configure Node package
RUN update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10

# config verbosity of Pascal compiler
RUN sed -i 's/^-l$//' /etc/fpc.cfg

# cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
