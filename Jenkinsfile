pipeline {
    agent any
    tools {
        jdk 'jdk17'    // Ensure this matches the JDK version installed in Jenkins
        maven 'maven3' // Ensure this matches the Maven version installed in Jenkins
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'  // Ensure 'sonar-scanner' matches the SonarScanner tool name in Jenkins
        DOCKER_IMAGE = 'ahsan98/santagift:2.5'  // Define your Docker image repository and tag
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
                withSonarQubeEnv('sonar') {
                    sh 'mvn sonar:sonar'
                }
            }
        }


        stage('OWASP Dependency Check') {
            steps {
                dependencyCheck additionalArguments: '', odcInstallation: 'DC'
            }
        }


        stage('Code Build') {
            steps {
                sh "mvn clean install"
            }
        }

        // stage('Cleanup Existing Container and Image') {
        //     steps {
        //         script {
        //             // Remove the existing container if present
        //             sh "docker stop myapp || true"
        //             sh "docker rm myapp || true"
                    
        //             // Remove the existing image if present
        //             sh "docker rmi santa123 || true"
        //         }
        //     }
        // }

        stage('Docker Build & Scan') {
            steps {
                script {
                    sh "docker build -t santa123 ."
                    sh "trivy image santa123"
                    // sh "trivy --scanners vuln image santa123"
                }
            }
        }


        stage('Docker Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred') {
                        sh "docker tag santa123 $DOCKER_IMAGE"
                        sh "docker push $DOCKER_IMAGE"
                    }
                }
            }
        }


        stage('Docker Deploy') {
            steps {
                script {
                    sh "docker run -d --name myapp -p 8085:8080 $DOCKER_IMAGE"
                }
            }
        }


        stage('Deploy to Nexus') {
            steps {
                script {
                    withMaven(globalMavenSettingsConfig: 'global-maven', traceability: true)  {
                        sh "mvn deploy"
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


    //     post {
    //     always {
    //         script {
    //             // Cleanup: Stop and remove the container if it's running
    //             sh "docker stop myapp || true"
    //             sh "docker rm myapp || true"
    //         }
    //     }
    // }
}
