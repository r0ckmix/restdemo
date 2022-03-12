node() {
    stage("SCM") {
        checkout scm
    }
    stage("Build"){
        sh "gradle build test"
    }
    stage("Http request"){
        ansiblePlaybook colorized: true,
                inventory: "${WORKSPACE}/hosts",
                playbook: "${WORKSPACE}/httpRequest.yml",
                extras: '-vvv'
    }
}