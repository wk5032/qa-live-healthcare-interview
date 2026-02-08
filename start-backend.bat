@echo off
set JAVA_HOME=D:\Program Files\Java\jdk-22
set PATH=D:\Program Files\Java\jdk-22\bin;%PATH%
cd /d "%~dp0server\qa-service-user"
mvnw.cmd spring-boot:run
