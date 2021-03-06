FROM debian:stretch

MAINTAINER Carlos de Paula <carlosedp@gmail.com>

ENV JAVA_VERSION_MAJOR=8 \
    JAVA_VERSION_MINOR=181 \
    JAVA_VERSION_BUILD=13 \
    JAVA_DL_PATH=96a7b8442fe848ef90c96a2fad6ed6d1 \
    JAVA_VERSION_ARCH=arm32-vfp-hflt \
    JAVA_PACKAGE=jdk \
    JAVA_HOME=/opt/java \
    JVM_OPTS="" \
    PATH=${PATH}:/opt/java/bin \
    LANG=C.UTF-8

RUN apt-get update -q && \
    apt-get install -q -y --no-install-recommends ca-certificates curl unzip 
RUN curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie" -o /tmp/java.tar.gz \
    http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_DL_PATH}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-${JAVA_VERSION_ARCH}.tar.gz
RUN gunzip /tmp/java.tar.gz && \
    tar -C /opt -xf /tmp/java.tar && \
    ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} ${JAVA_HOME} && \
    find ${JAVA_HOME} -maxdepth 1 -mindepth 1 | grep -v jre | xargs rm -rf && \
    cd ${JAVA_HOME} && ln -s ./jre/bin ./bin && \
    curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie" -o /tmp/unlimited_jce_policy.zip "http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip" && \
    unzip -jo -d ${JAVA_HOME}/jre/lib/security /tmp/unlimited_jce_policy.zip && \
    rm -rf ${JAVA_HOME}/*src.zip \
           ${JAVA_HOME}/lib/missioncontrol \
           ${JAVA_HOME}/lib/visualvm \
           ${JAVA_HOME}/lib/*javafx* \
           ${JAVA_HOME}/jre/plugin \
           ${JAVA_HOME}/jre/bin/javaws \
           ${JAVA_HOME}/jre/bin/jjs \
           ${JAVA_HOME}/jre/bin/keytool \
           ${JAVA_HOME}/jre/bin/orbd \
           ${JAVA_HOME}/jre/bin/pack200 \
           ${JAVA_HOME}/jre/bin/policytool \
           ${JAVA_HOME}/jre/bin/rmid \
           ${JAVA_HOME}/jre/bin/rmiregistry \
           ${JAVA_HOME}/jre/bin/servertool \
           ${JAVA_HOME}/jre/bin/tnameserv \
           ${JAVA_HOME}/jre/bin/unpack200 \
           ${JAVA_HOME}/jre/lib/javaws.jar \
           ${JAVA_HOME}/jre/lib/deploy* \
           ${JAVA_HOME}/jre/lib/desktop \
           ${JAVA_HOME}/jre/lib/*javafx* \
           ${JAVA_HOME}/jre/lib/*jfx* \
           ${JAVA_HOME}/jre/lib/arm64/libdecora_sse.so \
           ${JAVA_HOME}/jre/lib/arm64/libprism_*.so \
           ${JAVA_HOME}/jre/lib/arm64/libfxplugins.so \
           ${JAVA_HOME}/jre/lib/arm64/libglass.so \
           ${JAVA_HOME}/jre/lib/arm64/libgstreamer-lite.so \
           ${JAVA_HOME}/jre/lib/arm64/libjavafx*.so \
           ${JAVA_HOME}/jre/lib/arm64/libjfx*.so \
           ${JAVA_HOME}/jre/lib/ext/jfxrt.jar \
           ${JAVA_HOME}/jre/lib/ext/nashorn.jar \
           ${JAVA_HOME}/jre/lib/oblique-fonts \
           ${JAVA_HOME}/jre/lib/plugin.jar \
           /tmp/* /var/cache/apk/* && \
    apt-get remove --purge -y ca-certificates curl unzip && \
    apt-get autoremove --purge -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
