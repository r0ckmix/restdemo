node("master") {
    stage("SCM") {
        checkout scm
    }
    stage("Build"){
        sh "gradle build test"
    }
    stage("Http request"){
        ansiblePlaybook colorized: true,
                //disableHostKeyChecking: true,
                //installation: 'ansible29py38',
                inventory: "${WORKSPACE}/hosts",
                playbook: "${WORKSPACE}/httpRequest.yml"
    }
}