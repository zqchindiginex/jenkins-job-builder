pipeline {
  agent {
    kubernetes {
      yaml pipelineGetAgent(toolchain_version: "latest")
      defaultContainer 'devops-toolchain'
    }
  }

  options {
    buildDiscarder(logRotator(numToKeepStr: '30'))
    timeout(time: 1, unit: 'HOURS')
    timestamps()
    skipDefaultCheckout true
  }

  stages {
    stage('Checkout') {
      steps{
        checkout scm
      }
    }
    stage('Test JJB') {
      when { beforeAgent true; anyOf { branch 'PR-*'; } }
      steps{
        sh './execute_jjb.sh test'
      }
    }

    stage('Execute JJB') {
      when { beforeAgent true; anyOf { branch 'master'; branch 'main'; } }
      steps{
        sh './execute_jjb.sh update'
      }
    }
  } 
}
