FROM ubuntu:latest

# install needed packages
RUN apt-get update
RUN apt-get install -y  curl telnet build-essential python libkrb5-dev vim unzip
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs
RUN apt-get autoremove
RUN apt-get clean

# install nodemon, forever and n for nodejs
RUN npm install -g nodemon forever n
# install node 6.11.1
RUN n 6.11.1
