@Library("shared-library") _
pipeline {
    agent any
    parameters {
    string(
        name: 'ImageId',
        defaultValue: "ami-08e4e35cccc6189f4ddd",
        description: 'images stuff')
    string(
        name: 'InstanceType',
        defaultValue: "t2.micro",
        description: 'instances type' )
    choice(
        name: 'Desired_Configuration',
        choices: "UsingTerraform\nUsingCloudFormation",
        description: 'Terraform / Cloud Formation' )
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')       
      
    }
    tools {terraform "Terraform"} 
    
    stages {
        
        stage('build user') {
              steps {
                  script {
                    BUILD_TRIGGER_BY = "${currentBuild.getBuildCauses()[0].shortDescription}"
                    echo "BUILD_TRIGGER_BY: ${BUILD_TRIGGER_BY}"           
              }
              }
            } 
  
        stage('Planning terraform') {
        when {
        expression { params.Desired_Configuration == 'UsingTerraform'}
        }        
            agent{
                label 'ismaeel-slave11'
            }
        steps {
            sh "echo running Terraform script.............. "
            sh "terraform init"
            script{
            terraform.plan(ImageId:"${params.ImageId}",InstanceType:"${params.InstanceType}")
            }
        }
      
        }

        stage('Applying terraform') {
        when {
        expression { params.Desired_Configuration == 'UsingTerraform'}
        }             
        agent{
            label 'ismaeel-slave11'
        }
        steps {
            input(message: 'Do you want to apply', ok: 'Apply')
            script{
            terraform.apply(ImageId:"${params.ImageId}",InstanceType:"${params.InstanceType}")       
            }
         }
        }


      stage('Running Cloudformation') {
      when {
        expression { params.Desired_Configuration == 'UsingCloudFormation' }
      }        
          agent{
              label 'ismaeel-slave22'
          }
        steps {
           sh "echo Running CloudFormation script ............."
           sh "cd cloudformation && aws cloudformation validate-template --template-body file://ismaeelstack.yml --region us-east-1"
           createstack(ImageId:"${params.ImageId}",InstanceType:"${params.InstanceType}") 
        }
      } 
  
    }

   post {

        success {
            script{
                slackSend color: "#0DD410", message: "Build deployed successfully\nBuild ${BUILD_TRIGGER_BY}\nJob Name: ${env.JOB_NAME}\nBuild No: ${env.BUILD_NUMBER}\nBuild URL: (<${env.BUILD_URL}|Open>)"
            }
            }
        failure {
            script{
                slackSend color: "#EA3008", message: "Build deployed failed\nBuild ${BUILD_TRIGGER_BY}\nJob Name: ${env.JOB_NAME}\nBuild No: ${env.BUILD_NUMBER}\nBuild URL: (<${env.BUILD_URL}|Open>)"


            }
            }
    
    
    }



  }
