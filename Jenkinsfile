pipeline {
    agent none
    stages {
        stage('Checkout') {
            agent any
            steps {
                git url: 'https://github.com/malikblhedi/fleetman-position-simulator.git', branch: 'main'
            }
        }
        stage('Build') {
            agent {
                docker {
                    image 'maven:3.9.6-openjdk-8'
                    args '-v /root/.m2:/root/.m2'
                }
            }
            steps {
                sh 'mvn clean package'
            }
        }
        stage('SonarQube Analysis') {
            agent {
                docker {
                    image 'maven:3.9.6-openjdk-8'
                    args '-v /root/.m2:/root/.m2'
                }
            }
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'mvn sonar:sonar -Dsonar.host.url=http://192.168.252.131:9000'
                }
            }
        }
        stage('Build Docker Image') {
            agent {
                docker {
                    image 'docker:27.3-dind'
                    args '--privileged'
                }
            }
            steps {
                sh 'docker build -t melek99/fleetman-position-simulator:release2 .'
            }
        }
        stage('Push Docker Image') {
            agent {
                docker {
                    image 'docker:27.3-dind'
                    args '--privileged'
                }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push melek99/fleetman-position-simulator:release2'
                }
            }
        }
        stage('Deploy to Kubernetes') {
            agent any
            steps {
                sh 'kubectl apply -f manifests/deployment.yaml'
                sh 'kubectl apply -f manifests/service.yaml'
            }
        }
    }
}
