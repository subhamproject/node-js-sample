FROM 920995523917.dkr.ecr.us-east-1.amazonaws.com/container-image:node
COPY . /var/lib/jenkins
WORKDIR /var/lib/jenkins
EXPOSE 5000
CMD [ "npm","start" ]
