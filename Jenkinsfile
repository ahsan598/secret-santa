pipeline {
    agent any
    tools {
        jdk 'jdk17'    // Ensure this matches the JDK version installed in Jenkins
        maven 'maven3' // Ensure this matches the Maven version installed in Jenkins
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'  // Ensure 'sonar-scanner' matches the SonarScanner tool name in Jenkins
        DOCKER_IMAGE = 'ahsan598/santagift:latest'  // Define your Docker image repository and tag
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ahsan598/jenkins-project1.git'
            }
        }

        stage('Code Compile') {
            steps {
                sh "mvn clean compile"
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-scanner') {
                    sh 'mvn sonar:sonar'
                }
            }
        }

        stage('Code Build') {
            steps {
                sh "mvn clean install"
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred') {
                        sh "docker build -t santa123 ."
                        sh "docker tag santa123 $DOCKER_IMAGE"
                        sh "docker push $DOCKER_IMAGE"
                    }
                }
            }
        }

        stage('Docker Image Scan') {
            steps {
                sh "trivy image $DOCKER_IMAGE"
            }
        }

        stage('Docker Deploy') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred') {
                        sh "docker run -d --name myapp -p 8081:8081 $DOCKER_IMAGE"
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()  // Clean up workspace after build
        }
    }
}
