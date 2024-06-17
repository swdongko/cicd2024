pipeline {
   agent any
   environment {
      CONTAINER_NAME = 'swdcontainer2024'
      CONTAINER_TAG = 'latest'
      PRISMA_API_URL= 'https://api.prismacloud.io'
   }
    stages { 
        stage('Build Container') {
            steps {
                  sh ''' 
                  docker build -t $CONTAINER_NAME:$CONTAINER_TAG .
                  docker image  prune -f
                  '''
            }
        }
         stage('Image Scan') {
          steps {
                withCredentials([
                   string(credentialsId: 'PCE_CONSOLE_URL', variable: 'PCE_CONSOLE_URL'),
                   string(credentialsId: 'PRISMA_ACCESS_KEY', variable: 'PRISMA_ACCESS_KEY'),
                  string(credentialsId: 'PRISMA_SECRET_KEY', variable: 'PRISMA_SECRET_KEY')
                   ]) {
                   sh '''
                   #This  command will generate an authorization token (Only valid for 1 hour)
                   json_auth_data="$(printf '{ "username": "%s", "password": "%s" }' "${PRISMA_ACCESS_KEY}" "${PRISMA_SECRET_KEY}")"

                   token=$(curl -sSLk -d "$json_auth_data" -H 'content-type: application/json' "$PCE_CONSOLE_URL_JP/api/v1/authenticate" | python3 -c 'import sys, json; print(json.load(sys.stdin)["token"])')

                   sudo /home/ubuntu/twistcli images scan --address https://us-east1.cloud.twistlock.com/us-1-111573457 --token=$token --details $CONTAINER_NAME:$CONTAINER_TAG
                   '''
                }
             }
         }

       stage('Secret and IaC Scan') {
          steps {
                withCredentials([
                   string(credentialsId: 'PRISMA_ACCESS_KEY', variable: '886b5a82-4d83-4771-8bad-d7cc1a93a4dd'),
                   string(credentialsId: 'PRISMA_SECRET_KEY', variable: 'WkHBT7PfJdoNlg6ZU6+kvGj6y6I=')
                   ]) {
                      script{
                        docker.image('bridgecrew/checkov:latest').inside("--entrypoint=''") {
                          try {
                              sh 'checkov -d . --use-enforcement-rules -o cli -o junitxml --output-file-path console,results.xml --bc-api-key $PRISMA_ACCESS_KEY::$PRISMA_SECRET_KEY --repo-id swdongko/cicd2024'
                              junit skipPublishingChecks: true, testResults: 'results.xml'
                          } catch (err) {
                              junit skipPublishingChecks: true, testResults: 'results.xml'
                              throw err
                          }
                        }
                   }
                }
             }
         }
    }
}
