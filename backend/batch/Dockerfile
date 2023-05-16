FROM openjdk:11-jdk
LABEL maintainer="mnb3559@gmail.com"
ARG JAR_FILE=build/libs/reslow-batch-0.0.1-SNAPSHOT.jar
ADD ${JAR_FILE} docker-springboot.jar
ENTRYPOINT ["java","-Duser.timezone=Asia/Seoul","-Djava.security.egd=file:/dev/./urandom","-jar","/docker-springboot.jar"]