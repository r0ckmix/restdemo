if [[ "$(docker images -q jenkins:jcasc 2> /dev/null)" == "" ]]; then
  docker build -t jenkins:jcasc .
fi

mkdir $PWD/workspace
chmod 777 $PWD/workspace

docker run -d --name jenkins --rm -p 8080:8080 -p 50000:50000 -v jenkins_home:$PWD/workspace jenkins:jcasc

until $(curl --output /dev/null --silent --head --fail http://localhost:8080); do
    printf '.'
    sleep 3
done

curl -v http://localhost:8080/jnlpJars/jenkins-cli.jar -o jenkins-cli.jar
java -jar jenkins-cli.jar -s http://localhost:8080 create-job pBuildRestDemo < pBuildRestDemo.xml
sleep 2
java -jar jenkins-cli.jar -s http://localhost:8080 build pBuildRestDemo -s

#docker stop jenkins

rm jenkins-cli.jar
rm -R $PWD/workspace