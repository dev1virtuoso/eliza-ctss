# Build an image with:
#  docker build -t eliza .

# Launch a container from that image with:
#  docker run -i -t -p 7094:7094 eliza


FROM ubuntu:22.04
LABEL Version="1.0" \
      Date="2025-Jun-04" \
      Docker_Version="Docker version 25.0.3, build 4debf41" \
      Vendor="marquisdeGeek.com" \
      Maintainer="Steven Goodwin - Marquis de Geek (@marquisdeGeek)" \
      Description="A basic Docker container to use Eliza"

# Preparing the OS
ENV DEBIAN_FRONTEND noninteractive


# For the OS
ARG   USER_CTSS_NAME=ctss
ARG   USER_CTSS_PASSWORD=${USER_CTSS_NAME}
ARG   USER_CTSS_HOMEDIR=/home/${USER_CTSS_NAME}
ARG   USER_CTSS_PATH=${USER_CTSS_HOMEDIR}/eliza-ctss


# Base OS and tools
RUN apt-get update && \
    apt-get install -y sudo vim && \
    apt-get install -y make gcc python3 && \
    apt-get remove --purge --auto-remove -y


# Create non-root users
RUN useradd -ms /bin/bash $USER_CTSS_NAME && echo "$USER_CTSS_NAME:$USER_CTSS_PASSWORD" | chpasswd && adduser $USER_CTSS_NAME sudo


# Bring the necessary parts of the repo into the CTSS user
USER $USER_CTSS_NAME
COPY --chown=${USER_CTSS_NAME} ctss   $USER_CTSS_PATH/ctss
COPY --chown=${USER_CTSS_NAME} eliza  $USER_CTSS_PATH/eliza
COPY --chown=${USER_CTSS_NAME} output $USER_CTSS_PATH/output
COPY --chown=${USER_CTSS_NAME} env.sh $USER_CTSS_PATH


# The env
SHELL ["/bin/bash", "-c"]
WORKDIR $USER_CTSS_PATH
RUN echo "source $USER_CTSS_PATH/env.sh" >> $USER_CTSS_HOMEDIR/.bashrc


RUN <<EOF
    source env.sh
    make-binaries
    make-disks

    printf "\n\nquit\n" | format-disks
    printf "\n\n\n\nq\n" | install-disk-loader

    # CTSS and Eliza
    installctss
    add-eliza-users
    upload-all

EOF


# Prepare ctssrun, and run when the container is started
ENV USER_CTSS_PREPARE_ENV="source ${USER_CTSS_PATH}/env.sh"
CMD $USER_CTSS_PREPARE_ENV ; runctss

