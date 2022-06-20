FROM ubuntu:latest

# Run apt update and upgrade.
RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive

# Add required repositories.
RUN apt-get -y install software-properties-common

# Install required packages.
RUN apt-get -y install \
    python3 python3-pip curl nano git