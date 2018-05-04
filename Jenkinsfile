// This pipeline for Nodejs project build
pipeline
{
    options
    {
        buildDiscarder(logRotator(numToKeepStr: '15'))
    }
	agent any
    // Define Environemnt Variable 
    environment 
    {
	VERSION = 'node'
        PROJECT = 'rcx-test-vf'
        IMAGE = 'rcx-test-vf:node'
        ECRURL = 'https://920995523917.dkr.ecr.us-east-1.amazonaws.com/rcx-test-vf'
        CRED = 'ecr:ap-southeast-1:demo_aws_cred'
    }
    stages
     {	  
	stage('Fetch Nodejs Dependency') {
	 agent {
	 docker 
	 {
	 image 'node:6-alpine'
         args '-u root -v $HOME/node_modules:/var/lib/jenkins/node_modules'
	 }
	 }
	 steps {
	       sh '''
		#!/bin/bash
	        export PATH=/usr/local/bin:$PATH
		ls -l
		npm install
		ls -l
		'''
                dir("${env.WORKSPACE}") {
                    stash name: 'node_modules', includes: 'node_modules/'
	            stash name: 'appdata', includes: '*.*'
                }
            }
         }
	// Build Docker image
     stage('Build Docker Image')
        {
            steps
            {
                script
                {
	         dir("${env.WORKSPACE}") {
		    sh 'ls -l'
                    unstash 'node_modules'
		    unstash 'appdata'
		    sh 'ls -l'
                    }
                    // Build the docker image using a Dockerfile
			docker.build('${IMAGE}')
                }
            }
        }
	     //  Login to ECR before pushing image
	     
	stage('ECR login')
	     {
		steps
		    {
	sh '''  
	#!/bin/bash
	 export PATH="$PATH:/home/jenkins/.local/bin"
	 aws ecr get-login --no-include-email --region us-east-1 |bash
	   '''
			  
		    }
	     }
		// Push Docker images to AWS ECR Or Docker HUB as applicable
        stage('Push Image to ECR')
        {
            steps
            {
                script
                {
                  docker.withRegistry(ECRURL,CRED)
                //  docker.withRegistry('https://920995523917.dkr.ecr.us-east-1.amazonaws.com', 'ecr:us-east-1:demo_aws_cred')
				  
                    {
			    docker.image(IMAGE).push()
                    }
                }
            }
        }
     }

    post
    {
        always
        {
            // make sure that the Docker image is removed
            // Delete old unused images to houskeep diskspace
            sh '''
	    docker rmi ${IMAGE} | true
	    RUN=$(docker ps -aq) >> /dev/null
	    if [ -n "$RUN" ]
	    then
	    docker stop $RUN
	    docker rm -f $RUN
	    fi
	    IMG=$(docker images -q -f dangling=true) >> /dev/null
	    if [ -n "$IMG" ]
	    then
	    docker rmi  $IMG >> /dev/null
	    fi
	    '''
        }
   	success {
	// clear work space
	deleteDir()
      // notify users when the Pipeline fails
      mail to: 'smandal@rythmos.com',
          subject: "Sucess: ${currentBuild.fullDisplayName}",
          body: "successfully build ${env.BUILD_URL}"
    }
	failure {
      // notify users when the Pipeline fails
      mail to: 'smandal@rythmos.com',
          subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
          body: "Something is wrong with ${env.BUILD_URL} Please Check the logs"
    }
	unstable {
      // notify users when the Pipeline fails
      mail to: 'smandal@rythmos.com',
          subject: "Unstable Pipeline: ${currentBuild.fullDisplayName}",
          body: "Build is not stable,Please check the logs ${env.BUILD_URL}"
    }
    }
}
