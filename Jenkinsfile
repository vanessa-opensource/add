@Library('jenkins_libs') _

pipeline {

    agent any

    post {
        success {
            script {
                sendEmailMessage.sendChangelog(EMAILS_FOR_NOTIFICATION: 
                    'alustin@silverbulleters.org, zhdanovri@silverbulleters.org, ye.ivanov@silverbulleters.org'
                )
            }
        } 
    }

    stages {
        stage('Create test base') {
            agent { label getParameterValue(buildEnv, 'DOCKER_HOST') }
                steps {
                    script {
                        DOCKER_REGISTRY_USER_CREDENTIONALS_ID  = getParameterValue(buildEnv, 'DOCKER_REGISTRY_USER_CREDENTIONALS_ID') 
                        DOCKER_REGISTRY_URL = getParameterValue(buildEnv, 'DOCKER_REGISTRY_URL')
                        
                        docker.withRegistry(DOCKER_REGISTRY_URL, DOCKER_REGISTRY_USER_CREDENTIONALS_ID) {
                            withDockerContainer(args: volumeDockerString, image: OSCRIPT_IMAGES_NAME) {
                                dir(BUILD_DIR) {
                                    cmdRun("opm run initib file --buildFolderPath ./build"")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}