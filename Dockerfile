FROM gassettj/papilio_environment
#FROM drtrigon/papilio_environment
MAINTAINER DrTrigon <dr.trigon@surfeu.ch>

# LABEL author.user1="DrTrigon <dr.trigon@surfeu.ch>"

# Initial update
RUN apt-get -y update

# Install License Configuration Manager dependencies
RUN apt-get install -y \
  libqt4-network

# Create (symbolic) link 
RUN ln -s /usr/lib/x86_64-linux-gnu/libQtNetwork.so.4.8.7 /usr/lib/x86_64-linux-gnu/libQt_Network.so
