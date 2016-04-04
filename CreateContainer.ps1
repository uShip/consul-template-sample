$containerName = "default"

docker-machine create --driver virtualbox $containerName
docker-machine env --shell powershell $containerName | invoke-expression
$IP = docker-machine ip $containerName

docker run --name consul -d -p 8300-8302:8300-8302 -p 8400:8400 -p 8500:8500 -p 8600:53/udp -h node1 progrium/consul -server -bootstrap -advertise 192.168.99.100
docker run --name registrator -d --net=host --volume=/var/run/docker.sock:/tmp/docker.sock gliderlabs/registrator consul:http://192.168.99.100:8500
docker run -d --name nginx -p 8080:80 -t nginx
docker cp consul-template nginx:/usr/local/bin
docker exec nginx mkdir /templates
docker cp ping.ctmpl nginx:/templates/ping.ctmpl

$cmd = "docker exec -t nginx /usr/local/bin/consul-template -consul [$IP]:8500 -template 'templates/ping.ctmpl:/etc/nginx/conf.d/ping.conf:service nginx reload' -pid-file /var/run/consul-template.pid -log-level warn -dry"
Invoke-Expression $cmd