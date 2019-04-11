#!groovy

properties([disableConcurrentBuilds(), buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '10', daysToKeepStr: '', numToKeepStr: '10'))])
def tasks = [:]
def buildSerivceConf = ["836UF":"8.3.6", "837UF":"8.3.7", "838UF":"8.3.8", "839UF":"8.3.9", "8310UF":"8.3.10"];
//builds = ["82OF", "82UF", "836OF", "836UF", "837UF", "838UF", "839UF", "8310UF"]
//builds = ["836UF", "837UF", "838UF", "839UF", "8310UF"]
builds = ["8310UF"]
errorsStash = [:]
paths = [
    "libraries/Плагины": "libraries"
    // "libraries": "libraries"
    // , "Core/TestClient": "TestClient",
    // "StepsGenerator": "StepsGenerator",
    // "StepsRunner":"StepsRunner",
    // "StepsProgramming":"StepsProgramming",
    // "Core/FeatureLoad": "FeatureLoad",
    // "Core/FeatureReader": "FeatureReader",
    // "Core/FeatureWriter": "FeatureWriter",
    // "Core/OpenForm": "OpenForm",
    // "Core/Translate": "Translate",
    // "Core/ExpectedSomething": "ExpectedSomething"
    ]


if (env.filterBuilds && env.filterBuilds.length() > 0 ) {
    println "filter build";
    builds = builds.findAll{it.contains(env.filterBuilds) || env.filterBuilds.contains(it)};
}

def behaviortask(build, path, suffix, version){
    return {

        node ("${build}") {
                echo "====== ${build} ${suffix} ====="
                sleep 5
                cleanWs(patterns: [[pattern: 'build/**', type: 'INCLUDE']]);
                checkout scm
                unstash "buildResults"

                try{
                    println "before env.LOGOS_LEVEL = \'DEBUG\' "
                    // env.LOGOS_LEVEL = 'DEBUG'
                    // sh 'printenv'

                    cmd "opm run initib file --buildFolderPath ./build --v8version ${version}"

                    withEnv(["VANESSA_JUNITPATH=./ServiceBases/junitreport/${suffix}", "VANESSA_cucumberreportpath=./ServiceBases/cucumber/${suffix}"]) {
                        //Маленький хак, переход в dir автоматом создает каталог и не надо писать кроссплатформенный mkdir -p
                        dir("build/ServiceBases/junitreport/${suffix}"){}
                        dir("build/ServiceBases/cucumber/${suffix}"){}
                        echo "========= ${path} ====================="
                        cmd "opm run vanessa all --path ./features/${path} --settings ./tools/JSON/VBParams${build}.json";
                    }
                } catch (e) {
                    echo "behavior ${build} ${path} ${suffix} status : ${e}"
                    sleep 2
                    cmd("7z a -ssw build${build}${suffix}.7z ./build/ -xr!*.cfl", true)
                    archiveArtifacts "build${build}${suffix}.7z"
                    currentBuild.result = 'UNSTABLE'
                }
                stash allowEmpty: true, includes: "build/ServiceBases/allurereport/${build}/**, build/ServiceBases/cucumber/${suffix}/**, build/ServiceBases/junitreport/${suffix}/**", name: "${build}${suffix}"
        }

    }
}

builds.each{

    build = it;
    paths.each{
        tasks["behavior ${build} ${it.value}"] = behaviortask(build, it.key, it.value, buildSerivceConf[build])
    }
}

tasks["behavior video write"] = {
        node ("video") {
            stage("behavior video") {
            // ws(env.WORKSPACE.replaceAll("%", "_").replaceAll(/(-[^-]+$)/, ""))
            // {
            //     try{
            //         checkout scm
            //         cleanWs(patterns: [[pattern: 'build/**', type: 'INCLUDE']]);
            //         cleanWs(patterns: [[pattern: 'build/ServiceBases/allurereport/8310UF/**', type: 'INCLUDE']]);
            //         dir("build/ServiceBases/allurereport/8310UF"){}
            //         unstash "buildResults"

            //         println "before env.LOGOS_LEVEL = \'DEBUG\' "
            //         env.LOGOS_LEVEL = 'DEBUG'
            //         // sh 'printenv'

            //         cmd "opm install"
            //         cmd "opm list"
            //         cmd "opm run initib file --buildFolderPath ./build --v8version 8.3.10"

            //         cmd "opm run vanessa all --path ./features/Core/TestClient/  --tag video --settings ./tools/JSON/VBParams8310UF.json";
            //     } catch (e) {
            //         echo "behavior status : ${e}"
            //         currentBuild.result = 'UNSTABLE'
            //     }
            //     stash allowEmpty: true, includes: "build/ServiceBases/allurereport/8310UF/**", name: "video"
            // }
            // }

        }
    }
}
tasks["buildRelease"] = {
    node("slave"){
        stage("build release"){
            checkout scm
            cleanWs(patterns: [[pattern: 'build/**', type: 'INCLUDE']]);
            cleanWs(patterns: [[pattern: './.forbuild/**', type: 'INCLUDE']]);
            cleanWs(patterns: [[pattern: '*.ospx, add.tar.gz, add.tar.bz2, add.7z, add.tar', type: 'INCLUDE']])
            try{
                println "before env.LOGOS_LEVEL = \'DEBUG\' "
                // env.LOGOS_LEVEL = 'DEBUG'
                // sh 'printenv'

                cmd "opm build ./"
                // cmd "7z a add.tar ./.forbuild/features/ ./.forbuild/lib ./.forbuild/locales ./.forbuild/plugins ./.forbuild/vendor ./.forbuild/bddRunner.epf ./.forbuild/xddTestRunner.epf"
                // cmd "7z a add.7z ./.forbuild/features/ ./.forbuild/lib ./.forbuild/locales ./.forbuild/plugins ./.forbuild/vendor ./.forbuild/bddRunner.epf ./.forbuild/xddTestRunner.epf"
                // cmd "7z a add.tar.gz add.tar"
                // cmd "7z a add.tar.bz2 add.tar"
                // archiveArtifacts '*.ospx, add.tar.gz, add.tar.bz2, add.7z'
                // stash allowEmpty: false, includes: "*.ospx, add.tar.gz, add.tar.bz2, add.7z", name: "deploy"
                archiveArtifacts '*.ospx, add*.zip'
            } catch (e) {
                echo "opm build release status : ${e}"
                sleep 2
                currentBuild.result = 'UNSTABLE'
            }
            stash allowEmpty: false, includes: "*.ospx, add*.zip", name: "deploy"

        }
    }
}

tasks["xdd"] = {
    node("8310UF"){
        stage("xdd"){
                // checkout scm
                // cleanWs(patterns: [[pattern: 'build/**', type: 'INCLUDE']]);
                // unstash "buildResults"
                // try{
                //     println "before env.LOGOS_LEVEL = \'DEBUG\' "
                //     env.LOGOS_LEVEL = 'DEBUG'
                //     // sh 'printenv'

                //     cmd "opm run initib file --buildFolderPath ./build --v8version 8.3.10"

                //     cmd "opm run xdd";
                // } catch (e) {
                //     echo "xdd ${it} status : ${e}"
                //     sleep 2
                //     cmd("7z a -ssw buildXDD.7z ./build/ -xr!*.cfl", true)
                //     archiveArtifacts "buildXDD.7z"
                //     currentBuild.result = 'UNSTABLE'
                // }
                // stash allowEmpty: true, includes: "build/ServiceBases/allurereport/xdd/**, build/ServiceBases/junitreport/**", name: "xdd"
        }
    }
}
firsttasks=[:]
firsttasks["qa"] = {
    node("slave"){
        stage ("sonar QA"){
            unix = isUnix();
            if (env.QASONAR) {
                checkout scm
                try{
                    println env.QASONAR;
                    def sonarcommand = "@\"./../../tools/hudson.plugins.sonar.SonarRunnerInstallation/sonar-scanner/bin/sonar-scanner\""

                    withCredentials([string(credentialsId: env.OpenSonarOAuthCredentianalID, variable: 'SonarOAuth')]) {
                        sonarcommand = sonarcommand + " -Dsonar.host.url=https://opensonar.silverbulleters.org -Dsonar.login=${SonarOAuth}"
                    }

                    // TODO // Get version
                    // def configurationText = readFile encoding: 'UTF-8', file: 'epf/bddRunner/BddRunner/Ext/ObjectModule.bsl'
                    // def configurationVersion = (configurationText =~ /Версия = "(.*)";/)[0][1]
                    // sonarcommand = sonarcommand + " -Dsonar.projectVersion=${configurationVersion}"

                    def makeAnalyzis = true
                    if (env.BRANCH_NAME == "master") {
                        echo 'Analysing master branch'
                    } else if (env.BRANCH_NAME == "develop") {
                        echo 'Analysing develop branch'
                        sonarcommand = sonarcommand + " -Dsonar.branch.name=${BRANCH_NAME}"
                    } else if (env.BRANCH_NAME.startsWith("release/")) {
                        sonarcommand = sonarcommand + " -Dsonar.branch.name=${BRANCH_NAME}"
                    } else if (env.BRANCH_NAME.startsWith("PR-")) {
                        // Report PR issues
                        def PRNumber = env.BRANCH_NAME.tokenize("PR-")[0]
                        def gitURLcommand = 'git config --local remote.origin.url'
                        def gitURL = ""
                        if (unix) {
                            gitURL = sh(returnStdout: true, script: gitURLcommand).trim()
                        } else {
                            gitURL = bat(returnStdout: true, script: gitURLcommand).trim()
                        }
                        def repository = gitURL.tokenize("/")[2] + "/" + gitURL.tokenize("/")[3]
                        repository = repository.tokenize(".")[0]
                        withCredentials([string(credentialsId: env.GithubOAuthCredentianalID, variable: 'githubOAuth')]) {
                            sonarcommand = sonarcommand + " -Dsonar.analysis.mode=issues -Dsonar.github.pullRequest=${PRNumber} -Dsonar.github.repository=${repository} -Dsonar.github.oauth=${githubOAuth}"
                        }

                    } else {
                        echo "Анализ SonarQube не выполнен. Ветка ${env.BRANCH_NAME} не подходит по условию проверки веток!"
                        makeAnalyzis = false
                    }
                    try {
                        if (makeAnalyzis) {
                            if (unix) {
                                cmd(sonarcommand)
                            } else {
                                //echo "${sonarcommand}"
                                bat "${sonarcommand}"
                                //cmd(sonarcommand, unix)
                            }
                        }
                    } catch (e) {
                        echo "sonar status : ${e}"
                    }

                } catch (e) {
                    echo "sonar status : ${e}"
                }


            } else {
                println env.QASONAR
                echo "QA runner not installed"
            }
        }
    }
}

firsttasks["slave"] = {
    node("slave") {
        stage("checkout scm"){
            checkout scm
        }
        stage("build"){
            //def unix = isUnix()
            cleanWs(patterns: [[pattern: 'build/ServiceBases/**', type: 'INCLUDE']])
            cleanWs(patterns: [[pattern: 'build/**', type: 'INCLUDE']])
            // try{

                println "before env.LOGOS_LEVEL = \'DEBUG\' "
                // env.LOGOS_LEVEL = 'DEBUG'
                // sh 'printenv'

                cmd "opm run init file --buildFolderPath ./build"
            // } catch (e) {
            //     echo "opm run init ${it} status : ${e}"
            //     currentBuild.result = 'UNSTABLE'
            // }
            stash excludes: 'build/cache.txt,build/ib/**,build/ibservice/**, build/ibservicexdd/**', includes: 'build/**', name: 'buildResults'
            //stash includes: 'build/**', name: 'buildResults'
        }
    }
}

// TODO добавить установку правильного движка, например, через ovm и включить задачу linuxbuild
// firsttasks["linuxbuild"] = {
// node("slavelinux"){
//     stage ("checkout scm") {
//         //cleanWs();
//         unix = isUnix();
//             if (!unix) {
//                 command = "git config --local core.longpaths true"
//                 cmd(command);
//             }
//             checkout scm

//     }
//     stage("build"){
//         def unix = isUnix()
//         //sh 'ls -al ./build'
//         cmd("sudo docker pull wernight/ngrok")
//         command = 'sudo docker run --detach -e XVFB_RESOLUTION=1920x1080x24 --volume="${PWD}":/home/ubuntu/code onec32/client:8.3.10.2466 client > /tmp/container_id_${BUILD_NUMBER}';
//         echo command;
//         cmd(command);
//         sh 'sleep 10'
//         sh 'sudo docker exec -u ubuntu "$(cat /tmp/container_id_${BUILD_NUMBER})" /bin/bash -c "cd /home/ubuntu/code; DISPLAY=:1.0 sudo opm install && sudo opm update -all"'
//         sh 'sudo docker exec -u ubuntu "$(cat /tmp/container_id_${BUILD_NUMBER})" /bin/bash -c "cd /home/ubuntu/code; DISPLAY=:1.0 opm run init && opm run clean"'
//         sh 'sudo rm -f add*.ospx'
//         sh 'sudo docker exec -u ubuntu "$(cat /tmp/container_id_${BUILD_NUMBER})" /bin/bash -c "cd /home/ubuntu/code; DISPLAY=:1.0 opm build ./"'
//         sh 'sudo rm -rf add.tar.gz && sudo rm -f add-devel.tar.gz && sudo rm -f add.zip'
//         sh 'cd ./build; tar -czf ../add.tar.gz ./bddRunner.epf ./lib/ ./features/libraries ./vendor ./plugins ./locales; cd ..'
//         sh 'pwd && tar -czf ./add-devel.tar.gz ./build env.json;'
//         sh 'sudo docker exec -u ubuntu "$(cat /tmp/container_id_${BUILD_NUMBER})" /bin/bash -c "cd /home/ubuntu/code; DISPLAY=:1.0 pushd ./build; zip -r ../add.zip ./bddRunner.epf ./lib/ ./features/libraries ./vendor ./plugins ./locales; popd"'
//         sh 'tar -czf ./add-devel.tar.gz ./build env.json;'
//         sh 'sudo docker exec -u ubuntu "$(cat /tmp/container_id_${BUILD_NUMBER})" /bin/bash -c "cd /home/ubuntu/code; DISPLAY=:1.0 pushd ./build; zip -r ../add.zip ./bddRunner.epf ./lib/ ./features/libraries ./vendor ./plugins ./locales; popd"'
//         sh 'sudo docker stop "$(cat /tmp/container_id_${BUILD_NUMBER})"'
//         sh 'sudo docker rm "$(cat /tmp/container_id_${BUILD_NUMBER})"'

//         stash includes: 'build/**, *.ospx, add-devel.tar.gz, add.tar.gz, add.zip, env.json', excludes: 'build/cache.txt', name: 'buildResults'
//     }

//     stage("archive"){
//         archiveArtifacts 'add*.ospx,add.tar.gz,add-devel.tar.gz,add.zip'
//     }
// }
// }

//tasks["opmrunclean"] = {
//    node("slave"){
//        checkout scm
//        cmd "opm run clean"
//    }
//}

parallel firsttasks
stage('tests'){
    parallel tasks
}

tasks = [:]
tasks["report"] = {
    node {
        stage("report"){
            cleanWs(patterns: [[pattern: 'build/ServiceBases/**', type: 'INCLUDE']]);
            unstash 'buildResults'
            builds.each{
                build = it;
                paths.each{
                    unstash "${build}${it.value}"
                }
            }
            // unstash "video"
            // unstash "xdd"
            try{
                allure includeProperties: false, jdk: '',
                    results: [
                        [path: 'build/ServiceBases/allurereport/']
                    ]
                // allure commandline: 'allure2', includeProperties: false, jdk: '', results: [[path: 'build/ServiceBases/allurereport/']]
            } catch (e) {
                echo "allure status : ${e}"
                currentBuild.result = 'UNSTABLE'
            }
            junit 'build/ServiceBases/junitreport/**/*.xml'
            //junit 'build/ServiceBases/junitreport/*.xml'
            //cucumber fileIncludePattern: '**/*.json', jsonReportDirectory: 'build/ServiceBases/cucumber'

            try{
                archiveArtifacts 'build/ServiceBases/allurereport/**'
            } catch (e) {
                echo "report status : ${e}"
                currentBuild.result = 'UNSTABLE'
            }
            try{
            archiveArtifacts 'build/ServiceBases/junitreport/**'
            } catch (e) {
                echo "report status : ${e}"
                currentBuild.result = 'UNSTABLE'
            }
            try{
                archiveArtifacts 'build/ServiceBases/**'
            } catch (e) {
                echo "report status : ${e}"
                currentBuild.result = 'UNSTABLE'
            }
            //archiveArtifacts 'build/ServiceBases/junitreport/*.xml'
            //archiveArtifacts 'build/**'
        }
    }
}

//tasks["sonar"] = {
//}

parallel tasks

stage('Deploy') {
    if (env.BRANCH_NAME == 'master' || env.BRANCH_NAME == 'develop') {
        if (currentBuild.result == null || currentBuild.result == 'SUCCESS') {
            def userInput;
            try {
                timeout(time: 1, unit: 'DAYS') {
                    userInput = input("Deploy ${env.BRANCH_NAME}?")
                }
            } catch (err) {
                userInput = false;
                echo "Aborted by: [${user}]"
            }
            if (userInput == true ) {
                node("slave") {
                    unstash "deploy"
                    withCredentials([[$class: 'StringBinding', credentialsId: 'GITHUB_OAUTH_TOKEN_ADD', variable: 'GITHUB_OAUTH_TOKEN']]) {
                        if(env.BRANCH_NAME == 'master'){
                            echo "master "
                            cmd("opm push --token $GITHUB_OAUTH_TOKEN --channel stable --file ./add-*.ospx")
                            sh "echo $GITHUB_TOKEN"
                        } else if (env.BRANCH_NAME == 'develop') {
                            echo "develop"
                            cmd("opm push --token $GITHUB_OAUTH_TOKEN --channel dev --file ./add-*.ospx")

                        }
                    }
                }

            }
        }
    }
}


def cmd(command, status = false) {
    // TODO при запуске Jenkins не в режиме UTF-8 нужно написать chcp 1251 вместо chcp 65001
    isunix = isUnix();
    if (isunix) { sh returnStatus: status, script: "${command}" } else {bat returnStatus: status, script: "chcp 65001\n${command}"}
}
