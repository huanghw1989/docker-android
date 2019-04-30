FROM openjdk:8u212-jdk-stretch

ENV ANDROID_HOME="/opt/android" \
    ANDROID_BUILD_TOOLS_VERSION="28.0.3"

ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

RUN apt update && \
    apt install -y zip

# sdkman
RUN curl -s "https://get.sdkman.io" | bash

# gradle
RUN /bin/bash -c "source /root/.sdkman/bin/sdkman-init.sh && \
    sdk install gradle 5.4.1"

# android sdk
RUN mkdir -p ${ANDROID_HOME} && cd ${ANDROID_HOME} && \
    wget -O tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && \
    unzip tools.zip && rm tools.zip && \
    # Avaliable packages: sdkmanager --list
    yes | sdkmanager "platform-tools" && \
    yes | sdkmanager "build-tools;"${ANDROID_BUILD_TOOLS_VERSION} && \
    yes n | (echo "28,27,26,25,24,23,22,21,19" | sed 's/,/\n/g' | awk '{print "platforms;android-"$1}' | xargs sdkmanager)

# Clean up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean
