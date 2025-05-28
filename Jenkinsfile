pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/malikblhedi/fleetman-position-simulator.git', branch: 'main'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package'  // Remplace la simulation par un vrai build Maven
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'echo "Simulating SonarQube analysis"'
                }
            }
        }
        stage('Build Docker Image') {
            agent {
                docker {
                    image 'docker:latest'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                sh 'docker build -t melek99/fleetman-position-simulator:release2 .'
            }
        }
        stage('Push Docker Image') {
            agent {
                docker {
                    image 'docker:latest'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
                    sh 'docker push melek99/fleetman-position-simulator:release2'
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f manifests/deployment.yaml'
                sh 'kubectl apply -f manifests/service.yaml'
            }
        }
    }
}
