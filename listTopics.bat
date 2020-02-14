@ECHO OFF
SET klocation="CHANGE THIS TO THE FULL PATH OF YOUR KAFKA INSTANCE"
SET brokerList="CHANGE THIS TO YOUR LIST OF KAFKA BROKERS"

REM ***********************  DO NOT CHANGE ANYTHING BELOW THIS LINE  ***********************

SET consumerOffsetsTopic=__consumer_offsets
SET match=false

cd %klocation%\bin\windows

ECHO --------------------------------------------------------------------

for /f %%i in ('kafka-topics.bat --bootstrap-server %brokerList% --list') do (
	IF NOT %%i==%consumerOffsetsTopic% (
		ECHO %%i
	)
)

ECHO --------------------------------------------------------------------
ECHO Exiting Program
PAUSE
