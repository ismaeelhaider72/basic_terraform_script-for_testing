pipeline {
    agent any
    parameters {
    string(
        name: 'ImageId',
        defaultValue: "ami-08e4e35cccc6189f4",
        description: 'images stuff')
    string(
        name: 'InstanceType',
        defaultValue: "t2.small",
        description: 'instance type' )
    choice(
        name: 'Desired_Configuration',
        choices: "UsingTerraform\nUsingCloudFormation",
        description: 'Terraform / Cloud Formation' )
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')       
      
    }
    tools {terraform "Terraform"} 
    wrap([$class: 'BuildUser']) {
        def user = env.BUILD_USER_ID
        }

    stages {
        
        stage('build user') {
          steps {
                sh "BUILD_TRIGGER_BY=$(curl -k --silent ${BUILD_URL}/api/xml | tr '<' '\n' | egrep '^userId>|^userName>' | sed 's/.*>//g' | sed -e '1s/$/ \//g' | tr '\n' ' ')"
                sh 'echo "BUILD_TRIGGER_BY: ${BUILD_TRIGGER_BY}"'
          }
        }          
      
        stage('Planning terraform') {
        when {
        expression { params.Desired_Configuration == 'UsingTerraform'}
        }        
            agent{
                label 'ismaeel_slave_with_terraformPlugin'
            }
        steps {
            sh "echo running Terraform script.............. "                  
            sh "terraform init"
            sh "terraform plan -no-color -var imageId=${params.ImageId} -var instanceType=${params.InstanceType}"
        
        }
      
        }

        stage('Applying terraform') {
        when {
        expression { params.autoApprove == true}
        }             
        agent{
            label 'ismaeel_slave_with_terraformPlugin'
        }
        steps {
            input(message: 'Do you want to apply', ok: 'Apply')
            sh "terraform apply -no-color -var imageId=${params.ImageId}  -var instanceType=${params.InstanceType} -auto-approve -lock=false"       
        }

        }


      stage('Running Cloudformation') {
      when {
        expression { params.Desired_Configuration == 'UsingCloudFormation' }
      }        
          agent{
              label 'ismaeel_slave2'
          }
        steps {
           sh "echo Running CloudFormation script ............."
           sh "cd cloudformation && aws cloudformation validate-template --template-body file://ismaeelstack.yml --region us-east-1"        
           sh "cd cloudformation && aws cloudformation create-stack --stack-name  ismaeelawsclitest2 --template-body file://ismaeelstack.yml --region us-east-1  --parameters ParameterKey=ImageId,ParameterValue=${params.ImageId} ParameterKey=InstanceType,ParameterValue=${params.InstanceType} "
        }
      } 
  
    }

   post {

        success {
            script{
                slackSend color: '#AAFF00', message: "Username: ${user}"
                slackSend color: '#AAFF00', message: "Build Successful - Job Name:${env.JOB_NAME}  Build Number:${env.BUILD_NUMBER}  Build URL:(<${env.BUILD_URL}|Open>)"
            }
            }
        failure {
            script{
                slackSend color: '#FF0000', message: "Username: ${user}"
                slackSend color: '#FF0000', message: "Build failure occured - Job Name:${env.JOB_NAME}  Build Number:${env.BUILD_NUMBER}  Build URL:(<${env.BUILD_URL}|Open>)"


            }
            }
    
    
    }



  }
