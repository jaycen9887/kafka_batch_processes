@ ECHO OFF
SET klocation="CHANGE THIS TO THE FULL PATH OF YOUR KAFKA INSTANCE"
SET brokerList="CHANGE THIS TO THE LIST OF KAFKA BROKERS" REM EXAMPLE: "localhost:9092,localhost:9093,localhost:9094"

REM ***********************  DO NOT CHANGE ANYTHING BELOW THIS LINE  ***********************

SET /p topic="Topic: "
SET /p groupId="Group ID: "

SET topicTryCount=1
SET topicMaxTries=3
SET topicMatch=false

SET groupIdTryCount=1
SET groupIdMaxTries=3
SET groupIdMatch=false

cd %klocation%\bin\windows

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
		SET /a topicTryCount+=1
		GOTO :TOPIC_EXISTS
	) ELSE (
		 for /f %%i in ('kafka-topics.bat --bootstrap-server %brokerList% --list') do (
			IF %%i==%topic% (
				SET topicMatch=true
			)
		)
	)

:VALIDATE_MATCH
	IF %topicMatch%==true (
		GOTO :GROUPID_EXISTS
		GOTO :EOF
	) ELSE (
		GOTO :GET_TOPIC
		GOTO :EOF
	)
	GOTO :EOF


:GET_TOPIC
	IF NOT %topicTryCount%==%topicMaxTries% (
		ECHO -------------------------------------------------
		ECHO *                                               *	
		ECHO *            TOPIC DOESN'T EXISTS,              *
		ECHO *              PLEASE TRY AGAIN                 *
		ECHO *                                               *
		ECHO -------------------------------------------------
		SET /p topic="Topic: "
		SET /a topicTryCount+=1
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

:GROUPID_EXISTS
	 for /f %%i in ('kafka-consumer-groups.bat --bootstrap-server %brokerList% --list') do (
		IF %%i==%groupId% (
			SET groupIdMatch=true
		)
	)

:VALIDATE_GROUP_MATCH
	IF %groupIdMatch%==true (
		GOTO :RUN_COMMAND
		GOTO :EOF
	) ELSE (
		GOTO :GET_GROUPID
		GOTO :EOF
	)
	GOTO :EOF


:GET_GROUPID
	IF NOT %groupIdTryCount%==%groupIdMaxTries% (
		ECHO -------------------------------------------------
		ECHO *                                               *	
		ECHO *           GROUP ID DOESN'T EXISTS,            *
		ECHO *              PLEASE TRY AGAIN                 *
		ECHO *                                               *
		ECHO -------------------------------------------------
		SET /p groupId="Group ID: "
		SET /a groupIdTryCount+=1
		GOTO :VALIDATE_GROUP_MATCH
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
	echo running command....
	call kafka-console-consumer.bat --bootstrap-server %brokerList% --topic %topic% --consumer-property group.id=%groupId%  --from-beginning
	pause
	GOTO :EOF
	
:EOF
	EXIT /B 0