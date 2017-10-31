import jenkins.*
import jenkins.model.*
import hudson.* 
import hudson.model.*

System.setProperty(hudson.model.DirectoryBrowserSupport.class.getName() + ".CSP", "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';")
jenkins.branch.WorkspaceLocatorImpl.PATH_MAX = 8;