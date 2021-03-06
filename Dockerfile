FROM node:14.15.4-buster

# install Chromium for (unit)-testing during build-phase
RUN apt-get update && \
    apt-get install -y --no-install-recommends 'chromium=87.0.4280.88-0.4~deb10u1' && \
    rm -rf /var/lib/apt/lists/*

# install Firefox for (unit)-testing during build-phase
RUN apt-get update && \
    apt-get install -y --no-install-recommends 'firefox-esr=78.6.1esr-1~deb10u1' && \
    rm -rf /var/lib/apt/lists/*

# install sonar-scanner 
ENV SONAR_VERSION="4.5.0.2216-linux"
COPY sonar-scanner-cli-$SONAR_VERSION.zip /var/opt/
RUN unzip /var/opt/sonar-scanner-cli-$SONAR_VERSION.zip -d /var/opt && \
    rm /var/opt/sonar-scanner-cli-$SONAR_VERSION.zip
ENV PATH="$PATH:/var/opt/sonar-scanner-$SONAR_VERSION/bin"

# copy build scripts into container
RUN mkdir /code
WORKDIR /code
COPY entrypoint.sh /entrypoint.sh
COPY front-end-build.sh /front-end-build.sh

# set execute on the scripts
RUN chmod +x /entrypoint.sh && \
    chmod +x /front-end-build.sh 

# start the build
CMD [ "bash", "/entrypoint.sh" ] 
