@ ECHO OFF
SET klocation="CHANGE THIS TO THE FULL PATH OF YOUR KAFKA INSTANCE"
SET brokerList="CHANGE THIS TO THE LIST OF KAFKA BROKERS" REM EXAMPLE: "localhost:9092,localhost:9093,localhost:9094"

REM ***********************  DO NOT CHANGE ANYTHING BELOW THIS LINE  ***********************

SET /p topic="Topic: "
cd %klocation%\bin\windows
call kafka-console-consumer.bat --bootstrap-server %brokerList% --topic %topic% --from-beginning
pause