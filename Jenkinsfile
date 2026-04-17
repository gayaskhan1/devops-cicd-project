pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "yourdockerhubusername/app"
        SONARQUBE_SERVER = "SonarQube"
    }

    stages {

  stage('Checkout Code') {
    steps {
        git branch: 'main',
            url: 'https://github.com/gayaskhan1/devops-cicd-project.git'
      }
  }

        stage('Build Application') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'mvn sonar:sonar'
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Trivy Security Scan') {
            steps {
                sh 'trivy image $DOCKER_IMAGE'
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                    echo $PASS | docker login -u $USER --password-stdin
                    docker push $DOCKER_IMAGE
                    '''
                }
            }
        }
    }
}
