pipeline {
    agent any

    stages {
        stage('build and push to ecr') {
            steps {
                sh '''
                aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 101275806917.dkr.ecr.eu-west-2.amazonaws.com
                docker build -t 101275806917.dkr.ecr.eu-west-2.amazonaws.com/ecr-sai:$BUILD_NUMBER
                docker push 101275806917.dkr.ecr.eu-west-2.amazonaws.com/ecr-sai:$BUILD_NUMBER
                '''
            }
        }
    }
}
