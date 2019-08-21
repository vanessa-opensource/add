@Library('jenkins_libs') _

pipeline {

    agent any

    stages {
        stage('Create test base') {
            agent { label 'docker' }
            steps {
                script {
                    DOCKER_REGISTRY_USER_CREDENTIONALS_ID  = 'gitlab.sb' //getParameterValue(buildEnv, 'DOCKER_REGISTRY_USER_CREDENTIONALS_ID') 
                    DOCKER_REGISTRY_URL = 'https://registry.silverbulleters.org' // getParameterValue(buildEnv, 'DOCKER_REGISTRY_URL')
                    
                    docker.withRegistry(DOCKER_REGISTRY_URL, DOCKER_REGISTRY_USER_CREDENTIONALS_ID) {
                    
                        withDockerContainer(args: ' -v /var/run/docker.sock:/var/run/docker.sock -v /usr/bin/docker:/usr/bin/docker -u root:root', image: 'registry.silverbulleters.org/landscape/ops/isasacode/silverbulleters/oscript-engine-full:nigthbuild') {
                            cmdRun("opm run initib file --buildFolderPath ./build")
                        }
                    }
                }
            }
        }
    }
}

