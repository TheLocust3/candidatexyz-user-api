pipeline {
    agent {
        docker {
            image 'ruby'
        }
    }
    environment {
        PGUSER     = 'test'
        PGPASSWORD = credentials('db_password')
        PGHOST     = 'jenkins.cc5npzmk75z5.us-east-1.rds.amazonaws.com'
        PGPORT     = '5432'
        AWS_REGION = 'us-east-1'
    }

    stages {
        stage('Prepare/Checkout') {
            steps {
                dir('common') {
                    git branch: 'master', url: 'git@github.com:TheLocust3/candidatexyz-common.git', credentialsId:'common_ssh'
                }
            }
        }

        stage('Test') {
            steps {
                sh './run_jenkins.sh'
            }
        }
    }

    post {
        always {
            junit 'test/reports/*.xml'
        }
    }
}
