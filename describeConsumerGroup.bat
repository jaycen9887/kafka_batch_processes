@ECHO OFF
SET klocation="CHANGE THIS TO THE FULL PATH OF YOUR KAFKA INSTANCE"
SET brokerList="CHANGE THIS TO THE LIST OF KAFKA BROKERS" REM EXAMPLE: "localhost:9092,localhost:9093,localhost:9094"

REM ***********************  DO NOT CHANGE ANYTHING BELOW THIS LINE  ***********************

SET /p group="Group-Id: "
SET tryCount=1
SET maxTries=3
SET match=false

cd %klocation%\bin\windows

:GROUPID_EXISTS
	 for /f %%i in ('kafka-consumer-groups.bat --bootstrap-server %brokerList% --list') do (
		IF %%i==%group% (
			SET match=true
		)
	)

:VALIDATE_MATCH
	IF %match%==true (
		GOTO :RUN_COMMAND
	) ELSE (
		GOTO :GET_GROUPID
	)
	GOTO :EOF


:GET_GROUPID
	IF NOT %tryCount%==%maxTries% (
		ECHO -------------------------------------------------
		ECHO *                                               *	
		ECHO *           GROUP ID DOESN'T EXISTS,            *
		ECHO *              PLEASE TRY AGAIN                 *
		ECHO *                                               *
		ECHO -------------------------------------------------
		SET /p group="Group-Id: "
		SET /a tryCount+=1
		GOTO :GROUPID_EXISTS
	) ELSE (
		ECHO -------------------------------------------------
		ECHO *                                               *	
		ECHO *              INVALID GROUP ID,                *
		ECHO *              PROGRAM EXITING...               *
		ECHO *                                               *
		ECHO -------------------------------------------------
		PAUSE
		GOTO :EOF
	)

:RUN_COMMAND
	call kafka-consumer-groups.bat --bootstrap-server %brokerList% --group %group% --describe
	PAUSE
	GOTO :EOF

:EOF
	EXIT /B 0