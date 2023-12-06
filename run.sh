CWD=$(pwd)
MINKB=$CWD/workspace/minikube
HELM_PATH="/Applications/HELM/"

if [[ "$(docker images -q jenkins:jcasc 2> /dev/null)" == "" ]]; then
  docker build -t jenkins:jcasc .
fi

mkdir $CWD/workspace
chmod 777 $CWD/workspace

docker run -d --name jenkins --rm -p 8080:8080 -p 50000:50000 -v jenkins_home:$CWD/workspace jenkins:jcasc

until $(curl --output /dev/null --silent --head --fail http://localhost:8080); do
    printf '.'
    sleep 3
done

curl -v 'http://localhost:8080/jnlpJars/jenkins-cli.jar' -o jenkins-cli.jar
#add java installation
java -jar jenkins-cli.jar -s http://localhost:8080 create-credentials-by-xml system::system::jenkins _ < credential.xml
java -jar jenkins-cli.jar -s http://localhost:8080 create-job pBuildRestDemo < pBuildRestDemo.xml
sleep 2
java -jar jenkins-cli.jar -s http://localhost:8080 build pBuildRestDemo -s

docker cp jenkins:/var/jenkins_home/workspace/pBuildRestDemo/build/jib-image.tar $CWD/workspace/jib-image.tar
docker stop jenkins

docker images -a | grep "restdemo" | awk '{print $3}' | xargs docker rmi -f
docker load --input $CWD/workspace/jib-image.tar

if [ ! -f "$MINKB" ]; then
    if [[ "$(uname -s)" == "Darwin" ]]; then
      curl -Lo $MINKB https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64 && chmod +x $MINKB
    else
      curl -Lo $MINKB https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x $MINKB
    fi
fi

#$MINKB start --vm-driver=docker

MINKBSTATUS=$($MINKB status | grep host | awk '{ print $2 }')
echo $MINKBSTATUS
if [[ ! $MINKBSTATUS == "Running" ]]; then
  $MINKB start
fi

#$MINKB image rm restdemo:latest
$MINKB image load restdemo:latest

#add helm installation

#$HELM_PATH/helm ls --all --short | xargs -L1 $HELM_PATH/helm delete
#$HELM_PATH/helm install ./demoapp --generate-name

helm ls --all --short | xargs -L1 $HELM_PATH/helm delete
helm install ./demoapp --generate-name

#$MINKB kubectl -- apply -f hello-minikube.yml
#$MINKB kubectl -- apply -f hello-minikube-srv.yml

sleep 5
PODNAME=$($MINKB kubectl -- get pods --no-headers | awk '{ print $1 }')
echo $PODNAME
$MINKB kubectl -- exec $PODNAME -- curl -s localhost:8088/hello
echo ''
$MINKB delete

rm *.jar
#rm -R $PWD/workspace