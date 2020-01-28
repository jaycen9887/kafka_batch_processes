@ECHO OFF
SET klocation="CHANGE THIS TO THE FULL PATH OF YOUR KAFKA INSTANCE"
SET bootstrapServers="CHANGE THIS TO YOUR LIST OF KAFKA BROKERS"

REM ***********************  DO NOT CHANGE ANYTHING BELOW THIS LINE  ***********************

SET /p topic="Topic "
SET match=false

cd %klocation%\bin\windows
call kafka-topics.bat --bootstrap-server %brokerList% --list && (
	ECHO Process Completed Successfully
	ECHO Program exiting...
	PAUSE
	EXIT /B 0
) || (
	ECHO Process was not successful
	ECHO Program exiting...
	PAUSE
	EXIT /B 0
)