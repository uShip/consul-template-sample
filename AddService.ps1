docker-machine env --shell powershell default | invoke-expression
docker run -d --name service1 -p 8081:80 tutum/hello-world