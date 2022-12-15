Class {
	#name : #RmRunnerExecutionEnvironment,
	#superclass : #DefaultExecutionEnvironment,
	#classVars : [
		'InWorker',
		'RemoteRunner'
	],
	#category : #'PharoRI-Commands'
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

	RemoteRunner ifNil: [
		RemoteRunner := RmRemoteRunner newId: 'RunnerForTest' ].
	^ RemoteRunner ensureRunning
]
