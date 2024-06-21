#  WP-Research
## Introduciton
this is my wordpress in docker container for automatic setup. this born because i was tired to manualy install and setup wordpress in docker container. maybe i should use wordpress image tapi menuturku itu tidak bagus

## installation 

### Host 
**configure reverse proxy nginx to container ip** 
```bash
# installing nginx
sudo apt install nginx
```

**create and configure container**
```bash
#host
docker run -ti ubuntu --name wordpress -p lport:rport -v /var/www/html/:/var/www/html/wordpress ubuntu /bin/bash

#contianer
apt update
apt install git
git clone https://github.com/justakazh/wp-research
cd wp-research
bash build.sh
```

**configure nginx (host)**
```bash
#getting contianer ip
docker inspect   --format '{{ .NetworkSettings.IPAddress }}' wordpress

#create wordpress.conf
nano /etc/nginx/sites-available/wordpress.conf

#paste this config into wordpress.conf
server {
    listen 80;
    listen [::]:80;

    server_name research.local;

    location / {
        proxy_pass http://CHANGE_THIS_TO_CONTGAINER_IP; 
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

#enable site
ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/wordpress
nginx -t
service nginx restart
```
