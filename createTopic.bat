@echo off
set klocation="CHANGE THIS TO THE FULL PATH OF YOUR KAFKA INSTANCE"
SET brokerList="CHANGE THIS TO THE LIST OF KAFKA BROKERS" REM EXAMPLE: "localhost:9092,localhost:9093,localhost:9094"

REM ***********************  DO NOT CHANGE ANYTHING BELOW THIS LINE  ***********************

set /p topic="Enter Topic Name: "
set /p rep = "Enter Replication Factor: "
set /p part = "Enter Number of Partitions: "

cd %klocation%
CALL .\bin\windows\kafka-topics.bat --create --bootstrap-server %brokers% --replication-factor %rep% --partitions %part% --topic %topic% && (
	GOTO :EXECUTION_SUCCESS
) || (
	GOTO :EXECUTION_FAILURE 
)

:EXECUTION_SUCCESS
	ECHO Command Executed Successfully
	ECHO Program Exiting
	pause
	GOTO :EOF
	
:EXECUTION_FAILURE
		ECHO Error executing command
		ECHO Program Exiting
		pause
		GOTO :EOF		
	
:EOF
	EXIT /B 0