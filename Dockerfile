FROM python

#Required for tzdata
ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git unzip curl build-essential cmake ninja-build \
                       libx11-dev libxcursor-dev libxi-dev \
                       libgl1-mesa-dev libfontconfig1-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY compile.sh /

VOLUME /dependencies
VOLUME /output

WORKDIR /output

RUN ["chmod", "+x", "/compile.sh"]

ENTRYPOINT ["/compile.sh"]
