pipeline {
	agent {
	  kubernetes {
		label 'docker-ytdl'  // all your pods will be named with this prefix, followed by a unique id
		idleMinutes 5  // how long the pod will live after no jobs have run on it
		yamlFile 'jenkins/ci-agent-pod.yaml'  // path to the pod definition relative to the root of our project 
		defaultContainer 'docker'  // define a default container if more than a few stages use it, will default to jnlp container
	  }
	}
	
	options {
		parallelsAlwaysFailFast()
	}

	environment {
		REGISTRY_URL="ghcr.io/dmallubhotla/"
		IMAGE_BASE="youtube-dl"
	}

	stages {
		stage('Pre-build') {
			steps {
				echo 'Setting build script permissions'
				sh 'chmod +x scripts/build.sh'
			}
		}
		stage('Build') {
			steps {
				script {
					docker.withRegistry("https://ghcr.io", 'github-packages-ytdl') {
						def newApp = docker.build "${REGISTRY_URL}${IMAGE_BASE}:${env.BUILD_TAG}"
						if (env.BRANCH_NAME == "master") {
							newApp.push()
						}
						sh 'scripts/build.sh'
					}
				}
			}
		}
		stage('Deploy') {
			when {
				buildingTag()
			}
			steps {
				echo 'Deploying...'
				sh 'chmod +x scripts/deploy.sh'
				withCredentials([usernamePassword(credentialsId: 'github-packages-ytdl', passwordVariable: 'REGISTRY_PW', usernameVariable: 'REGISTRY_USER')]) {
					sh 'scripts/deploy.sh'
				}
			}
		}
	}
	post {
		always {
			echo 'This will always run'
			mail (bcc: '',
				body: "Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> Build URL: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: 'jenkins@jenkins.deepak.science', mimeType: 'text/html', replyTo: 'dmallubhotla+jenkins@gmail.com', subject: "${env.JOB_NAME} #${env.BUILD_NUMBER}: Build ${currentBuild.currentResult}", to: "dmallubhotla+ci@gmail.com")
		}
		success {
			echo 'This will run only if successful'
		}
		failure {
			echo 'This will run only if failed'
		}
		unstable {
			echo 'This will run only if the run was marked as unstable'
		}
		changed {
			echo 'This will run only if the state of the Pipeline has changed'
			echo 'For example, if the Pipeline was previously failing but is now successful'
		}
	}
}
