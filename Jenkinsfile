@Library('jenkins_libs') _

//parameters
// sonarQubeURL=http://172.25.1.254:9000
// OpenSonarOAuthCredentianalID=SonarOAuth
// serverHasp=10.77.1.141

def DOCKER_REGISTRY_USER_CREDENTIONALS_ID  = 'gitlab.sb' //getParameterValue(buildEnv, 'DOCKER_REGISTRY_USER_CREDENTIONALS_ID')
def DOCKER_REGISTRY_URL = 'https://registry.silverbulleters.org' // getParameterValue(buildEnv, 'DOCKER_REGISTRY_URL')
def v8version = "8.3.15.1489"

def imageName = "registry.silverbulleters.org/landscape/ops/isasacode/vanessa-runner:${v8version}-latest"
def imageNameSonar = 'registry.silverbulleters.org/landscape/ops/isasacode/silverbulleters/sonarqube-scanner:latest'

//constants

def nethasp_fill = " echo >> /opt/1C/v8.3/x86_64/conf/nethasp.ini && echo NH_SERVER_ADDR = ${env.serverHasp} >> /opt/1C/v8.3/x86_64/conf/nethasp.ini "
// def xstart =            "set -xe && xstart && ${nethasp_fill} && bash"
def xstart_and_novnc =  "set -xe && xstart && novnc && runxfce4 && ${nethasp_fill} && bash"

def bddSettings =  " --vanessasettings tools/JSON/VBParams8310linux.json "
def vrunner_bdd =  "vrunner vanessa --settings tools/JSON/vrunner.json ${bddSettings} --path "
def vrunner_tdd =  "vrunner xunit "

pipeline {

    agent { label 'docker' }
    options { 
      buildDiscarder(logRotator(numToKeepStr: '10'))
      disableConcurrentBuilds()
      timeout(time: 60, unit: 'MINUTES')
      timestamps() 
    }

    post {  //Выполняется после сборки
        always {
            cmdRun("echo отчет junit")
            junit allowEmptyResults: true, testResults: '**/out/junit/*.xml'
            junit allowEmptyResults: true, testResults: '**/build/junit-smoke/*.xml'
            junit allowEmptyResults: true, testResults: '**/build/junit-tdd/*.xml'
            junit allowEmptyResults: true, testResults: '**/ServiceBases/junitreport/*.xml'
            cmdRun("echo отчет allure")
            // allure includeProperties: false, jdk: '', results: [[path: 'out/allure'], [path: 'out/addallure.xml']]
            allure includeProperties: false, jdk: '', results: [
              [path: 'build/allure'],
              [path: 'build/allure-tdd'],
              [path: 'build/ServiceBases/allurereport']
            ]
        }
    }

    stages {

        stage('Подготовка окружения') {
            steps {
                timeout(30){
                    script{
                        docker.withRegistry(DOCKER_REGISTRY_URL, DOCKER_REGISTRY_USER_CREDENTIONALS_ID) {
                            withDockerContainer(args: '-p 6080:6080 -u root:root', image: "${imageName}") {
                                cmdRun(xstart_and_novnc)
                                cmdRun("opm run init file --v8version ${v8version}")
                            }
                        }
                    }
                }

            }
        }

        stage('Тестирование') {
            parallel {
                stage('Статический анализ') {
                    steps {
                        timeout(30){
                            script{
                                docker.withRegistry(DOCKER_REGISTRY_URL, DOCKER_REGISTRY_USER_CREDENTIONALS_ID) {
                                    def sonarCommand = sonarqubeScan()
                                    cmdRun("echo sonarCommand:  ${sonarCommand}")
                                    withDockerContainer(args: '', image: "${imageNameSonar}") {
                                        cmdRun(sonarCommand)
                                    }
                                }
                            }
                        }
                    }
                }

                stage('Дымовое тестирование') {
                    steps {
                        timeout(40){
                            script{
                                docker.withRegistry(DOCKER_REGISTRY_URL, DOCKER_REGISTRY_USER_CREDENTIONALS_ID) {
                                    withDockerContainer(args: '-p 6080:6080 -u root:root', image: "${imageName}") {
                                        cmdRun(xstart_and_novnc)
                                        try{
                                          cmdRun("${vrunner_tdd} tests/smoke --settings tools/JSON/vrunner.json --reportsxunit \"ГенераторОтчетаJUnitXML{build/junit-smoke/junit.xml};ГенераторОтчетаAllureXMLВерсия2{build/allure/allure.xml}\"")
                                        } finally {
                                          cmdRun("chmod -R 777 ./build")                                          
                                        }
                                    }
                                }
                            }
                        }
                    }
                    post {
                        always {
                            cmdRun("echo отчет junit-smoke")
                            junit allowEmptyResults: true, keepLongStdio: false, testResults: '**/build/junit-smoke/*.xml'
                            // allure includeProperties: false, jdk: '', results: [[path: 'build/allure']]
                            // allure includeProperties: false, jdk: '', results: [[path: 'out/allure'], [path: 'out/addallure.xml']]
                        }
                    }
                }

                stage('Cобственные TDD-тесты') {
                    steps {
                        timeout(30){
                            script{
                                docker.withRegistry(DOCKER_REGISTRY_URL, DOCKER_REGISTRY_USER_CREDENTIONALS_ID) {
                                    withDockerContainer(args: '-p 6081:6080 -u root:root', image: "${imageName}") {
                                        cmdRun(xstart_and_novnc)
                                        try{
                                          cmdRun("${vrunner_tdd} tests/xunit --settings tools/JSON/vrunner.json --reportsxunit \"ГенераторОтчетаJUnitXML{build/junit-tdd/junit-tdd.xml};ГенераторОтчетаAllureXMLВерсия2{build/allure-tdd/allure.xml}\"")
                                        } finally {
                                          cmdRun("chmod -R 777 ./build")                                          
                                        }
                                    }
                                }
                            }
                        }
                    }
                    post {
                        always {
                            cmdRun("echo отчет junit-tdd")
                            junit allowEmptyResults: true, keepLongStdio: false, testResults: '**/build/junit-tdd/*.xml'
                            // allure includeProperties: false, jdk: '', results: [[path: 'build/allure-tdd']]
                        }
                    }
                }

                stage('BDD тестирование (библиотеки)') {
                    steps {
                        timeout(30){
                            script{
                                docker.withRegistry(DOCKER_REGISTRY_URL, DOCKER_REGISTRY_USER_CREDENTIONALS_ID) {
                                    withDockerContainer(args: '-p 6082:6080 -u root:root', image: "${imageName}") {
                                        cmdRun(xstart_and_novnc)
                                        def buildKey = "libraries";
                                        withEnv(["VANESSA_BUILDNAME=${buildKey}"]) {
                                          try{
                                            cmdRun("${vrunner_bdd} features/libraries")
                                          } finally {
                                            cmdRun("chmod -R 777 ./build")                                          
                                          }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    post {
                        always {
                            cmdRun("echo отчет bdd-libraries")
                            junit allowEmptyResults: true, keepLongStdio: false, testResults: 'build/ServiceBases/junitreport/**/*.xml'
                            // allure includeProperties: false, jdk: '', results: [[path: 'build/ServiceBases/allurereport']]
                        }
                    }
                }

                stage('BDD тестирование (ядро)') {
                    steps {
                        timeout(60){
                            script{
                                docker.withRegistry(DOCKER_REGISTRY_URL, DOCKER_REGISTRY_USER_CREDENTIONALS_ID) {
                                    withDockerContainer(args: '-p 6083:6080 -u root:root', image: "${imageName}") {
                                        cmdRun(xstart_and_novnc)
                                        def buildKey = "core";
                                        withEnv(["VANESSA_BUILDNAME=${buildKey}"]) {
                                          try{
                                            cmdRun("${vrunner_bdd} features/StepsRunner")
                                            cmdRun("${vrunner_bdd} features/StepsGenerator")
                                            cmdRun("${vrunner_bdd} features/StepsProgramming")
                                            cmdRun("${vrunner_bdd} features/Core/FeatureLoad")
                                            cmdRun("${vrunner_bdd} features/Core/FeatureReader")
                                            cmdRun("${vrunner_bdd} features/Core/FeatureWrite")
                                            cmdRun("${vrunner_bdd} features/Core/ExpectedSomething")
                                            cmdRun("${vrunner_bdd} features/Core/OpenForm")
                                            cmdRun("${vrunner_bdd} features/Core/TestClient")
                                            cmdRun("${vrunner_bdd} features/Core/Translate")
                                          } finally {
                                            cmdRun("chmod -R 777 ./build")                                          
                                          }
                                      }
                                    }
                                }
                            }
                        }
                    }
                    post {
                        always {
                            cmdRun("echo отчет bdd-core")
                            junit allowEmptyResults: true, keepLongStdio: false, testResults: 'build/ServiceBases/junitreport/**/*.xml'
                            // allure includeProperties: false, jdk: '', results: [[path: 'build/ServiceBases/allurereport']]
                        }
                    }
                }
            }
        }
    }

}

def sonarqubeScan() {

    def projectVersion = ""

    def configurationText = readFile encoding: 'UTF-8', file: 'epf/bddRunner/bddRunner/Ext/ObjectModule.bsl'
    def configurationVersion = (configurationText =~ /Версия = "(.*)";/)[0][1]
    projectVersion = "-Dsonar.projectVersion=${configurationVersion}"


    def sonarCommand = "sonar-scanner -X ${projectVersion}"

    withCredentials([string(credentialsId: env.OpenSonarOAuthCredentianalID, variable: 'SonarOAuth')]) {
        sonarCommand = sonarCommand + " -Dsonar.host.url=${env.sonarQubeURL} -Dsonar.login=${SonarOAuth}"
    }

    def makeAnalyzis = true
    // if (env.BRANCH_NAME == "master") {
    //     echo 'Analysing master branch'
    // } else if (env.BRANCH_NAME == "develop") {
    //     echo 'Analysing develop branch'
    //     // sonarCommand = sonarCommand + " -Dsonar.branch.name=${BRANCH_NAME}"
    // } else if (env.BRANCH_NAME.startsWith("release/") || env.BRANCH_NAME.startsWith("feature/")) {
    //     // sonarCommand = sonarCommand + " -Dsonar.branch.name=${BRANCH_NAME}"
    // } else if (env.BRANCH_NAME.startsWith("PR-")) {
    //     // Report PR issues
    //     def PRNumber = env.BRANCH_NAME.tokenize("PR-")[0]
    //     def gitURLcommand = 'git config --local remote.origin.url'
    //     def gitURL = ""
    //     if (isUnix) {
    //         gitURL = sh(returnStdout: true, script: gitURLcommand).trim()
    //     } else {
    //         gitURL = bat(returnStdout: true, script: gitURLcommand).trim()
    //     }
    //     def repository = gitURL.tokenize("/")[2] + "/" + gitURL.tokenize("/")[3]
    //     repository = repository.tokenize(".")[0]
    //     // withCredentials([string(credentialsId: env.GithubOAuthCredentianalID, variable: 'githubOAuth')]) {
    //     //     sonarCommand = sonarCommand + " -Dsonar.analysis.mode=issues -Dsonar.github.pullRequest=${PRNumber} -Dsonar.github.repository=${repository} -Dsonar.github.oauth=${githubOAuth}"
    //     // }
    // } else {
    //     echo "Анализ SonarQube не выполнен. Ветка ${env.BRANCH_NAME} не подходит по условию проверки веток!"
    //     makeAnalyzis = false
    // }

    return sonarCommand

}