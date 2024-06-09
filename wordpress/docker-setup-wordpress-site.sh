#!/bin/bash

# ----------------------------------------------------------

docker_compose(){
    projectName=$1
    echo "version: '3.1'

services:
  #MySql
  ${projectName}-db:    #TODO: if you ever change project's name you have to modify it
    image: mysql:5.7
    container_name: \${PROJECT_NAME}-db 
    # restart: always
    environment:
      MYSQL_DATABASE: \${WP_DB_NAME}
      MYSQL_USER: \${WP_DB_USERNAME}
      MYSQL_PASSWORD: \${WP_DB_PASSWORD}
      MYSQL_RANDOM_ROOT_PASSWORD: '1'
    volumes:
      - ./mysql/data:/var/lib/mysql
    ports:
      - \${WP_DB_PORT}:3306
    networks:
      - \${PROJECT_NAME}-network

  #Phpmyadmin     
  ${projectName}-phpmyadmin:    #TODO: if you ever change project's name you have to modify it
    image: phpmyadmin/phpmyadmin:4.8
    container_name: \${PROJECT_NAME}-phpmyadmin 
    depends_on: 
      - \${PROJECT_NAME}-db 
    # restart: always
    links:
       - \${PROJECT_NAME}-db:db
    ports:
      - \${WP_PHPMYADMIN_PORT}:80  

  #Wordpress
  ${projectName}-wordpress: #TODO: if you ever change project's name you have to modify it
    image: wordpress
    container_name: \${PROJECT_NAME}-server 
    depends_on: 
      - \${PROJECT_NAME}-db 
    # restart: always
    environment:
      WORDPRESS_DB_HOST: \${PROJECT_NAME}-db:\${WP_DB_PORT}
      WORDPRESS_DB_USER: \${WP_DB_USERNAME}
      WORDPRESS_DB_PASSWORD: \${WP_DB_PASSWORD}
      WORDPRESS_DB_NAME: \${WP_DB_NAME}
    volumes:
      # Actual wordpress files
      - ./wordpressdata:/var/www/html  

       # For Simply static exported data 
       # (Settings > Delivery Method: Local Directory = \"/data/website\")
      # - './data/website:/data/website' 
    ports:
      - \${WP_SERVER_PORT}:80
    networks:
      - \${PROJECT_NAME}-network

networks:
  ${projectName}-network:   #TODO: if you ever change project's name you have to modify it
"   > docker-compose.yml

}

# ----------------------------------------------------------

dotenv(){
    projectName=$1
    echo "# CHANGE THEM (Change hard-coded network name on docker-compose)
PROJECT_NAME=${projectName} #TODO: if you ever need to change project's name you have to modify it

# Containers ports | Use WP_SERVER_PORT=80 if you want to use simply static plugin
WP_DB_PORT=3306
WP_SERVER_PORT=80   
WP_PHPMYADMIN_PORT=8088

# DB credentials
WP_DB_NAME=wordpress_db
WP_DB_USERNAME=typicalUsername
WP_DB_PASSWORD=typicalPass"   > .env

}

# ----------------------------------------------------------

gitignore(){
    echo ".vscode/
.vscode/*
bin/
bin/*"   > .gitignore
}

# ----------------------------------------------------------

fix_word_press_files_permitions(){

    echo "#!/bin/bash
#
# This script configures WordPress file permissions based on recommendations
# from http://codex.wordpress.org/Hardening_WordPress#File_permissions
#
# Author: Michael Conigliaro <mike [at] conigliaro [dot] org>
#
cd wordpressdata    # This is my extra 
echo "File directory: $1"

WP_OWNER=www-data # <-- wordpress owner
WP_GROUP=www-data # <-- wordpress group
WP_ROOT=$1 # <-- wordpress root directory
WS_GROUP=www-data # <-- webserver group

# reset to safe defaults
find ${WP_ROOT} -exec chown ${WP_OWNER}:${WP_GROUP} {} \;
find ${WP_ROOT} -type d -exec chmod 755 {} \;
find ${WP_ROOT} -type f -exec chmod 644 {} \;

# allow wordpress to manage wp-config.php (but prevent world access)
chgrp ${WS_GROUP} ${WP_ROOT}/wp-config.php
chmod 660 ${WP_ROOT}/wp-config.php

# allow wordpress to manage wp-content
find ${WP_ROOT}/wp-content -exec chgrp ${WS_GROUP} {} \;
find ${WP_ROOT}/wp-content -type d -exec chmod 775 {} \;
find ${WP_ROOT}/wp-content -type f -exec chmod 664 {} \;#!/bin/bash
#
# This script configures WordPress file permissions based on recommendations
# from http://codex.wordpress.org/Hardening_WordPress#File_permissions
#
# Author: Michael Conigliaro <mike [at] conigliaro [dot] org>
#
WP_OWNER=www-data # <-- wordpress owner
WP_GROUP=www-data # <-- wordpress group
WP_ROOT=$1 # <-- wordpress root directory
WS_GROUP=www-data # <-- webserver group

# reset to safe defaults
find ${WP_ROOT} -exec chown ${WP_OWNER}:${WP_GROUP} {} \;
find ${WP_ROOT} -type d -exec chmod 755 {} \;
find ${WP_ROOT} -type f -exec chmod 644 {} \;

# allow wordpress to manage wp-config.php (but prevent world access)
chgrp ${WS_GROUP} ${WP_ROOT}/wp-config.php
chmod 660 ${WP_ROOT}/wp-config.php

# allow wordpress to manage wp-content
find ${WP_ROOT}/wp-content -exec chgrp ${WS_GROUP} {} \;
find ${WP_ROOT}/wp-content -type d -exec chmod 775 {} \;
find ${WP_ROOT}/wp-content -type f -exec chmod 664 {} \; "   > fix-wordpress-files-permissions.sh

    chmod +x fix-wordpress-files-permissions.sh
}

# ----------------------------------------------------------

export_site() {

    echo "#!/bin/bash
mkdir -p bin/
cd ./bin/
rm -rf ./bu/ ./static/
mkdir -p ./bu ./static

# Clone site
httrack \"http://localhost\" -O \"./bu/\" \"+*localhost/*\" -v 

# Create and move to static
cp ./bu/localhost/index.html ./static
cp ./bu/localhost/wp-includes ./static -R
cp ./bu/localhost/wp-content ./static -R

# Copy Images
cp ../images ./static/images -R

# Do needed changes to index
sed -i \"s/http:\/\/localhost\/wp-content\/uploads\/2020\/12\//images\//g\" ./static/index.html"   > export-site.sh

    # 
    chmod +x export-site.sh
}

# ----------------------------------------------------------

main(){
    projectName=$1
    if [ ! -z ${projectName} ] ; then 
        mkdir -p ${projectName}
        cd ${projectName}
        
        mkdir -p images && touch images/empty
        fix_word_press_files_permitions
        export_site
        gitignore
        docker_compose ${projectName}
        dotenv ${projectName}
    else
        echo "Give project's name"
    fi
}

# ----------------------------------------------------------

main $1
