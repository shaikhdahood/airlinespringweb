# Use the official image as a parent image.
#RUN echo "creating image from openjdk:8";
FROM openjdk:8

## Author
RUN echo "Maintainer : myapplicationsupport@company.com";
LABEL maintainer="myapplicationsupport@company.com"

## Collect image build time arguments or use default
ARG app_artifact=airlinespringweb-0.0.1-SNAPSHOT
ARG app_context_root=airlinespringweb
ARG app_health_uri=isAlive
ARG app_health_patern="successful"
ARG app_name=airlinespringweb
ARG app_dir=/work/webapps/

# Set the working directory.
WORKDIR /work/docker/webapps/
#ARG app_docker_dir=/work/docker/webapps/


# Environment Variables - declare with one ENV where possible
ENV LC_ALL en_US.UTF-8
ENV HEALTH_URI /${app_context_root}/${app_health_uri}
ENV HEALTH_PATTERN ${app_health_patern}

ENV JAVA_OPTS "-server -Xms256m -Xmx768m -XX:MetaspaceSize=72m -XX:MaxMetaspaceSize=256m -Dapp=${app_name} -Dapp.logdir=${app_dir}/tomcat/logs -Dspring.profiles.active=prod"

## create a folder for app image to prevent error in the startup
#RUN mkdir -p ${app_dir}/app-lib;

#RUN cd ${app_docker_dir};

## setup the exploded war directory for delivery
COPY target/${app_artifact} ${app_dir}/tomcat/${app_name}/

##chown [OPTIONS] USER[:GROUP] FILE(s)
# Ensure access to files by running user.
## switch user to root - this command works if the root is not set with any password
sudo su -
RUN chown -R webserveradmin ${app_dir}

# Inform Docker that the container is listening on the specified port at runtime.
EXPOSE 8080

ENTRYPOINT ["java","${JAVA_OPTS}","-jar","${app_dir}/tomcat/${app_name}/${app_artifact}.war"]
###
##$ docker build -t springboot/airlinespringweb-docker .
##$ docker container run -d -p 8080:8080 springboot/airlinespringweb-docker
