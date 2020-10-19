pipeline {
  agent none

  options {
    buildDiscarder(logRotator(numToKeepStr: '30'))
    timeout(time: 1, unit: 'HOURS')
    timestamps()
  }

  stages {
    stage('Test JJB') {
      when { beforeAgent true; anyOf { branch 'PR-*'; } }
      agent {
        kubernetes {
          yaml pipelineGetAgent(toolchain_version: "latest")
        }
      }
      steps{
      container('devops-toolchain') {
          sh '/opt/jenkins-job-builder/execute_jjb.sh test'
        }
      }
    }

    stage('Execute JJB') {
      when { beforeAgent true; anyOf { branch 'master'; branch 'main'; } }
      agent {
        kubernetes {
          yaml pipelineGetAgent(toolchain_version: "latest")
        }
      }
      steps{
      container('devops-toolchain') {
          sh '/opt/jenkins-job-builder/execute_jjb.sh update'
        }
      }
    }
  } 
}
