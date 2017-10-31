#!groovy

properties([buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '3', daysToKeepStr: '', numToKeepStr: '3'))])
def tasks = [:]
def buildSerivceConf = ["836UF":"8.3.6", "837UF":"8.3.7", "838UF":"8.3.8", "839UF":"8.3.9", "8310UF":"8.3.10"];
//builds = ["82OF", "82UF", "836OF", "836UF", "837UF", "838UF", "839UF", "8310UF"]
//builds = ["836UF", "837UF", "838UF", "839UF", "8310UF"]
builds = ["8310UF"]

if (env.filterBuilds && env.filterBuilds.length() > 0 ) {
    println "filter build";
    builds = builds.findAll{it.contains(env.filterBuilds) || env.filterBuilds.contains(it)};
}
builds.each{

    tasks["behavior ${it}"] = {
        node ("slave") {
            stage("behavior ${it}") {
                //cleanWs();
                //git url: 'https://github.com/silverbulleters/vanessa-behavior2.git'
                checkout scm
                unstash "buildResults"
                bat "chcp 65001\noscript ./tools/onescript/CloseAll1CProcess.os"
                bat "chcp 65001\noscript ./tools/onescript/build-service-conf.os "+buildSerivceConf[it];
                try{
                    bat "chcp 65001\noscript ./tools/onescript/run-behavior-check-session.os ./tools/JSON/Main.json ./tools/JSON/VBParams${it}.json"
                } catch (e) {
                    echo "behavior ${it} status : ${e}"
                }
                stash allowEmpty: true, includes: "build/ServiceBases/allurereport/${it}/**, build/ServiceBases/cucumber/**, build/ServiceBases/junitreport/**", name: "${it}"
            }
        }
    }
}
firsttasks=[:]
//firsttasks["qa"] = {
    node("slave"){
        stage ("sonar QA"){
            unix = isUnix();
            checkout scm
            if (env.QASONAR) {
                //try{
                    println env.QASONAR;
                    def sonarcommand = "@\"./../../tools/hudson.plugins.sonar.SonarRunnerInstallation/Main_Classic/bin/sonar-scanner\""
                    withCredentials([[$class: 'StringBinding', credentialsId: env.SonarOAuthCredentianalID, variable: 'SonarOAuth']]) {
                        sonarcommand = sonarcommand + " -Dsonar.host.url=http://sonar.silverbulleters.org -Dsonar.login=${env.SonarOAuth}"
                    }
                    
                    // Get version
                    def configurationText = readFile encoding: 'UTF-8', file: 'epf/vanessa-behavior/VanessaBehavior/Ext/ObjectModule.bsl'
                    def configurationVersion = (configurationText =~ /Версия = "(.*)";/)[0][1]
                    sonarcommand = sonarcommand + " -Dsonar.projectVersion=${configurationVersion}"

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
                        makeAnalyzis = false
                    }
                    sonarcommand = sonarcommand + " -Dsonar.scm.disabled=true"
                    if (makeAnalyzis) {
                        if (unix) {
                            cmd(sonarcommand, unix)
                        } else {
                            echo "${sonarcommand}"
                            bat "${sonarcommand}"
                            //cmd(sonarcommand, unix)
                        }
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
//}

firsttasks["linuxbuild"] = {
node("slavelinux"){
    stage ("checkout scm") {
        //cleanWs();
        unix = isUnix();
            if (!unix) {
                command = "git config --local core.longpaths true"
                cmd(command, unix);
            }
            //git url: 'https://github.com/silverbulleters/vanessa-behavior2.git'
            checkout scm
    
    }
    stage("build"){
        def unix = isUnix()
        //sh 'ls -al ./build'
        cmd("sudo docker pull wernight/ngrok", unix)
        command = 'sudo docker run --detach -e XVFB_RESOLUTION=1920x1080x24 --volume="${PWD}":/home/ubuntu/code onec32/client:8.3.10.2466 client > /tmp/container_id_${BUILD_NUMBER}';
        echo command;
        cmd(command, unix);
        sh 'sleep 10'
        sh 'sudo docker exec -u ubuntu "$(cat /tmp/container_id_${BUILD_NUMBER})" /bin/bash -c "cd /home/ubuntu/code; DISPLAY=:1.0 sudo opm install && sudo opm update -all"'
        sh 'sudo docker exec -u ubuntu "$(cat /tmp/container_id_${BUILD_NUMBER})" /bin/bash -c "cd /home/ubuntu/code; DISPLAY=:1.0 opm run init && opm run clean"'
        sh 'sudo rm -f vanessa-behavior*.ospx'
        sh 'sudo docker exec -u ubuntu "$(cat /tmp/container_id_${BUILD_NUMBER})" /bin/bash -c "cd /home/ubuntu/code; DISPLAY=:1.0 opm build ./"'
        sh 'sudo rm -rf vanessa-behavior.tar.gz && sudo rm -f vanessa-behavior-devel.tar.gz && sudo rm -f vanessa-behavior.zip'
        sh 'cd ./build; tar -czf ../vanessa-behavior.tar.gz ./vanessa-behavior.epf ./lib/ ./features/libraries ./vendor ./plugins ./locales; cd ..'
        sh 'pwd && tar -czf ./vanessa-behavior-devel.tar.gz ./build env.json;'
        sh 'sudo docker exec -u ubuntu "$(cat /tmp/container_id_${BUILD_NUMBER})" /bin/bash -c "cd /home/ubuntu/code; DISPLAY=:1.0 pushd ./build; zip -r ../vanessa-behavior.zip ./vanessa-behavior.epf ./lib/ ./features/libraries ./vendor ./plugins ./locales; popd"'
        sh 'tar -czf ./vanessa-behavior-devel.tar.gz ./build env.json;'
        sh 'sudo docker exec -u ubuntu "$(cat /tmp/container_id_${BUILD_NUMBER})" /bin/bash -c "cd /home/ubuntu/code; DISPLAY=:1.0 pushd ./build; zip -r ../vanessa-behavior.zip ./vanessa-behavior.epf ./lib/ ./features/libraries ./vendor ./plugins ./locales; popd"'
        sh 'sudo docker stop "$(cat /tmp/container_id_${BUILD_NUMBER})"'
        sh 'sudo docker rm "$(cat /tmp/container_id_${BUILD_NUMBER})"'

        stash includes: 'build/**, *.ospx, vanessa-behavior-devel.tar.gz, vanessa-behavior.tar.gz, vanessa-behavior.zip, env.json', excludes: 'build/cache.txt', name: 'buildResults'
    }

    stage("archive"){
        archiveArtifacts 'vanessa-behavior*.ospx,vanessa-behavior.tar.gz,vanessa-behavior-devel.tar.gz,vanessa-behavior.zip'
    }
}
}
tasks["opmrunclean"] = {
    node("slave"){
        //git url: 'https://github.com/silverbulleters/vanessa-behavior2.git'
        checkout scm
        bat "opm run clean"
    }
}
parallel firsttasks

parallel tasks

tasks = [:]
tasks["report"] = {
    node {
        stage("report"){
            cleanWs();
            unstash 'buildResults'
            builds.each{
                unstash "${it}"
            }
            try{
                allure commandline: 'allure2', includeProperties: false, jdk: '', results: [[path: 'build/ServiceBases/allurereport/']]
            } catch (e) {
                echo "behavior status : ${e}"
            }
            
            junit 'build/ServiceBases/junitreport/*.xml'
            //cucumber fileIncludePattern: '**/*.json', jsonReportDirectory: 'build/ServiceBases/cucumber'
        }
    }
}

//tasks["sonar"] = {
//}

parallel tasks

def cmd(command, isunix) {
    // TODO при запуске Jenkins не в режиме UTF-8 нужно написать chcp 1251 вместо chcp 65001
    if (isunix) { sh "${command}" } else {bat "chcp 65001\n${command}"}
}