@echo off
set klocation="CHANGE THIS TO THE FULL PATH OF YOUR KAFKA INSTANCE"

start cmd /k "cd %klocation% && .\bin\windows\zookeeper-server-start.bat .\config\zookeeper.properties"
pause
start cmd /k "cd %klocation% && .\bin\windows\kafka-server-start.bat .\config\server.properties"
start cmd /k "cd %klocation% && .\bin\windows\kafka-server-start.bat .\config\server2.properties"
start cmd /k "cd %klocation% && .\bin\windows\kafka-server-start.bat .\config\server3.properties"
