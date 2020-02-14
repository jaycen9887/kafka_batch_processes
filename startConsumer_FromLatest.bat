@ ECHO OFF
SET klocation="CHANGE THIS TO THE FULL PATH OF YOUR KAFKA INSTANCE"
SET brokerList="CHANGE THIS TO THE LIST OF KAFKA BROKERS" REM EXAMPLE: "localhost:9092,localhost:9093,localhost:9094"

REM ***********************  DO NOT CHANGE ANYTHING BELOW THIS LINE  ***********************

cd %klocation%\bin\windows
SET tryCount=1
SET maxTries=3
SET match=false
SET /p topic="Topic: "

:TOPIC_EXISTS
	IF %topic%==__consumer_offsets (
		ECHO -------------------------------------------------
		ECHO *                                               *	
		ECHO *     '__consumer_offsets' SHOULD NOT BE        *
		ECHO *         DIRECTLY INTERACTED WITH              *
		ECHO *   PLEASE TRY AGAIN WITH A DIFFERENT TOPIC     *
		ECHO *                                               *
		ECHO -------------------------------------------------
		SET /p topic="Topic: "
		SET /a tryCount+=1
		GOTO :TOPIC_EXISTS
	) ELSE (
		 for /f %%i in ('kafka-topics.bat --bootstrap-server %brokerList% --list') do (
			IF %%i==%topic% (
				SET match=true
			)
		)
	)

:VALIDATE_MATCH
	IF %match%==true (
		GOTO :RUN_COMMAND
		GOTO :EOF
	) ELSE (
		GOTO :GET_TOPIC
		GOTO :EOF
	)
	GOTO :EOF


:GET_TOPIC
	IF NOT %tryCount%==%maxTries% (
		ECHO -------------------------------------------------
		ECHO *                                               *	
		ECHO *            TOPIC DOESN'T EXISTS,              *
		ECHO *              PLEASE TRY AGAIN                 *
		ECHO *                                               *
		ECHO -------------------------------------------------
		SET /p topic="Topic: "
		SET /a tryCount+=1
		GOTO :TOPIC_EXISTS
	) ELSE (
		ECHO -------------------------------------------------
		ECHO *                                               *	
		ECHO *            INVALID TOPIC NAME,                *
		ECHO *             PROGRAM EXITING...                *
		ECHO *                                               *
		ECHO -------------------------------------------------
		PAUSE
		GOTO :EOF
	)

:RUN_COMMAND
	call kafka-console-consumer.bat --bootstrap-server %brokerList% --topic %topic%
	PAUSE
	GOTO :EOF

:EOF
	EXIT /B 0