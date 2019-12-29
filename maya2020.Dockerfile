#FROM mottosso/mayabase-centos:latest
FROM deadline10-client:latest


#Linux Version not available for download. Copy from installers
#mechanism will ensure that this only happens once.
RUN mkdir /tmp/maya
COPY installers/Autodesk_Maya_2020_ML_Linux_64bit.tgz /tmp/maya
RUN tar -xvf /tmp/maya/Autodesk_Maya_2020_ML_Linux_64bit.tgz -C /tmp/maya && \
    rpm -Uvh /tmp/maya/Packages/Maya*.rpm && \
    rm -r /tmp/maya

# # Copy over the installer.
# RUN mkdir /tmp/thinkboxsetup/
# COPY installers/DeadlineClient-10.*-linux-x64-installer.run /tmp/thinkboxsetup/

# # Run the installer.
# RUN /tmp/thinkboxsetup/DeadlineClient-10.*-linux-x64-installer.run \
#     --mode unattended \
#     --unattendedmodeui minimal \ 
#     --repositorydir /mnt/DeadlineRepository10 \ 
#     --noguimode true \ 
#     --restartstalled true  && \
#     rm -rf /tmp/thinkboxsetup

WORKDIR /opt/Thinkbox/Deadline10/bin/
