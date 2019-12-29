# deadline image create by build.sh
FROM deadline10-client:latest


# Requires the installers directory to be populated
RUN mkdir /tmp/maya
COPY installers/Autodesk_Maya_2019_Linux_64bit.tgz /tmp/maya
RUN tar -xvf /tmp/maya/Autodesk_Maya_2019_Linux_64bit.tgz -C /tmp/maya && \
    rpm -Uvh /tmp/maya/Maya*.rpm && \
    rm -r /tmp/maya

WORKDIR /opt/Thinkbox/Deadline10/bin/
