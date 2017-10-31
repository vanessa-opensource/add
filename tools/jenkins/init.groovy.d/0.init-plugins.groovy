import jenkins.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import hudson.plugins.sshslaves.*;
import hudson.model.Node.Mode
import hudson.slaves.*
import jenkins.model.Jenkins

def deployPlugin(plugin) {
  if (! plugin.isEnabled() ) {
    plugin.enable()
  }
  plugin.getDependencies().each { 
    deployPlugin(pm.getPlugin(it.shortName)) 
  }
}

def needRestart = false;

pm = Jenkins.instance.pluginManager
pm.doCheckUpdatesServer()

[ 'cloudbees-folder',
    'matrix-auth',
    'groovy',
    'gradle',
    'greenballs',
    'github',
    'analysis-core',
    'analysis-collector',
    'cobertura',
    'project-stats-plugin','audit-trail',
    'view-job-filters',
    'disk-usage',
    'global-build-stats',
    'radiatorviewplugin',
    'violations',
    'build-pipeline-plugin',
    'monitoring',
    'dashboard-view',
    'iphoneview',
    'jenkinswalldisplay', 
    'git',
    'git-client',
    'git-parameter',
    'htmlpublisher',
    'ftppublisher',
    'bitbucket-build-status-notifier',
    'bitbucket-approve',
    'copy-to-slave',
    'icon-shim',
    'email-ext',
    'emailext-template',
    'notification',
    'stashNotifier',
    'allure-jenkins-plugin',
    'analysis-collector',
    'analysis-core',
    'bootstraped-multi-test-results-report',
    'build-environment',
    'checkstyle',
    'cobertura',
    'disk-usage',
    'performance',
    'perfpublisher',
    'sonar',
    'sonargraph-plugin',
    'test-stability',
    'xunit',
    'batch-task',
    'copyartifact',
    'docker-build-step',
    'envinject',
    'fail-the-build-plugin',
    'groovy',
    'http_request',
    'job-dsl',
    'fstrigger',
    'build-timeout',
    'copy-data-to-workspace-plugin',
    'mask-passwords',
    'matrixtieparent',
    'timestamper',
    'virtualbox',
    'vncrecorder',
    'vncviewer',
    'build-with-parameters',
    'nodelabelparameter',
    'job-import-plugin',
    'multi-branch-project-plugin',
    'multiple-scms',
    'credentials',
    'scm-api',
    'rebuild',
    'clone-workspace-scm',
    'chucknorris',
    'jobConfigHistory',
    'plugin-usage-plugin',
    'plain-credentials',
    'cloudbees-credentials',
    'config-file-provider',
    'token-macro',
    'docker-plugin',
    'docker-build-step',
    'docker-traceability',
    'docker-build-publish',
    'docker-workflow',
    'build-timestamp',
    'uptime',
    'configurationslicing',
    'simple-theme-plugin',
    'thinBackup',
    'build-pipeline-plugin',
    'durable-task',
    'workflow-step-api',
    'swarm',
    'parameterized-trigger',
    'nested-view',
    'git-server',
    'nodelabelparameter',
    'jquery',
    'cloudbees-folder',
    'join',
    'delivery-pipeline-plugin',
    'extra-columns',
    'buildgraph-view',
    'image-gallery',
    'livescreenshot',
    'dry',
    'dashboard-view',
    'any-buildstep',
    'conditional-buildstep',
    'run-condition',
    'flexible-publish',
    'docker-commons',
    'workflow-cps',
    'mercurial',
    'ssh-agent',
    'workflow-api',
    'workflow-support',
    'ace-editor',
    'workflow-scm-step',
    'jquery-detached',
    'authentication-tokens',
    'build-blocker-plugin',
    'workflow-job',
    'pipeline-rest-api',
    'handlebars',
    'momentjs',
    'pipeline-stage-view',
    'pipeline-build-step',
    'workflow-cps-global-lib',
    'branch-api',
    'workflow-multibranch',
    'workflow-durable-task-step',
    'pipeline-input-step',
    'pipeline-stage-step',
    'workflow-basic-steps',
    'workflow-aggregator',
    'pipeline-stage-step',
    'github-organization-folder',
    'github-branch-source', 
 	  'credentials-binding',
    'permissive-script-security',
    'cucumber-reports',
    'cucumber-trends-report',
    'cucumber-testresult-plugin',
    'blueocean', 
    'blueocean-pipeline-editor'
].each{ plugin ->
pm = Jenkins.instance.updateCenter.getPlugin(plugin);
println plugin;
println pm.getInstalled()
try {
    if (pm.getInstalled() == null) {
      println ">>>> install plugin "+plugin;
      try {
          deployment = Jenkins.instance.updateCenter.getPlugin(plugin).deploy(true)
          deployment.get()
          needRestart = true;   
      } catch (all) {
          println "Error:"+all;
      }
    }
  
} catch (e) {
  println "${e}"
}
}

pm = Jenkins.instance.pluginManager
pm.doCheckUpdatesServer()
//Jenkins.instance.updateCenter.doUpgrade(null);
plugins = pm.plugins
plugins = Jenkins.instance.updateCenter.getUpdates()

println "update plugins";
plugins.each {
  
  println it.name;
  Jenkins.instance.updateCenter.getPlugin(it.name).getNeededDependencies().each {
    println ">>>> update plugin "+it.name;
    it.deploy(true)
  }
  needRestart = true;
  it.deploy(true);
  
}

println ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
println ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

println "need reboot "+(Jenkins.instance.updateCenter.isRestartRequiredForCompletion() | needRestart)

if (Jenkins.instance.updateCenter.isRestartRequiredForCompletion() | needRestart) {
    hudson.model.Hudson.instance.doSafeRestart(null)
}
println ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

