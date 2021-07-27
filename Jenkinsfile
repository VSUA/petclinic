pipeline {
    agent none
    stages {
        stage('Build project') {
            agent {
                docker {
                    image 'openjdk:8'
                    args '-v buildPetclinic:/tmp/?/.m2/'
                }
            }
            steps {
                sh 'pwd'
                //sh 'cp -r ? ./petclinic'
                //sh 'ls ./petclinic/'
                //dir('./petclinic') {
                //    sh 'ls'
                //    sh './mvnw package -Dcheckstyle.skip=true'
                //}
                sh './mvnw package -Dcheckstyle.skip=true'
                //sh 'ls ./petclinic/target/'
                sh 'cp ./target/spring-petclinic-2.4.5.jar .'
                //sh 'ls /tmp/'
                
            }
        }
        
        stage('Build container and push it on DockerHub') {
            agent {
                label 'DockerNode'    
            }
            
            environment {
                registry = "vsua/petclinic"
                registryCredential = 'dockerhub'
                dockerImage = ''
            }
            
            steps {
                //dir('./petclinic') {
                script {
                    dockerImage = docker.build registry + ":latest"//$BUILD_NUMBER
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                    }
                }
                //}
                sh "docker rmi $registry:latest"//$BUILD_NUMBER
            }
        }
        stage('Run container with java app') {
            agent {
                label 'DockerNode'    
            }
            
            steps {
                sh "docker stop vsua/petclinic || true && docker rm vsua/petclinic || true && docker run -d -p 8080:8080 vsua/petclinic"
            }
        }
        
        //stage('Remove project folder') {
        //    agent {
        //        label 'DockerNode'    
        //    }
            
        //    steps {
        //        sh 'rm -rf ./petclinic'
        //    }
        //}
    }
    environment {
        EMAIL_TO = 'slobodianiuk.vladyslav@gmail.com'
    }
    
    post {
        failure {
            emailext body: 'Check console output at $BUILD_URL to view the results. \n\n ${CHANGES} \n\n -------------------------------------------------- \n${BUILD_LOG, maxLines=100, escapeHtml=false}', 
                    to: "${EMAIL_TO}", 
                    subject: 'Build failed in Jenkins: $PROJECT_NAME - #$BUILD_NUMBER'
        }
        unstable {
            emailext body: 'Check console output at $BUILD_URL to view the results. \n\n ${CHANGES} \n\n -------------------------------------------------- \n${BUILD_LOG, maxLines=100, escapeHtml=false}', 
                    to: "${EMAIL_TO}", 
                    subject: 'Unstable build in Jenkins: $PROJECT_NAME - #$BUILD_NUMBER'
        }
        changed {
            emailext body: 'Check console output at $BUILD_URL to view the results.', 
                    to: "${EMAIL_TO}", 
                    subject: 'Jenkins build is back to normal: $PROJECT_NAME - #$BUILD_NUMBER'
        }
    }
}
