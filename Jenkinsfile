pipeline {
  agent {label 'awsDeploy2'}
  environment{
      DOCKERHUB_CREDENTIALS = credentials('tsanderson77-dockerhub')
      }
   stages {
     
    stage ('Test') {
      steps {
        sh '''#!/bin/bash
        python3.7 -m venv test
        source test/bin/activate
        pip install pip --upgrade
        pip install -r requirements.txt
        pip install mysqlclient
        pip install pytest
        py.test --verbose --junit-xml test-reports/results.xml
        '''
     }

       post{
        always {
          junit 'test-reports/results.xml'
        }
       
      }
   }
     
    stage ('Build') {
      steps {
          sh 'docker build -t tsanderson77/bankapp11 .'
    }
}
     stage ('Login') {
        steps {
          sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
}

     stage ('Push') {
        steps {
            sh 'docker push tsanderson77/bankapp11'
  }
     }

     stage('Init') {
       agent {label 'awsDeploy'}
       steps {
        withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'), 
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                            dir('intTerraform') {
                              sh 'terraform init' 
                            }
         }
    }
   }
      stage('Plan') {
        agent {label 'awsDeploy'}
       steps {
        withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'), 
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                            dir('intTerraform') {
                              sh 'terraform plan -out plan.tfplan -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key"' 
                            }
         }
    }
   }
      stage('Apply') {
        agent {label 'awsDeploy'}
       steps {
        withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'), 
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                            dir('intTerraform') {
                              sh 'terraform apply plan.tfplan' 
                            }
         }
    }
   }
 stage('Destroy') {
    agent {label 'awsDeploy'}
    steps {
          withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'),
              string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                dir('intTerraform') {
                    sh 'terraform destroy -auto-approve -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key"'
                  }
          }
    }
}

  }
}
