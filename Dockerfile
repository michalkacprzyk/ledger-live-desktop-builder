# mk (c) 2018
# Build ledger-life-desktop software from sources
#   as they lack proper verification of linux binaries
# https://github.com/LedgerHQ/ledger-live-desktop/tree/master
FROM ubuntu:bionic AS build

# Easy part - straight from ubuntu repo
RUN apt-get update && apt-get install -y \
  build-essential \
  curl \
  git \
  libudev-dev \
  libusb-1.0-0-dev \
  python \
  python2.7 \
  software-properties-common \
  && rm -rf /var/lib/apt/lists/*

# NodeJS LTS https://github.com/nodesource/distributions/blob/master/README.md
RUN add-apt-repository -y -r ppa:chris-lea/node.js \
  &&  rm -f /etc/apt/sources.list.d/chris-lea-node_js-*.list \
  &&  rm -f /etc/apt/sources.list.d/chris-lea-node_js-*.list.save \
  &&  curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
  &&  VERSION=node_8.x \
  &&  DISTRO="$(lsb_release -s -c)" \
  &&  echo "deb https://deb.nodesource.com/$VERSION $DISTRO main" \
      | tee /etc/apt/sources.list.d/nodesource.list \
  &&  echo "deb-src https://deb.nodesource.com/$VERSION $DISTRO main" \
      | tee -a /etc/apt/sources.list.d/nodesource.list \
  &&  apt-get update && apt-get install -y nodejs \
  &&  nodejs --version

# Yarn stable: https://yarnpkg.com/en/docs/install#debian-stable
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" \
     | tee /etc/apt/sources.list.d/yarn.list \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" \
     | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update &&  apt-get install -y yarn \
  && yarn --version

# Build
RUN git clone https://github.com/LedgerHQ/ledger-live-desktop.git \
  && cd ledger-live-desktop \
  && sed -i "s/<\=8\.14\.0/<=8.15.0/" package.json \
  && yarn \
  && yarn dist


FROM alpine
COPY --from=build /ledger-live-desktop/dist/*.AppImage /
VOLUME /host

# This assumes /host is binded to a host directory, for example
# docker run -it --rm -v $(pwd):/host mkusanagi:ledger-live-desktop
CMD [ "sh", "-c", "cp /*.AppImage /host/" ]
