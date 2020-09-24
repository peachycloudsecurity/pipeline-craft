FROM openjdk:8
#FROM openjdk:8-jre-alpine

##ENV JAVA_OPTS=-javaagent:/usr/skywalking/agent/skywalking-agent.jar

ADD kaniko/k8s-kaniko.jar /opt/app.jar

ADD kaniko/elastic-apm-agent-1.18.0.RC1.jar  /usr/share/elastic-apm-agent.jar

# ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom”,"-jar","/opt/app.jar"]
# CMD ["bash", "-c", "java ${JAVA_OPTS} -jar /opt/app.jar -Djava.security.egd=file:/dev/./urandom"]
CMD ["bash", "-c", "java  -javaagent:/usr/share/elastic-apm-agent.jar \ 
                       -Delastic.apm.service_name=hbstarjason \
                       -Delastic.apm.server_urls=https://e880d96bb366461aa64eec325cdf8c83.apm.ap-northeast-2.aws.elastic-cloud.com:443 \
                       -Delastic.apm.secret_token=9UMJkjRXKhEfc0GOU0 \
                       -Delastic.apm.application_packages=org.example \
                       -jar /opt/app.jar -Djava.security.egd=file:/dev/./urandom"]

