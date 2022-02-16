pipeline {
  agent any
  stages {
    stage('Pull Submodules') {
      steps {
        sh 'git submodule update --init'
      }
    }

    stage('Docker Build') {
      steps {
        sh 'PARALLEL_CORES=$(($(nproc)-10)) docker-compose up -d --build'
      }
    }

    stage('Run CI Tests') {
      steps {
        sh 'docker exec illixr-docker "/bin/bash /opt/ILLIXR/runner.sh /opt/ILLIXR/configs/ci.yaml; exit $?"'
      }
    }

    stage('Shutdown') {
      steps {
        sh 'docker-compose down'
      }
    }

  }
}