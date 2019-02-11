node {	
currentBuild.result = "SUCCESS"
    try {
	//Git Checkout step  
       stage('Checkout'){
          git credentialsId: '65633920-5eb0-45aa-a2a9-c8333b674be5', url: 'https://github.com/akkipuneet/nodejsapp.git'
       }
	// Trigger Unit TestCases     
       stage('Test'){
         env.NODE_ENV = "test"
         print "Environment will be : ${env.NODE_ENV}"
         sh 'node -v'
         sh 'npm prune'			//npm-prune Remove extraneous packages
         sh 'npm install'		//install node dependencies from package.json
         sh 'npm test'			//trigger unit test cases
       }
	//build docker image and set latest commit number in lastcommitsha ,  set application version parameter from jenkins followed by buildnumber
       stage('Build Docker'){
	       sh 'lastcommitsha=$(git rev-parse --verify HEAD) && docker build --build-arg version=${version}_${BUILD_NUMBER} --build-arg lastcommitsha=$lastcommitsha -t puneetsingla/nodejsapp:${version}_${BUILD_NUMBER} .'
       }
       //push the image into dockerhub
      stage('Push Image'){
         echo 'Push to Repo'
	//use credentials plugin to hide the docker login credentials in jenkins pipeline
        withCredentials([usernamePassword(credentialsId: 'd25d8874-6f76-416e-8102-f0934448bb0a', passwordVariable: 'docker_password', usernameVariable: 'docker_username')])
		 {
		 sh 'docker login -u $docker_username  -p $docker_password'
		 }
	      sh 'docker push puneetsingla/nodejsapp:${version}_${BUILD_NUMBER}'    
      }
	//Deploy the Docker image locally and publish on 8081 host port.
       stage('Deploy'){
         echo 'ssh to web server and tell it to pull new image'
	  sh 'docker rm -f $(docker ps -aq)'
	       sh 'docker run --name=nodejs -d -p 8081:8080 puneetsingla/nodejsapp:${version}_${BUILD_NUMBER}'
       }
	//clean unnecessary files
       stage('Cleanup'){
         echo 'prune and cleanup'
         sh 'npm prune'
         sh 'rm node_modules -rf'

	//email notification for build success
	//Configure SMTP server to use below code	    
  /*           mail body: 'project build successful',
                     from: 'xxxx@infosys.com',
                     replyTo: 'xxxx@infosys.com',
                     subject: 'project build successful',
                     to: 'yyyyy@infosys.com'  */
       }
    }	
    catch (err) {
	//Set the build result to failure is some exception occur.
        currentBuild.result = "FAILURE"
	//email notification for build failure  
	    //Configure SMTP server to use below code
  /*          mail body: "project build error is here: ${env.BUILD_URL}" ,
            from: 'xxxx@infosys.com',
            replyTo: 'yyyy@infosys.com',
            subject: 'project build failed',
            to: 'zzzz@infosys.com'   */
        throw err
    }
}
