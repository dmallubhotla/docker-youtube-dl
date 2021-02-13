pipeline {
	agent any
	
	options {
		parallelsAlwaysFailFast()
	}

	environment {
		REGISTRY_URL="ghcr.io/dmallubhotla/"
		IMAGE_BASE="youtube-dl"
	}

	stages {
		stage('Pre-Build') {
			steps {
				echo 'Setting permission for build script'
				sh "chmod +x scripts/build.sh"
			}
		}
		stage('Build') {
			steps {
				echo 'Building...'
				script {
					docker.withRegistry("REGISTRY_URL") {
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
