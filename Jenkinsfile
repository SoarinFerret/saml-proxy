pipeline {
    agent none
    options {
        skipStagesAfterUnstable()
        ansiColor('xterm')
    }
    environment {
        LIBON_COMPONENT = 'saml-proxy'
    }
    stages {
        stage('Build/push docker image') {
            agent {
                kubernetes {
                    label "${LIBON_COMPONENT}-build"
                    yamlFile 'build/build-tools/jenkins/build-stage.yaml'
                }
            }
            options {
                skipDefaultCheckout()
            }
            steps {
                container(name: "kaniko", shell: '/busybox/sh') {
                    withEnv(['PATH+EXTRA=/busybox:/kaniko']) {
                        sh """#!/busybox/sh
                        /kaniko/executor --context `pwd`/ \
                            --dockerfile=`pwd`/Dockerfile \
                            --destination=eu.gcr.io/libon-build/${LIBON_COMPONENT}
                        """
                    }
                }
            }
        }
    }
}
