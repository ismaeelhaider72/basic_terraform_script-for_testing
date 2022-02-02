pipeline {
  agent any
  tools {terraform "Terraform"} 
  stages {
        
    stage('Git') {
      steps {
        git branch: 'main', url: 'https://github.com/ismaeelhaider72/basic_terraform_script-for_testing.git'
      }
    }
     
    stage('Running terraform') {
        agent{
            label 'ismaeel_slave_with_terraformPlugin'
        }
      steps {
         sh "echo running Terraform.............. "
         sh "terraform init"
         sh "terraform plan"        
         sh "terraform apply -auto-approve"
      }
    }  
    stage('Running Cloudformation') {
        agent{
            label 'ismaeel_slave1_websocket'
        }
      steps {
         sh "echo Running CloudFormation script ............."
         sh "cd cloudformation && aws cloudformation validate-template --template-body file://ismaeelstack.yml --region us-east-1"        
         sh "aws cloudformation create-stack --stack-name  ismaeelawsclitest2 --template-body file://ismaeelstack.yml --region us-east-1  --parameters ParameterKey=ImageId,ParameterValue=ami-04505e74c0741db8d ParameterKey=InstanceType,ParameterValue=t2.micro"
      }
    } 


  }
}
