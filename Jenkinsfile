pipeline {
	agent any
	
	options {
		parallelsAlwaysFailFast()
	}

	environment {
		REGISTRY_URL="docker.pkg.github.com/dmallubhotla/docker-youtube-dl/"
		IMAGE_BASE="youtube-dl"
		GITHUB_PACKAGES=credentials("github-packages-ytdl")
	}

	stages {
		stage('Build') {
			steps {
				echo 'Building...'
				sh 'python --version'
				sh 'scripts/build.sh'
			}
		}
		stage('Deploy') {
			when {
				buildingTag()
			}
			steps {
				echo 'Deploying...'
				sh 'scripts/deploy.sh'
			}
		}
	}
	post {
		always {
			echo 'This will always run'
			junit 'pytest.xml'
			cobertura coberturaReportFile: 'coverage.xml'
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
