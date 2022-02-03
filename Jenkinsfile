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
      choices: "By Terraform\n By CloudFormation",
      description: 'Terraform / Cloud Formation' )       
    
  }
  tools {terraform "Terraform"} 
  stages {
        
    if("${params.Desired_Configuration}"=="By Terraform" ){ 
    stage('Running terraform') {
        agent{
            label 'ismaeel_slave_with_terraformPlugin'
        }
      steps {
         sh "echo running Terraform script.............. "
         sh "terraform init"
         sh "terraform plan"        
         sh "terraform apply -auto-approve"
      }
    }  
    }
    else {
    stage('Running Cloudformation') {
        agent{
            label 'ismaeel_slave1_websocket'
        }
      steps {
         sh "echo Running CloudFormation script ............."
         sh "cd cloudformation && aws cloudformation validate-template --template-body file://ismaeelstack.yml --region us-east-1"        
         sh "cd cloudformation && aws cloudformation create-stack --stack-name  ismaeelawsclitest2 --template-body file://ismaeelstack.yml --region us-east-1  --parameters ParameterKey=ImageId,ParameterValue=${params.ImageId} ParameterKey=InstanceType,ParameterValue=${params.InstanceType} "
      }
    } 

  }
  }
}
