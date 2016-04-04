$containerName = "default"

docker-machine env --shell powershell $containerName | invoke-expression
$IP = docker-machine ip $containerName

$cmd = "docker exec -t nginx /usr/local/bin/consul-template -consul [$IP]:8500 -template 'templates/ping.ctmpl:/etc/nginx/conf.d/ping.conf:service nginx reload' -pid-file /var/run/consul-template.pid -log-level warn"
Invoke-Expression $cmd