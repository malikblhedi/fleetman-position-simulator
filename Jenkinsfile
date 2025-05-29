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
                withMaven(mavenInstallation: 'default-maven') {
                    sh 'mvn clean package'
                }
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'mvn sonar:sonar -Dsonar.host.url=http://192.168.252.131:9000'
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
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
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
