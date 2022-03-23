pipeline {
    parameters {
        string(name: 'VERSION', defaultValue: '1.00', description: 'The tag for go docker image')
        string(name: 'namespace', defaultValue: 'qa', description: 'The namespace for kubernetes')
    }
    environment {
        DEPLOY = "${env.BRANCH_NAME == "master" ? "true" : "false"}"
        REGISTRY = 'deepak1096/sendinblue'
        REGISTRY_CREDENTIAL = 'dockerhub-deepak'
    }
    agent {
        label 'docker-privileged'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master',
                credentialsId: 'deepak_gitid',
                url: 'https://github.com/deepakchandra1096/helloworld.git'
                }
            }
        }
        stage('Test') {
            steps {
                    sh 'go mod init test'
                    sh 'go mod tidy'
                    sh 'go test'
            }
        }
        
        stage('Docker Build') {
            steps {
                container('docker') {
                    sh "docker build -t ${REGISTRY}:${VERSION} ."
                }
            }
        }
        stage('Docker Publish') {
            when {
                environment name: 'DEPLOY', value: 'true'
            }
            steps {
                container('docker') {
                    withDockerRegistry([credentialsId: "${REGISTRY_CREDENTIAL}", url: ""]) {
                        sh "docker push ${REGISTRY}:${VERSION}"
                    }
                }
            }
        }
        stage('Kubernetes Deploy') {
            when {
                environment name: 'DEPLOY', value: 'true'
            }
            steps {
                container('helm') {
                    sh "helm upgrade --install --force --set name=${NAME}  --set image.repository=${REGISTRY} ${NAME} --set image.tag=${VERSION} --set replicaCount=2 ./helm -n ${namespace}"
                }
            }
        }
    }
}
