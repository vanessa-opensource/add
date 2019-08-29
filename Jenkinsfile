@Library('jenkins_libs') _



DOCKER_REGISTRY_USER_CREDENTIONALS_ID  = 'gitlab.sb' //getParameterValue(buildEnv, 'DOCKER_REGISTRY_USER_CREDENTIONALS_ID')
DOCKER_REGISTRY_URL = 'https://registry.silverbulleters.org' // getParameterValue(buildEnv, 'DOCKER_REGISTRY_URL')
v8version = "${params.V8VERSION}"
ordinaryapp = "${params.ORDINARY_APP}" 

imageName = "registry.silverbulleters.org/landscape/ops/isasacode/vanessa-runner:${v8version}-latest"
imageNameSonar = 'registry.silverbulleters.org/landscape/ops/isasacode/silverbulleters/sonarqube-scanner:latest'

//constants
nethasp_fill = " echo >> /opt/1C/v8.3/x86_64/conf/nethasp.ini && echo NH_SERVER_ADDR = ${env.serverHasp} >> /opt/1C/v8.3/x86_64/conf/nethasp.ini "
xstart_and_novnc =  "set -xe && xstart && novnc && runxfce4 && ${nethasp_fill} && bash"

bddSettings =  " --vanessasettings tools/JSON/VBParams8310linux.json "
vrunner_bdd =  "vrunner vanessa --ordinaryapp ${ordinaryapp} --settings tools/JSON/vrunner.json ${bddSettings} --path "
vrunner_tdd =  "vrunner xunit "


running_set = [
    "Дымовое_тестирование": {
        smokeTest()
    },
    "Cобственные_TDD_тесты": {
        ownTest()
    },
    "BDD_тестирование_библиотек": {
        libraryBDDTest()
    },
    "stepsRunner": {
        stepsRunner()
    },
    "StepsGenerator": {
        stepsGenerator()
    },
    "StepsProgramming": {
        stepsProgramming()
    },
    "FeatureLoad": {
        featureLoad()
    },
    "featureReader": {
        featureReader()
    },
    "FeatureWrite": {
        featureWrite()
    },
    "ExpectedSomething": {
        expectedSomething()
    },
    "OpenForm": {
        openForm()
    },
    "TestClient": {
        testClient()
    },
    "Translate": {
        rantslate()
    },
    "Сборка_пакета": {
        build()
    }
]

def smokeTest(){
    testResultsPath = '**/build/junit-smoke/*.xml'
    command = "${vrunner_tdd} tests/smoke --settings tools/JSON/vrunner.json --ordinaryapp ${ordinaryapp} --reportsxunit \"ГенераторОтчетаJUnitXML{build/junit-smoke/junit.xml};ГенераторОтчетаAllureXMLВерсия2{build/allure/allure.xml}\""
    runXunitTest(command, testResultsPath)
}

def ownTest(){
    testResultsPath = '**/build/junit-tdd/*.xml'
    command = "${vrunner_tdd} tests/xunit --settings tools/JSON/vrunner.json --ordinaryapp ${ordinaryapp} --reportsxunit \"ГенераторОтчетаJUnitXML{build/junit-tdd/junit-tdd.xml};ГенераторОтчетаAllureXMLВерсия2{build/allure-tdd/allure.xml}\""
    runXunitTest(command, testResultsPath)
}

def libraryBDDTest(){
    testResultsPath = 'build/ServiceBases/junitreport/**/*.xml'
    command = "${vrunner_bdd} features/libraries"
    runVanessaTest(command, testResultsPath)
}


def stepsRunner(){
    command = "${vrunner_bdd} features/StepsRunner"
    runVanessaTestCore(command)
}

def stepsGenerator(){
    command = "${vrunner_bdd} features/StepsGenerator"
    runVanessaTestCore(command)
}

def stepsProgramming(){
    
    command = "${vrunner_bdd} features/StepsProgramming"
    runVanessaTestCore(command)
}

def featureLoad(){
     command = "${vrunner_bdd} features/Core/FeatureLoad"
    runVanessaTestCore(command)
}

def featureReader(){
    command = "${vrunner_bdd} features/Core/FeatureReader"
    runVanessaTestCore(command)
}

def featureWrite(){
    command = "${vrunner_bdd} features/Core/FeatureWrite"
    runVanessaTestCore(command)
}

def expectedSomething(){
    command = "${vrunner_bdd} features/Core/ExpectedSomething"
    runVanessaTestCore(command)
}

def openForm(){
    command = "${vrunner_bdd} features/Core/OpenForm"
    runVanessaTestCore(command)
}

def testClient(){
    command = "${vrunner_bdd} features/Core/TestClient"
    runVanessaTestCore(command)
}

def rantslate(){
    command = "${vrunner_bdd} features/Core/Translate"
    runVanessaTestCore(command)
}

def runVanessaTestCore(String command){
    docker.withRegistry(DOCKER_REGISTRY_URL, DOCKER_REGISTRY_USER_CREDENTIONALS_ID) {
        withDockerContainer(args: ' -P -u root:root', image: "${imageName}") {
            cmdRun(xstart_and_novnc)
            def buildKey = "core";
            withEnv(["VANESSA_BUILDNAME=${buildKey}"]) {
                try{
                    cmdRun(command)
                } finally {
                    cmdRun("chmod -R 777 ./build")  
                    junit allowEmptyResults: true, keepLongStdio: false, testResults: 'build/ServiceBases/junitreport/**/*.xml'                                        
                }
            }
        }
    }
}

def runVanessaTest(String command,  String testResultsPath){
    docker.withRegistry(DOCKER_REGISTRY_URL, DOCKER_REGISTRY_USER_CREDENTIONALS_ID) {
        withDockerContainer(args: ' -P -u root:root', image: "${imageName}") {
            cmdRun(xstart_and_novnc)
            def buildKey = "core";
            withEnv(["VANESSA_BUILDNAME=${buildKey}"]) {
                try{
                    cmdRun(command)
                } finally {
                    cmdRun("chmod -R 777 ./build") 
                    junit allowEmptyResults: true, keepLongStdio: false, testResults: testResultsPath                                          
                }
            }
        }
    }
}

def runXunitTest(String command, String testResultsPath){
    docker.withRegistry(DOCKER_REGISTRY_URL, DOCKER_REGISTRY_USER_CREDENTIONALS_ID) {
        withDockerContainer(args: '-P -u root:root', image: "${imageName}") {
            cmdRun(xstart_and_novnc)
            try{
                cmdRun(command)
            } finally {
                cmdRun("chmod -R 777 ./build")
                junit allowEmptyResults: true, keepLongStdio: false, testResults: testResultsPath                                          
            }
        }
    }
}

def build(){
    docker.withRegistry(DOCKER_REGISTRY_URL, DOCKER_REGISTRY_USER_CREDENTIONALS_ID) {
        withDockerContainer(args: '-P -u root:root', image: "${imageName}") {
            cmdRun(xstart_and_novnc)
            cmdRun("opm build .") 
            archiveArtifacts 'add-*.ospx'
            archiveArtifacts 'add-*.zip'
        }
    }
}

pipeline {

    agent { label 'docker' }
    options { 
      buildDiscarder(logRotator(numToKeepStr: '10'))
    //   disableConcurrentBuilds()
      timeout(time: 120, unit: 'MINUTES')
      timestamps() 
    }

    parameters {
        string(description: 'Версия платформы 1С:Предприятие', name: 'V8VERSION')
        string(defaultValue: "0", description: 'Режим запуска (толстый/тонкий клиент)', name: 'ORDINARY_APP')

    }

    post {  //Выполняется после сборки
        always {
            cmdRun("echo отчет junit")
            junit allowEmptyResults: true, testResults: '**/out/junit/*.xml'
            junit allowEmptyResults: true, testResults: '**/build/junit-smoke/*.xml'
            junit allowEmptyResults: true, testResults: '**/build/junit-tdd/*.xml'
            junit allowEmptyResults: true, testResults: '**/ServiceBases/junitreport/*.xml'
            cmdRun("echo отчет allure")
            allure includeProperties: false, jdk: '', results: [
              [path: 'build/allure'],
              [path: 'build/allure-tdd'],
              [path: 'build/ServiceBases/allurereport']
            ]
        }
    }

    stages {
        stage('First step') {
            parallel {
                stage('Подготовка окружения') {
                    steps {
                        timeout(30){
                            script{
                                docker.withRegistry(DOCKER_REGISTRY_URL, DOCKER_REGISTRY_USER_CREDENTIONALS_ID) {
                                    withDockerContainer(args: '-P -u root:root', image: "${imageName}") {
                                        cmdRun(xstart_and_novnc)
                                        cmdRun("echo opm run init file --v8version ${v8version}") // после отладки убрать
                                        cmdRun("opm run init file --v8version ${v8version}")
                                    }
                                }
                            }
                        }

                    }
                }
                
                stage('Статический анализ') {
                    steps {
                        timeout(30){
                            script{
                                docker.withRegistry(DOCKER_REGISTRY_URL, DOCKER_REGISTRY_USER_CREDENTIONALS_ID) {
                                    try{
                                        def sonarCommand = sonarqubeScan()
                                        withDockerContainer(args: '', image: "${imageNameSonar}") {
                                            cmdRun(sonarCommand)
                                        } 
                                    } catch (err) {
                                        println 'Ошибка во время выполнения синтаксической проверки'
                                        currentBuild.result = 'FAILURE'
                                    }   
                                }
                            }
                        }
                    }
                }
            }
        }

        stage('Тестирование и сборка') {             
            steps {
                timeout(120){
                    script{
                        parallel(running_set)
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