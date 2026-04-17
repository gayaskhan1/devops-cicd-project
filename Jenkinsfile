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

        // 🔍 DEBUG STAGE (VERY IMPORTANT)
        stage('Debug Structure') {
            steps {
                sh 'pwd'
                sh 'ls -R'
            }
        }

        // 🔥 AUTO-DETECT POM LOCATION
        stage('Find POM Location') {
            steps {
                script {
                    POM_PATH = sh(
                        script: "find . -name pom.xml | head -n 1",
                        returnStdout: true
                    ).trim()

                    echo "POM FOUND AT: ${POM_PATH}"

                    // Extract directory path
                    APP_DIR = POM_PATH.replace('/pom.xml','')
                    echo "APP DIRECTORY: ${APP_DIR}"
                }
            }
        }

        stage('Build Application') {
            steps {
                script {
                    dir("${APP_DIR}") {
                        sh 'mvn clean package'
                    }
                }
            }
        }

        stage('Build Test') {
            steps {
                script {
                    dir("${APP_DIR}") {
                        sh 'mvn test'
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    dir("${APP_DIR}") {
                        withSonarQubeEnv('SonarQube') {
                            sh 'mvn sonar:sonar'
                        }
                    }
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
                script {
                    dir("${APP_DIR}") {
                        sh 'docker build -t $DOCKER_IMAGE .'
                    }
                }
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
