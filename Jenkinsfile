pipeline {
    agent any
    
    environment {
        // Defina o caminho do diretório de instalação do JDK que você deseja usar
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
                // Comandos para compilar o código ou construir a imagem Docker, por exemplo:
                sh '${M2_HOME}/bin/mvn clean package -DskipTests'
                script {
                    JAR_FILE_NAME = sh(returnStdout: true, script: 'ls target/*.jar').trim()
                }
            }
        }
        stage('Test') {
            steps {
                // Comandos para executar testes automatizados
                sh '${M2_HOME}/bin/mvn package test'
            }
        }
        stage('Docker Image Build') {
            steps {
                // Crie a imagem Docker utilizando o Dockerfile do seu projeto
                script {
                    dir('tmp_git_repo') {
                        // Clone do repositório com o modo shallow para economizar tempo e recursos
                        git branch: 'main', url: 'https://github.com/mkj2399/pet_pipe', shallow: true
                        // Ativar o recurso sparse-checkout
                        sh 'git config core.sparseCheckout true'
                        // Criar o arquivo .git/info/sparse-checkout contendo o caminho do arquivo específico que você deseja clonar
                        sh 'echo "Dockerfile-petclinic" >> .git/info/sparse-checkout'
                        // Fazer o checkout novamente para aplicar o sparse-checkout
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
