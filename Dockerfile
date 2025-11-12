FROM eclipse-temurin:21.0.8_9-jdk-jammy AS builder
WORKDIR /builder
ARG JAR_FILE=hwa/target/*.jar
COPY ${JAR_FILE} app.jar
RUN java -Djarmode=tools -jar app.jar extract --layers --destination extracted

FROM eclipse-temurin:21.0.8_9-jdk-jammy AS runner
WORKDIR /app
ARG BUILDER_PATH=/builder/extracted
COPY --from=builder ${BUILDER_PATH}/dependencies/ ./
COPY --from=builder ${BUILDER_PATH}/spring-boot-loader/ ./
COPY --from=builder ${BUILDER_PATH}/snapshot-dependencies/ ./
COPY --from=builder ${BUILDER_PATH}/application/ ./
ENTRYPOINT [ "java", "-jar", "app.jar" ]