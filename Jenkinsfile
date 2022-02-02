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
         sh "terraform init"
         sh "terraform apply -auto-approve"
      }
    }  



  }
}
