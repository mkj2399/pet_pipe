pipeline {
    agent any
    
    environment {
        // JDK installation path
        JAVA_HOME = '/var/jenkins_home/java/jdk-17'
        DOCKER_IMAGE_NAME = "petclinic-pipeline-file"
        DOCKER_IMAGE_TAG = "latest"
        M2_HOME = "/var/jenkins_home/maven/apache-maven-3.9.3"
        JAR_FILE_NAME = ''
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch:'main', url: 'https://github.com/spring-projects/spring-petclinic'
            }
        }
        stage('Build') {
            steps {
                sh 'java --version'
                // package maven and skip test
                sh '${M2_HOME}/bin/mvn clean package -DskipTests'
                script {
                    JAR_FILE_NAME = sh(returnStdout: true, script: 'ls target/*.jar').trim()
                }
            }
        }
        stage('Test') {
            steps {
                // Test
                sh '${M2_HOME}/bin/mvn package test'
            }
        }
        stage('Docker Image Build') {
            steps {
                // Build docker image
                script {
                    dir('tmp_git_repo') {
                        // clone repo on shallow mode
                        git branch: 'main', url: 'https://github.com/mkj2399/pet_pipe', shallow: true
                        // Grab a specific file
                        sh 'git config core.sparseCheckout true'
                        // grabbin dockerfile
                        sh 'echo "Dockerfile-petclinic" >> .git/info/sparse-checkout'
                        // git checkout
                        sh 'git read-tree -mu HEAD'
                    }
                    sh 'cp tmp_git_repo/Dockerfile-petclinic Dockerfile'
                    //sh './mvnw spring-boot:build-image'
                    dockerImage = docker.build("${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}", "--build-arg=JAR_FILE=${JAR_FILE_NAME} .")
                }
            }
        }
    }
}
