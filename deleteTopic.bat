@ ECHO OFF
SET klocation="CHANGE THIS TO THE FULL PATH OF YOUR KAFKA INSTANCE"
SET zookeeper="CHANGE THIS TO YOUR ZOOKEEPER HOST:PORT"
SET /p topic="Topic:"

cd %klocation%\bin\windows
kafka-topics.bat --zookeeper %zookeeper% --delete --topic %topic% && (
	ECHO Done...
	pause
) || (
	ECHO ERROR
	pause
)