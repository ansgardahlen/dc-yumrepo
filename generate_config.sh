#!/bin/bash

if [[ -f yumrepo.conf ]]; then
  read -r -p "config file yumrepo.conf exists and will be overwritten, are you sure you want to contine? [y/N] " response
  case $response in
    [yY][eE][sS]|[yY])
      mv yumrepo.conf yumrepo.conf_backup
      ;;
    *)
      exit 1
    ;;
  esac
fi

if [ -z "$PUBLIC_FQDN" ]; then
  read -p "Hostname (FQDN): " -ei "yumrepo.example.org" PUBLIC_FQDN
fi

if [ -z "$ADMIN_MAIL" ]; then
  read -p "YumRepo admin Mail address: " -ei "mail@example.com" ADMIN_MAIL
fi

[[ -f /etc/timezone ]] && TZ=$(cat /etc/timezone)
if [ -z "$TZ" ]; then
  read -p "Timezone: " -ei "Europe/Berlin" TZ
fi

if [ -z "$GITTOKEN" ]; then
  read -p "YumRepo Git Token: " -ei "XXX" GITTOKEN
fi

cat << EOF > yumrepo.conf
# ------------------------------
# yumrepo web ui configuration
# ------------------------------
# example.org is _not_ a valid hostname, use a fqdn here.
PUBLIC_FQDN=${PUBLIC_FQDN}
ADMIN_MAIL=${ADMIN_MAIL}

# ------------------------------
# Bindings
# ------------------------------

# You should use HTTPS, but in case of SSL offloaded reverse proxies:
HTTP_PORT=8080
HTTP_BIND=0.0.0.0

# Your timezone
TZ=${TZ}

# Fixed project name
#COMPOSE_PROJECT_NAME=yumrepo

GITTOKEN=${GITTOKEN}

EOF


#mkdir -p ./data/yumrepo/nginx-config
#
#if [[ -f ./data/yumrepo/nginx-config/nginx.conf ]]; then
#  read -r -p "config file nginx.conf exists and will be overwritten, are you sure you want to contine? [y/N] " response
#  case $response in
#    [yY][eE][sS]|[yY])
#      mv ./data/yumrepo/nginx-config/nginx.conf ./data/yumrepo/nginx-config/nginx.conf_backup
#      ;;
#    *)
#      exit 1
#    ;;
#  esac
#fi
#
#cat << EOF > ./data/yumrepo/nginx-config/nginx.conf
#user nginx;
#worker_processes auto;
#pid /run/nginx.pid;
#
#events {
#    worker_connections 1024;
#}
#
#http {
#
#	server {
#
#		listen 80 default_server;
#
#    	location /{
#			autoindex on;
#			alias /repo/;
#    	}
#
#		access_log /logs/nginx/access.log;
#		error_log /logs/nginx/error.log;
#
#	}
#
#}
#EOF
#
#
#mkdir -p ./data/yumrepo/supervisord
#
#if [[ -f ./data/yumrepo/supervisord/supervisord.conf ]]; then
#  read -r -p "config file supervisord.conf exists and will be overwritten, are you sure you want to contine? [y/N] " response
#  case $response in
#    [yY][eE][sS]|[yY])
#      mv ./data/yumrepo/supervisord/supervisord.conf ./data/yumrepo/supervisord/supervisord.conf_backup
#      ;;
#    *)
#      exit 1
#    ;;
#  esac
#fi
#
#cat << EOF > ./data/yumrepo/supervisord/supervisord.conf
#[supervisord]
#pidfile = /run/supervisord.pid
## It seems that it's not possible to swith this log to NONE (it creates NONE logfile)
#logfile = /logs/supervisord/supervisord.log
## Set loglevel=debug, only then all logs from child services are printed out
## to container logs (and thus available via 'docker logs [container]'
#loglevel = info
#
## These two (unix_http_server, rpcinterface) are needed for supervisorctl to work
#[inet_http_server]
#port = :9111
#username = sv
#password = password
#
#[rpcinterface:supervisor]
#supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface
#
#[supervisorctl]
#serverurl = http://localhost:9111
#username = sv
#password = password
#
#[include]
#files = /etc/supervisor.d/*.conf
#
#[program:repoScanner]
#priority=15
#directory=/
#command=/root/repoScanner
#user=root
#autostart=true
#autorestart=true
#stopsignal=QUIT
#redirect_stderr=true
#EOF

