Class {
	#name : #RmRunnerExecutionEnvironment,
	#superclass : #DefaultExecutionEnvironment,
	#classVars : [
		'InWorker',
		'RemoteRunner'
	],
	#category : #'PharoRI-Runner'
}

{ #category : #accessor }
RmRunnerExecutionEnvironment class >> inWorkerDuring: aBlock [
	| oldWorker |

	oldWorker := InWorker.
	InWorker := true.
	^ aBlock ensure: [ 
		InWorker := oldWorker ]
]

{ #category : #testing }
RmRunnerExecutionEnvironment class >> isWorker [

	^ InWorker ifNil: [ InWorker := false ]
]

{ #category : #private }
RmRunnerExecutionEnvironment class >> runner [

	(RemoteRunner isNil or: [ RemoteRunner isRunning not ]) ifTrue: [
		RemoteRunner ifNotNil: [ RemoteRunner terminate ].   
		RemoteRunner := RmRemoteRunner newId: 'RunnerForTest'.
		RemoteRunner spawn.
		RemoteRunner listenToLog.
		RemoteRunner runCommand: [ GEngine ensureRunning. true ] ].

	^ RemoteRunner
]

{ #category : #testing }
RmRunnerExecutionEnvironment >> isWorker [

	^ self class isWorker
]

{ #category : #controlling }
RmRunnerExecutionEnvironment >> runTestCase: aTestCase [

	^ self isWorker 
		ifTrue: [ super runTestCase: aTestCase ]
		ifFalse: [ self runner runTest: aTestCase ]
]

{ #category : #controlling }
RmRunnerExecutionEnvironment >> runTestsBy: aBlock [

	aBlock value
]

{ #category : #private }
RmRunnerExecutionEnvironment >> runner [

	^ self class runner
]
