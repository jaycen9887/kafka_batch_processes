@ ECHO OFF
SET klocation="CHANGE THIS TO THE FULL PATH OF YOUR KAFKA INSTANCE"
SET brokerList="CHANGE THIS TO THE LIST OF KAFKA BROKERS" REM EXAMPLE: "localhost:9092,localhost:9093,localhost:9094"

REM ***********************  DO NOT CHANGE ANYTHING BELOW THIS LINE  ***********************

SET /p topic="Topic: "
SET /p groupId="Group ID: "
cd %klocation%\bin\windows
call kafka-console-consumer.bat --bootstrap-server %brokerList% --topic %topic% --consumer-property group.id=%groupId%  --from-beginning
pause