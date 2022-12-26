Class {
	#name : #RmRunnerExecutionEnvironmentTest,
	#superclass : #TestCase,
	#category : #'PharoRI-Tests'
}

{ #category : #tests }
RmRunnerExecutionEnvironmentTest >> remoteTest [

	self assert: RmRunnerExecutionEnvironment isWorker
]

{ #category : #tests }
RmRunnerExecutionEnvironmentTest >> testRunTestCase [

	RmRunnerExecutionEnvironment new runTestCase: (self class new 
		setTestSelector: #remoteTest;
		yourself)
]
