pipeline {
    agent any
    tools{
        jdk 'jdk17'
        maven 'maven3'
    }
    environment{
        SCANNER_HOME= tool 'sonar-scanner'
    }

    stages {
        stage('git-checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ahsan598/jenkins-project1.git'
            }
        }


        stage('Code-Compile') {
            steps {
               sh "mvn compile"
            }
        }

        
        stage('Sonar Analysis') {
            steps {
                sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.url=http://192.168.52.10:9000/ \
                -Dsonar.login=squ_2cc3cb03b7cb5fffe6186a13a1fc91952f43776a \
                -Dsonar.projectName=santa \
                -Dsonar.java.binaries=. \
                -Dsonar.projectKey=santa'''
            }
        }
        

		stage('OWASP Dependency Check') {
            steps {
                dependencyCheck additionalArguments: ' --scan ./ ', odcInstallation: 'DC'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

		 
        stage('Code-Build') {
            steps {
               sh "mvn clean install"
            }
        }


        stage('Docker Build & Push') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker-cred') {
                    sh "docker build -t  santa123 . "
                    sh "docker tag santa123 ahsan98/santa123:latest"
                    sh "docker push ahsan98/santa123:latest"
                    }
                }
            }
        }

        stage('Docker Image Scan') {
            steps {
               sh "trivy image ahsan98/santa123:latest "
            }
        }


        stage('Docker Deploy') {
            steps {
               script{
                   withDockerRegistry(credentialsId: 'docker-cred') {
                    sh "docker run -d --name myapp -p 8081:8081 ahsan98/santa123:latest"
                    }
               }
            }
        }  	 
    }
}