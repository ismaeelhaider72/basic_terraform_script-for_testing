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
    stages {
          
      
        stage('Running terraform') {
        when {
        expression { params.Desired_Configuration == 'UsingTerraform' }
        }        
            agent{
                label 'ismaeel_slave_with_terraformPlugin'
            }
        steps {
            sh "echo running Terraform script.............. "
            sh "terraform init"
            sh "terraform plan -var imageId=${params.ImageId} -var instanceType=${params.InstanceType}"
            sh "echo 'in running section '"
            sh "ls -la"
        }

        }

        stage('Approval') {
            when {
                
                    equals expected: true, actual: params.autoApprove
                
            }
            steps {
                sh "terraform apply -var imageId=${params.ImageId}  -var instanceType=${params.InstanceType} -input=true -auto-approve"
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
  }
