pipeline {
    agent any
    stages {
        stage('Load') {
            steps {
                sh 'scripts/build/load.sh'
            }
        }
        stage('Save image then test') {
            steps {
                sh 'scripts/build/test.sh'
                junit '*.xml'
            }
        }
        stage('Prepare deploy packages') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' 
              }
            }
            steps {
                sh 'scripts/build/package.sh'
            }
        }
        stage('Deploy packages') {
            steps {
                sh 'scripts/build/upload.sh'
            }
        }
    }
}