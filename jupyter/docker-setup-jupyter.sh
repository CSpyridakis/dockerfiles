#!/bin/bash

dotenv(){
    echo "PROJECT_NAME=$1
JUPYTER_SERVER_PORT=8888
JUPYTER_SECRET=$2 # This is associated with --NotebookApp.password, if you want to change it you need to regenerate sha1" > .env
}

docker_compose(){
    projectName=$1
    secret_sha=$2

    echo "# Steps:
#         1) mkdir -p ./jupyter/files/ ./jupyter/ssl-cert/
#         2) sudo chown -R 1000 ./jupyter/files/
#         3) openssl req -x509 -nodes -newkey rsa:2048 -keyout jupyter.pem -out jupyter.pem && mv jupyter.pem ./jupyter/ssl-cert/
#         4) Change/generate access token
#         5) Run docker-compose
#         6) Visit https://localhost:8888

version: '3'
services:
  ${projectName}-notebook:
      image: jupyter/datascience-notebook
      volumes:
        - ./jupyter/files/:/home/jovyan/work      
        - ./jupyter/ssl-cert/:/etc/ssl/notebook
      ports:
        - \${JUPYTER_SERVER_PORT}:8888
      container_name:   ${projectName}-notebook-container
      
      # Generate an access token like this (pip3 install IPython | if needed)
      #   import IPython as IPython
      #   hash = IPython.lib.passwd(\"S-E-C-R-E-T\")
      #   print(hash)
      command: \"start-notebook.sh \
        --NotebookApp.password=${secret_sha} \
        --NotebookApp.certfile=/etc/ssl/notebook/jupyter.pem\"
    " > docker-compose.yaml
}

generate_token(){
    passphrase=$1
    salt=$(openssl rand -hex 6)
    
    algorithm=sha1
    echo -n "$(echo ${passphrase} | iconv -t utf-8)${salt}" | sha1sum | awk -v alg="${algorithm}" -v salt="${salt}" '{print alg ":" salt ":" $1}'
}

main(){
    projectName=$1

    if [ ! -z ${projectName} ] ; then
        mkdir -p ${projectName}
        cd ${projectName}
        
        read -p 'Give secret for jupyter notebook: ' secret

        mkdir -p ./jupyter/files/ ./jupyter/ssl-cert/
        sudo chown -R 1000 ./jupyter/files/

        openssl req -x509 -nodes -newkey rsa:2048 -keyout jupyter.pem -out jupyter.pem && mv jupyter.pem ./jupyter/ssl-cert/

        secret_sha="`generate_token ${secret}`"
        dotenv ${projectName} ${secret}
        docker_compose ${projectName} ${secret_sha}
    else
        echo "Give first project name"
    fi
}

main $1
