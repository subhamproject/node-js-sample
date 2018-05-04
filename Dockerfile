FROM 920995523917.dkr.ecr.us-east-1.amazonaws.com/container-image:nodekins
COPY . /var/lib/jenkins
WORKDIR /var/lib/jenkins
RUN npm start
EXPOSE 5000
CMD [ "npm","start" ]
