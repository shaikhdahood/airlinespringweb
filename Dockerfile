# Use the official image as a parent image.
#RUN echo "creating image from openjdk:8";
FROM openjdk:8

## Author
RUN echo "Maintainer : myapplicationsupport@company.com";
LABEL maintainer="myapplicationsupport@company.com"

## Collect image build time arguments or use default
ARG app_artifact=airlinespringweb-0.0.1-SNAPSHOT
ENV app_context_root=airlineweb
ARG app_health_uri=isAlive
ARG app_health_patern="successful"
ENV app_name=airlinespringweb
ENV app_dir=/work/webapps

# Set the working directory. Jenkins sends file to this folder
#ARG jenkins_target_dir=/work/docker/webapps/
WORKDIR ${app_dir}


# Environment Variables - declare with one ENV where possible
ENV LC_ALL en_US
ENV HEALTH_URI /${app_context_root}/${app_health_uri}
ENV HEALTH_PATTERN ${app_health_patern}

# java settings
ENV JAVA_OPTS "-Xms256m -Xmx768m -XX:MetaspaceSize=72m -XX:MaxMetaspaceSize=256m -Dapp=${app_name} -Dapp.logdir=$app_dir/tomcat/logs -Dspring.profiles.active=prod"

## create a folder for app image to prevent error in the startup
#RUN mkdir -p ${app_dir}/app-lib;

#RUN cd ${app_docker_dir};

RUN mkdir -p ${app_dir}/tomcat/${app_context_root};

## setup the exploded war directory from webserver host folder to the docker container
COPY ./target/${app_artifact}.war ${app_dir}/tomcat/${app_context_root}/${app_name}.war
#COPY target/${app_artifact}.war /work/webapps/tomcat/airlineweb/airlinespringweb.war

##chown [OPTIONS] USER[:GROUP] FILE(s)
# Ensure access to files by running user.
## switch user to root - this command works if the root is not set with any password
#sudo su -
#RUN chown -R webserveradmin ${app_dir}

# Inform Docker that the container is listening on the specified port at runtime.
EXPOSE 8080

#ENTRYPOINT ["java","${JAVA_APP_OPTS}","-jar","${app_dir}/tomcat/${app_name}/${app_artifact}.war"]
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -jar ${app_dir}/tomcat/${app_context_root}/${app_name}.war" ]

###VOLUME
## declare volume for the logs -TODO


##$ docker build -t springboot/airlinespringweb-docker .
##$ docker container run -d -p 8080:8080 springboot/airlinespringweb-docker
