CWD=$(pwd)
MINKB=$CWD/workspace/minikube

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

curl -v http://localhost:8080/jnlpJars/jenkins-cli.jar -o jenkins-cli.jar

java -jar jenkins-cli.jar -s http://localhost:8080 create-credentials-by-xml system::system::jenkins _ < credential.xml
java -jar jenkins-cli.jar -s http://localhost:8080 create-job pBuildRestDemo < pBuildRestDemo.xml
sleep 2
java -jar jenkins-cli.jar -s http://localhost:8080 build pBuildRestDemo -s

docker cp jenkins:/var/jenkins_home/workspace/pBuildRestDemo/build/jib-image.tar $CWD/workspace/jib-image.tar
docker stop jenkins

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

$MINKB image load restdemo:latest
$MINKB kubectl -- apply -f hello-minikube.yml
$MINKB kubectl -- apply -f hello-minikube-srv.yml
sleep 5
PODNAME=$($MINKB kubectl -- get pods --no-headers | awk '{ print $1 }')
echo $PODNAME
$MINKB kubectl -- exec $PODNAME -- curl -s localhost:8088/hello
echo ''
$MINKB stop

rm *.jar
#rm -R $PWD/workspace