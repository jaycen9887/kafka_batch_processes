# kafka_batch_processes
Kafka Batch Processes to simplify working with Kafka (on a local basis)

** You will need to edit these processes to be specific to your Kafka instance(s) -- Refer to the individual README files for more information**


## There are multiple processes included here
	- Starting Zookeeper and Kafka Servers respectively (both single and multiple brokers)
		- ZooKafkaStart_V1
			- ZooKafkaStart_V1_README.txt
		- ZooKafkaStart_V2-Multiple_Brokers
			- ZooKafkaStart_V2-Multiple_Brokers_README.txt
	- Starting a console Producer
		- startProducer_V1
	- Starting a console Consumer (from latest (both with and without specifying a groupID) and earliest)
		- startConsumer_FromBeginning
			- startConsumer_FromBeginning_README.txt
		- startConsumer_FromLatest
			- startConsumer_FromLatest_README.txt
		- startConsumer(GroupId)_FromLatest
			- startConsumer(GroupId)_FromLatest_README.txt
	- Resetting Offsets
		- resetOffsets
			- resetOffsets_README.txt
	- Describing Consumer Groups
		- describeConsumerGroup
			- describeConsumerGroup_README.txt
	- Creating a Topic
		- create-topic
			- create-topic_README.txt
	- Deleting a Topic
		- deleteTopic
			- deleteTopic_README.txt
	- Listing all Topics
		- listTopics
			- listTopics_README.txt
	