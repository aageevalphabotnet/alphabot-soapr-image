#!/bin/bash

#systemctl daemon-reload
#systemctl start rserve
#systemctl enable rserve

ln -s /opt/alphabot/apps/alphabot-ws-v1.war /usr/local/tomcat9/webapps/alphabot-ws-v1.war
#sudo rm -rf /usr/local/tomcat9/webapps/alphabot-ws-v1*
#cp /opt/alphabot/apps/alphabot-ws-v1.war /usr/local/tomcat9/webapps
#sudo chown -R tomcat:tomcat /usr/local/tomcat9/webapps/alphabot-ws-v1*

/usr/lib64/R/bin/R CMD Rserve --quiet --vanilla --RS-pidfile /tmp/rserve.pid --RS-conf /etc/Rserv.conf
sudo chown -R tomcat:tomcat /usr/local/tomcat9/webapps/alphabot-ws-v1*

# Starting cron tab service to execute background jobs
crond

/usr/local/tomcat9/bin/catalina.sh run
