# nodejsapp
It is Nodejs based web api which give information about "myapplication" as a GET response to the user request.

    $ http://35.227.57.3:8081/info 
      --Response-->
      {
        "myapplication": [
            {
              "version": "v161",
              "description": "pre-interview technical test",
              "lastcommitsha": "7daaa910956a1d7748c57669c8b9bf262cba2b8c"
                        }
                          ]
                            }

An HealthCheck is implemented to track the status of the application when it get deployed in our environment.

    $ http://35.227.57.3:8081/healthcheck
      --Response-->
     Healthy
     
# Testing

A test suite is written which consists a test case to check the response code of info api . If the response code is 200 then test suite will pass else it will fail.

# CICD 

Tools used - 

GIT : GitHub is used as SCM repository. A webhook is configured so that when a devloper commits changes it should trigger Jenkins pipeline to build and deploy application. 

DOCKER : Docker is used to containerize the application . An health check is implemented in Dockerfile which keeps a track on the  status of application. Even if container is up and running there is a possibilty that application is down. In those cases this docker based HealthCheck will mark the status of container as unhealthy.

JENKINS : A jenkinsfile is used to store the pipeline configuration as code in our GitHub. It is used to orchestrate the deployment of nodejs application using stages  :

  Checkout : This stage checksout code from GitHub
  Test     : Trigger test cases.
  Build    : Builds the docker image and set latest commit number in lastcommitsha, set application version followed by buildnumber
  Push     : Push our image to dockerhub. It uses Jenkins credentials plugin to hide the docker login credentials in jenkins pipeline
  Deploy   : Deploy the Docker image locally and publish our container on 8081 host port.
  Cleanup  : Clean unnecessary files
  

CLOUD :A GCP compute engine instance is used for this POC.
 
