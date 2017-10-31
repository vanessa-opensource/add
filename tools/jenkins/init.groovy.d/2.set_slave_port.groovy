import jenkins.model.*;
import hudson.model.*;

Thread.start{
    sleep 10000
    println "--> settings agent port for jnlp"
    def env = System.getenv()
    int port = env['JENKINS_SLAVE_AGENT_PORT'].toInteger();
    if (port > 0){
        Jenkins.instance.setSlaveAgentPort(port);
        println "--> setting agent port ${port}";
    }
}