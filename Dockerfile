FROM dokken/centos-stream-9
#FROM dokken/centos-stream-10
WORKDIR /tmp/build

RUN yum install epel-release -y && \
    yum update -y  && \
    yum install net-tools wget nano -y  && \
    yum install postgresql-devel -y && \
    yum install libcurl-devel -y && \
    yum install openssl-devel -y

RUN dnf update -y && \
    dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E %rhel).noarch.rpm -y && \
    dnf install epel-release -y && \
    dnf install flexiblas-* -y && \
    /usr/bin/crb enable

#RUN yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel -y
#RUN yum install java-17-openjdk java-17-openjdk-devel -y
RUN dnf install -y java-17-openjdk java-17-openjdk-devel

ENV RUN_USER=tomcat
ENV RUN_GROUP=tomcat

RUN echo "export CATALINA_HOME="/usr/local/tomcat9"" >> ~/.bashrc    
RUN source ~/.bashrc

#ARG TOMCAT_VERSION=9.0.111
ARG TOMCAT_VERSION=9.0.124

#RUN adduser --system --shell /bin/bash --gecos 'Tomcat Java Servlet and JSP engine' --group --disabled-password --home /home/tomcat tomcat
RUN groupadd -r tomcat 
RUN useradd -g tomcat tomcat

#RUN wget https://dlcdn.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
RUN wget https://dlcdn.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
RUN tar xzf apache-tomcat-${TOMCAT_VERSION}.tar.gz
RUN mv apache-tomcat-${TOMCAT_VERSION} /usr/local/tomcat9
RUN chown -R tomcat:tomcat /usr/local/tomcat9


#ARG R_VERSION=3.6.3
ARG R_VERSION=4.6.1

RUN curl -O https://cdn.rstudio.com/r/rhel-9/pkgs/R-${R_VERSION}-1-1.x86_64.rpm
RUN dnf install R-${R_VERSION}-1-1.x86_64.rpm -y
RUN ln -s /opt/R/${R_VERSION}/ /usr/lib64/R
    
ENV JRI_LD_PATH=/usr/lib64/R/lib:/usr/lib64/R/bin
#ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$JRI_LD_PATH
ENV LD_LIBRARY_PATH=$JRI_LD_PATH
ENV R_HOME=/usr/lib64/R
ENV R_INCLUDE_DIR=/usr/lib64/R/include
    
ENV PATH="$PATH:$LD_LIBRARY_PATH"

#RUN wget https://cran.r-project.org/src/contrib/quadprog_1.5-8.tar.gz
#RUN wget https://cran.r-project.org/src/contrib/quadprogXT_0.0.6.tar.gz
#RUN wget https://cran.r-project.org/src/contrib/RPostgreSQL_0.7-8.tar.gz
#RUN wget https://cran.r-project.org/src/contrib/jsonlite_2.0.0.tar.gz
#RUN wget https://cran.r-project.org/src/contrib/RCurl_1.98-1.17.tar.gz
#RUN wget https://cran.r-project.org/src/contrib/bitops_1.0-9.tar.gz
#RUN wget https://cran.r-project.org/src/contrib/DBI_1.2.3.tar.gz
#RUN wget https://cran.r-project.org/src/contrib/Rserve_1.8-16.tar.gz


#RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("./quadprog_1.5-8.tar.gz", repos = NULL, type="source")'  --no-save
#RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("./quadprogXT_0.0.6.tar.gz", repos = NULL, type="source")'  --no-save
#RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("./DBI_1.2.3.tar.gz", repos = NULL, type="source")'  --no-save
#RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("./RPostgreSQL_0.7-8.tar.gz", repos = NULL, type="source")'  --no-save
#RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("./bitops_1.0-9.tar.gz", repos = NULL, type="source")'  --no-save
#RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("./jsonlite_2.0.0.tar.gz", repos = NULL, type="source")'  --no-save
#RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("./RCurl_1.98-1.17.tar.gz", repos = NULL, type="source")'  --no-save
#RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("./Rserve_1.8-16.tar.gz", repos = NULL, type="source")'  --no-save

RUN /opt/R/${R_VERSION}/bin/R CMD javareconf 
RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("rJava", .libPaths()[1], "https://cloud.r-project.org/")' --no-save

RUN /opt/R/${R_VERSION}/bin/R -e  'install.packages("quadprogXT", .libPaths()[1], "https://cloud.r-project.org/")' --no-save
RUN /opt/R/${R_VERSION}/bin/R -e  'install.packages("DBI", .libPaths()[1], "https://cloud.r-project.org/")' --no-save
RUN /opt/R/${R_VERSION}/bin/R -e  'install.packages("PerformanceAnalytics", .libPaths()[1], "https://cloud.r-project.org/")' --no-save
RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("quadprog", .libPaths()[1], repos = "https://cloud.r-project.org/")' --no-save
RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("RPostgreSQL", .libPaths()[1], repos = "https://cloud.r-project.org/")' --no-save
RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("Rserve", .libPaths()[1], repos = "https://cloud.r-project.org/")' --no-save
RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("jsonlite", .libPaths()[1], repos = "https://cloud.r-project.org/")' --no-save
RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("bitops", .libPaths()[1], repos = "https://cloud.r-project.org/")' --no-save
RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("RCurl", .libPaths()[1], repos = "https://cloud.r-project.org/")' --no-save
RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("curl", .libPaths()[1], repos = "https://cloud.r-project.org/")' --no-save
RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("Rcpp", .libPaths()[1], repos = "https://cloud.r-project.org/")' --no-save
RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("plyr", .libPaths()[1], repos = "https://cloud.r-project.org/")' --no-save
RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("xml2", .libPaths()[1], repos = "https://cloud.r-project.org/")' --no-save
RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("rvest", .libPaths()[1], repos = "https://cloud.r-project.org/")' --no-save
RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("rdrop2", .libPaths()[1], repos = "https://cloud.r-project.org/")' --no-save
RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("rio", .libPaths()[1], repos = "https://cloud.r-project.org/")' --no-save


RUN yum install bind-utils -y

COPY Rserv.conf /etc/
COPY setenv.sh /usr/local/tomcat9/bin/
COPY tomcat-users.xml /usr/local/tomcat9/conf/
COPY server.xml /usr/local/tomcat9/conf/

RUN chmod 744 /etc/Rserv.conf

# Optional: copy project crontab; crond reads /etc/cron.d/ automatically
COPY crontab /etc/cron.d/alphabot-cronjobs
RUN chmod 0644 /etc/cron.d/alphabot-cronjobs

EXPOSE 8080

ADD start.sh /
RUN chmod +x /start.sh

RUN rm -rf /tmp/build

CMD ["/start.sh"]