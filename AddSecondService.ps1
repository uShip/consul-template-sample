docker-machine env --shell powershell default | invoke-expression
docker run -d --name service2 -p 8082:80 tutum/hello-world