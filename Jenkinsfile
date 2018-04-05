#!groovy

properties([buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '10', daysToKeepStr: '', numToKeepStr: '10'))])
def tasks = [:]
def buildSerivceConf = ["836UF":"8.3.6", "837UF":"8.3.7", "838UF":"8.3.8", "839UF":"8.3.9", "8310UF":"8.3.10"];
//builds = ["82OF", "82UF", "836OF", "836UF", "837UF", "838UF", "839UF", "8310UF"]
//builds = ["836UF", "837UF", "838UF", "839UF", "8310UF"]
builds = ["8310UF"]
errorsStash = [:]

if (env.filterBuilds && env.filterBuilds.length() > 0 ) {
    println "filter build";
    builds = builds.findAll{it.contains(env.filterBuilds) || env.filterBuilds.contains(it)};
}
builds.each{

    tasks["behavior ${it}"] = {
        node ("${it}") {
            stage("behavior ${it}") {
            // steps {
                // в среде Multibranch Pipeline Jenkins первращает имена веток в папки
                // а для веток Gitflow вида release/* экранирует в слэш в %2F
                //
                // Поэтому, применяем костыль с кастомным workspace
                // см. https://issues.jenkins-ci.org/browse/JENKINS-34564
                //
                // Jenkins под Windows постоянно добавляет в конец папки какую-то мусорную строку.
                // Для этого отсекаем все, что находится после последнего дефиса
                // см. https://issues.jenkins-ci.org/browse/JENKINS-40072
            ws(env.WORKSPACE.replaceAll("%", "_").replaceAll(/(-[^-]+$)/, ""))
            {
                checkout scm
                unstash "buildResults"
                cmd "opm install"
                cmd "opm list"
                cmd "opm run initib file --buildFolderPath ./build --v8version " + buildSerivceConf[it]
                try{
                    cmd "opm run vanessa all --settings ./tools/JSON/VBParams${it}.json";
                } catch (e) {
                    echo "behavior ${it} status : ${e}"
                    sleep 61
                    cmd("7z a -ssw build${it}.7z ./build/ -xr!*.cfl", true)
                    archiveArtifacts "build${it}.7z"
                    currentBuild.result = 'UNSTABLE'
                }
                stash allowEmpty: true, includes: "build/ServiceBases/allurereport/${it}/**, build/ServiceBases/cucumber/**, build/ServiceBases/junitreport/**", name: "${it}"
            }
            // }
            }
        }
    }
}

tasks["behavior video write"] = {
        node ("video") {
            stage("behavior video") {
            ws(env.WORKSPACE.replaceAll("%", "_").replaceAll(/(-[^-]+$)/, ""))
            {
                checkout scm
                cleanWs(patterns: [[pattern: 'build/ServiceBases/allurereport/8310UF/**', type: 'INCLUDE']]);
                unstash "buildResults"
                cmd "opm install"
                cmd "opm list"
                cmd "opm run initib file --buildFolderPath ./build --v8version 8.3.10"
                try{
                    cmd "opm run vanessa all --path ./build/features/Core/TestClient/  --tag video --settings ./tools/JSON/VBParams8310UF.json";
                } catch (e) {
                    echo "behavior status : ${e}"
                    currentBuild.result = 'UNSTABLE'
                }
                stash allowEmpty: true, includes: "build/ServiceBases/allurereport/8310UF/**", name: "video"
            }
            // }
            
        }
    }
}
tasks["buildRelease"] = {
    node("slave"){
        stage("build release"){
            checkout scm
            cleanWs(patterns: [[pattern: '*.ospx, add.tar.gz, add.tar.bz2, add.7z, add.tar', type: 'INCLUDE']])
            cmd "opm build ./"
            cmd "7z a add.tar ./.forbuild/features/ ./.forbuild/lib ./.forbuild/locales ./.forbuild/plugins ./.forbuild/vendor ./.forbuild/bddRunner.epf ./.forbuild/xddTestRunner.epf"
            cmd "7z a add.7z ./.forbuild/features/ ./.forbuild/lib ./.forbuild/locales ./.forbuild/plugins ./.forbuild/vendor ./.forbuild/bddRunner.epf ./.forbuild/xddTestRunner.epf"
            cmd "7z a add.tar.gz add.tar"
            cmd "7z a add.tar.bz2 add.tar"
            archiveArtifacts '*.ospx, add.tar.gz, add.tar.bz2, add.7z'
            stash allowEmpty: false, includes: "*.ospx, add.tar.gz, add.tar.bz2, add.7z", name: "deploy"

        }
    }
}

tasks["xdd"] = {
    node("8310UF"){
        stage("xdd"){
                checkout scm
                unstash "buildResults"
                cmd "opm run initib file --buildFolderPath ./build --v8version 8.3.10"
                try{
                    cmd "opm run xdd";
                } catch (e) {
                    echo "xdd ${it} status : ${e}"
                    sleep 61
                    cmd("7z a -ssw buildXDD.7z ./build/ -xr!*.cfl", true)
                    archiveArtifacts "buildXDD.7z"
                    currentBuild.result = 'UNSTABLE'
                }
                stash allowEmpty: true, includes: "build/ServiceBases/allurereport/xdd/**, build/ServiceBases/junitreport/**", name: "xdd"
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
                //try{
                    println env.QASONAR;
                    def sonarcommand = "@\"./../../tools/hudson.plugins.sonar.SonarRunnerInstallation/Main_Classic/bin/sonar-scanner\""
                    withCredentials([[$class: 'StringBinding', credentialsId: env.SonarOAuthCredentianalID, variable: 'SonarOAuth']]) {
                        sonarcommand = sonarcommand + " -Dsonar.host.url=https://sonar.silverbulleters.org -Dsonar.login=${env.SonarOAuth}"
                    }
                    
                    // TODO // Get version
                    // def configurationText = readFile encoding: 'UTF-8', file: 'epf/bddRunner/BddRunner/Ext/ObjectModule.bsl'
                    // def configurationVersion = (configurationText =~ /Версия = "(.*)";/)[0][1]
                    // sonarcommand = sonarcommand + " -Dsonar.projectVersion=${configurationVersion}"

                    def makeAnalyzis = true
                    if (env.BRANCH_NAME == "develop") {
                        echo 'Analysing develop branch'
                    } else if (env.BRANCH_NAME.startsWith("release/")) {
                        sonarcommand = sonarcommand + " -Dsonar.branch=${BRANCH_NAME}"
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
                        withCredentials([[$class: 'StringBinding', credentialsId: env.GithubOAuthCredentianalID, variable: 'githubOAuth']]) {
                            sonarcommand = sonarcommand + " -Dsonar.analysis.mode=issues -Dsonar.github.pullRequest=${PRNumber} -Dsonar.github.repository=${repository} -Dsonar.github.oauth=${env.githubOAuth}"
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
        
                //} catch (e) {
                //    echo "sonar status : ${e}"
                //}

                
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
            cmd "opm run init file --buildFolderPath ./build"
            //stash includes: 'build/**',  excludes: 'build/cache.txt', name: 'buildResults'
            stash includes: 'build/**', name: 'buildResults'
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
//         sh 'sudo rm -f vanessa-behavior*.ospx'
//         sh 'sudo docker exec -u ubuntu "$(cat /tmp/container_id_${BUILD_NUMBER})" /bin/bash -c "cd /home/ubuntu/code; DISPLAY=:1.0 opm build ./"'
//         sh 'sudo rm -rf vanessa-behavior.tar.gz && sudo rm -f vanessa-behavior-devel.tar.gz && sudo rm -f vanessa-behavior.zip'
//         sh 'cd ./build; tar -czf ../vanessa-behavior.tar.gz ./bddRunner.epf ./lib/ ./features/libraries ./vendor ./plugins ./locales; cd ..'
//         sh 'pwd && tar -czf ./vanessa-behavior-devel.tar.gz ./build env.json;'
//         sh 'sudo docker exec -u ubuntu "$(cat /tmp/container_id_${BUILD_NUMBER})" /bin/bash -c "cd /home/ubuntu/code; DISPLAY=:1.0 pushd ./build; zip -r ../vanessa-behavior.zip ./bddRunner.epf ./lib/ ./features/libraries ./vendor ./plugins ./locales; popd"'
//         sh 'tar -czf ./vanessa-behavior-devel.tar.gz ./build env.json;'
//         sh 'sudo docker exec -u ubuntu "$(cat /tmp/container_id_${BUILD_NUMBER})" /bin/bash -c "cd /home/ubuntu/code; DISPLAY=:1.0 pushd ./build; zip -r ../vanessa-behavior.zip ./bddRunner.epf ./lib/ ./features/libraries ./vendor ./plugins ./locales; popd"'
//         sh 'sudo docker stop "$(cat /tmp/container_id_${BUILD_NUMBER})"'
//         sh 'sudo docker rm "$(cat /tmp/container_id_${BUILD_NUMBER})"'

//         stash includes: 'build/**, *.ospx, vanessa-behavior-devel.tar.gz, vanessa-behavior.tar.gz, vanessa-behavior.zip, env.json', excludes: 'build/cache.txt', name: 'buildResults'
//     }

//     stage("archive"){
//         archiveArtifacts 'vanessa-behavior*.ospx,vanessa-behavior.tar.gz,vanessa-behavior-devel.tar.gz,vanessa-behavior.zip'
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
parallel tasks

tasks = [:]
tasks["report"] = {
    node {
        stage("report"){
            cleanWs(patterns: [[pattern: 'build/ServiceBases/**', type: 'INCLUDE']]);
            unstash 'buildResults'
            builds.each{
                unstash "${it}"
            }
            unstash "video"
            unstash "xdd"
            try{
                allure commandline: 'allure2', includeProperties: false, jdk: '', results: [[path: 'build/ServiceBases/allurereport/']]
            } catch (e) {
                echo "allure status : ${e}"
                currentBuild.result = 'UNSTABLE'
            }
            junit 'build/ServiceBases/junitreport/*.xml'
            //cucumber fileIncludePattern: '**/*.json', jsonReportDirectory: 'build/ServiceBases/cucumber'
            
            //archiveArtifacts 'build/ServiceBases/allurereport/**'
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