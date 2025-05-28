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
                sh 'echo "Simulating Maven build"'
                // Si vrai code Java/Maven : sh 'mvn clean package'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'echo "Simulating SonarQube analysis"'
                    // Si vrai code Java/Maven : sh 'mvn sonar:sonar'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t melek99/fleetman-position-simulator:release2 .'
            }
        }
        stage('Push Docker Image') {
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
