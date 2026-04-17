FROM openjdk:17
COPY target/devops-cicd-project-1.0-SNAPSHOT.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
