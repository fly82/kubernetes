# syntax=docker/dockerfile:1

ARG BASE_VER=debug-nonroot
FROM gcr.io/distroless/java11:${BASE_VER}
COPY ./*.jar /app.jar
ENTRYPOINT ["java", "-XshowSettings:vm", "-XX:NativeMemoryTracking=summary", "-jar", "/app.jar"]
