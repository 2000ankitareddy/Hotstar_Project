FROM tomcat:9.0-jdk17-temurin

WORKDIR /usr/local/tomcat

RUN rm -rf webapps/*

COPY target/*.war webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
