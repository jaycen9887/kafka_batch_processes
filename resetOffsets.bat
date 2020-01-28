@ECHO OFF
SET klocation="CHANGE THIS TO THE FULL PATH OF YOUR KAFKA INSTANCE"
SET brokerList="CHANGE THIS TO THE LIST OF KAFKA BROKERS" REM EXAMPLE: "localhost:9092,localhost:9093,localhost:9094"


REM ***********************  DO NOT CHANGE ANYTHING BELOW THIS LINE  ***********************

SET /p topic="Topic: "
SET /p consumerGroup="Consumer GroupID: "

SET retries=3;
SET count=1;
SET endPoint=start

SET parameter=unset
SET runOffset=false

REM ---------------------------------------------

GOTO :START

:START
SET /p offset="Enter [e] for earliest, [l] for latest, or a specific offset (#): "

SET checkNeeded=true
SET /A offsetNum=offset

REM Check if User entered a number or a letter and handle the letter/string accordingly
IF %offset%==%offsetNum% ( 
	GOTO :CASE_NUM
	GOTO :EOF
) ELSE (
	IF %offset%==E ( GOTO :CASE_E )
	IF %offset%==e ( GOTO :CASE_E )
	IF %offset%==Earliest ( GOTO :CASE_E)
	IF %offset%==earliest ( GOTO :CASE_E )
	IF %offset%==EARLIEST ( GOTO :CASE_E ) 
	IF %offset%==L ( GOTO :CASE_L ) 
	IF %offset%==l ( GOTO :CASE_L)
	IF %offset%==Latest ( GOTO :CASE_L ) 
	IF %offset%==latest ( GOTO :CASE_L ) 
	IF %offset%==LATEST ( 
		GOTO :CASE_L 
	) ELSE ( 
		GOTO :CASE_INVALID_PARAM
	)
	GOTO :EOF
)	

:CASE_E
	ECHO Below will be the result of resetting the offset to 'EARLIEST' offset
	SET parameter=--to-earliest
	CALL :SHOW_OUTPUT
	pause
	GOTO :EOF
	
:CASE_L
	ECHO Below will be the result of resetting the offset to 'LATEST' offset
	SET parameter=--to-latest
	CALL :SHOW_OUTPUT
	pause
	GOTO :EOF

:CASE_INVALID_PARAM
	IF %count%==%retries% ( 
		GOTO :CASE_END_RETRY 
		GOTO :EOF 
	) ELSE ( 
		GOTO :CASE_RETRY
		GOTO :EOF
	)
	
:CASE_NUM
	SET runOffset=true
	ECHO Below will be the result of resetting the offset to '%offset%' offset
	SET parameter=%offset%
	CALL :SHOW_OUTPUT
	GOTO :EOF
	
:SHOW_OUTPUT
	SET %count%=1
	SET endPoint=notstart
	cd %klocation%
	IF %runOffset%==false (
		.\bin\windows\kafka-consumer-groups.bat --bootstrap-server %bootstrapServers% --group %consumerGroup% --reset-offsets %parameter% --topic %topic% --dry-run && ( 
			GOTO :GET_NEXT_STEP
			GOTO :EOF
		) || (
			ECHO ECHO ERROR EXECUTING COMMAND '.\bin\windows\kafka-consumer-groups.bat --bootstrap-server %bootstrapServers% --group %consumerGroup% --reset-offsets %parameter% --topic %topic% --dry-run'
			pause
			GOTO :EOF
		)
	) ELSE (
		.\bin\windows\kafka-consumer-groups.bat --bootstrap-server %bootstrapServers% --group %consumerGroup% --reset-offsets --to-offset %parameter% --topic %topic% --dry-run && ( 
			GOTO :GET_NEXT_STEP 
		) || (
			ECHO ERROR EXECUTING COMMAND '.\bin\windows\kafka-consumer-groups.bat --bootstrap-server %bootstrapServers% --group %consumerGroup% --reset-offsets --to-offset %parameter% --topic %topic% --dry-run'
			pause
			GOTO :EOF
			
		)
	)
	
:GET_NEXT_STEP
	ECHO *
	ECHO ----------------------------------------------------
	ECHO *
	SET /p shouldExecute="Execute this command [y/n]: "
	IF %shouldExecute%==y ( 
		GOTO :EXECUTE_COMMAND
	)
	IF %shouldExecute%==Y ( 
		GOTO :EXECUTE_COMMAND
	)
	IF %shouldExecute%==YES (
		GOTO :EXECUTE_COMMAND
	)
	IF %shouldExecute%==Yes ( 
		GOTO :EXECUTE_COMMAND
	)
	IF %shouldExecute%==yes ( 
		GOTO :EXECUTE_COMMAND
	)
	IF %shouldExecute%==n ( 
		GOTO :DO_NOT_EXECUTE 
	)
	IF %shouldExecute%==N ( 
		GOTO :DO_NOT_EXECUTE 
	)
	IF %shouldExecute%==NO ( 
		GOTO :DO_NOT_EXECUTE 
	)
	IF %shouldExecute%==No ( 
		GOTO :DO_NOT_EXECUTE 
	)
	IF %shouldExecute%==no ( 
		GOTO :DO_NOT_EXECUTE 
	) ELSE (
		GOTO :CASE_INVALID_PARAM %parameter%
	)
	
:DO_NOT_EXECUTE
	ECHO *
	ECHO ----------------------------------------------------
	ECHO *
	ECHO COMMAND NOT EXECUTED AS REQUESTED
	ECHO EXITING PROGRAM...
	pause
	GOTO :EOF
	
:EXECUTE_COMMAND
	IF %runOffset%==false (
		CALL .\bin\windows\kafka-consumer-groups.bat --bootstrap-server %bootstrapServers% --group %consumerGroup% --reset-offsets %parameter% --topic %topic% --execute && ( 
			GOTO :SUCCESS_MESSAGE
		) || (
			GOTO :ERROR_MESSAGE '.\bin\windows\kafka-consumer-groups.bat --bootstrap-server %bootstrapServers% --group %consumerGroup% --reset-offsets %parameter% --topic %topic% --execute'
		)
	) ELSE (
		CALL .\bin\windows\kafka-consumer-groups.bat --bootstrap-server %bootstrapServers% --group %consumerGroup% --reset-offsets --to-offset %parameter% --topic %topic% --execute && ( 
			GOTO :SUCCESS_MESSAGE
		) || (
			GOTO :ERROR_MESSAGE '.\bin\windows\kafka-consumer-groups.bat --bootstrap-server %bootstrapServers% --group %consumerGroup% --reset-offsets --to-offset %parameter% --topic %topic% --execute'
		)
	)
	GOTO :EOF
	
	
:SUCCESS_MESSAGE
	ECHO *
	ECHO ----------------------------------------------------
	ECHO *
	ECHO Command executed Successfully
	ECHO Execution results below
	GOTO :CASE_DISPLAY_EXECUTE_RESULTS
	
	GOTO :EOF
	
:ERROR_MESSAGE
	ECHO *
	ECHO ----------------------------------------------------
	ECHO *
	ECHO ERROR EXECUTING COMMAND: %~1
	pause
	GOTO :EOF
	
:CASE_DISPLAY_EXECUTE_RESULTS
	call .\bin\windows\kafka-consumer-groups.bat --bootstrap-server %bootstrapServers% --group %consumerGroup% --describe
	ECHO *
	ECHO ----------------------------------------------------
	ECHO *
	ECHO EXITING PROGRAM...
	pause
	GOTO :EOF
	
:CASE_RETRY
	IF %endPoint%==start (
		ECHO -------------------------------------------------
		ECHO *                                               *	
		ECHO *    INVALID PARAMETER, PLEASE TRY AGAIN        *
		ECHO *                                               *
		ECHO -------------------------------------------------
		SET /a count+=1
		CALL :START
		GOTO :EOF
	) ELSE (
		ECHO -------------------------------------------------
		ECHO *                                               *	
		ECHO *    INVALID PARAMETER, PLEASE TRY AGAIN        *
		ECHO *                                               *
		ECHO -------------------------------------------------
		SET /a count+=1
		CALL :GET_NEXT_STEP
		GOTO :EOF
	)
	
:CASE_END_RETRY
	ECHO -------------------------------------------------
	ECHO *                                               *	
	ECHO *    INVALID PARAMETER, PLEASE READ THE         *
	ECHO *        README FOR ALL VALID INPUT             *	
	ECHO *                                               *
	ECHO -------------------------------------------------
	pause
	GOTO :EOF
	
:EOF
	EXIT /B 0