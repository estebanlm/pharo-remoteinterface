Class {
	#name : #RmRunnerExecutionEnvironment,
	#superclass : #DefaultExecutionEnvironment,
	#instVars : [
		'runner',
		'runnerActivationAction',
		'runLocal'
	],
	#classVars : [
		'InWorker'
	],
	#category : #'PharoRI-SUnit-Base'
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
RmRunnerExecutionEnvironment >> activateRunner [

	runner isRunning ifTrue: [ ^ self ].

	runner spawn.
	runner listenToLog.
	runnerActivationAction
		ifNotNil: [ runnerActivationAction value: runner ]
]

{ #category : #private }
RmRunnerExecutionEnvironment >> ensureRunner [

	self activateRunner.
	^ runner
]

{ #category : #initialization }
RmRunnerExecutionEnvironment >> initialize [

	super initialize.
	runner := RmRemoteRunner new.
	runner archetype poolSize: 10.
	runLocal := false
]

{ #category : #testing }
RmRunnerExecutionEnvironment >> isRunningInLocal [

	^ runLocal
]

{ #category : #testing }
RmRunnerExecutionEnvironment >> isWorker [

	^ self class isWorker
]

{ #category : #accessing }
RmRunnerExecutionEnvironment >> onRunnerActivated: aBlock [
	"Define a block to be executed when the runner is initialized (for example to ensure some
	 initialization in the worker)"

	runnerActivationAction := aBlock
]

{ #category : #private }
RmRunnerExecutionEnvironment >> remoteRunTestCase: aTestCase [
	| result |

	result := self ensureRunner runTest: aTestCase.
	result errors ifNotEmpty: [ :errors |
		RmRemoteError signalForException: (result errorTraceFor: errors anyOne) ].
	result failures ifNotEmpty: [ :failures |
		RmRemoteTestFailure signalForException: (result failureTraceFor: failures anyOne) ].
	result skipped ifNotEmpty: [ :skipped | TestResult skip signal ]
]

{ #category : #accessing }
RmRunnerExecutionEnvironment >> runLocal [

	runLocal := true
]

{ #category : #accessing }
RmRunnerExecutionEnvironment >> runRemote [

	runLocal := false
]

{ #category : #controlling }
RmRunnerExecutionEnvironment >> runTestCase: aTestCase [

	(self isWorker or: [ self isRunningInLocal ])
		ifTrue: [ super runTestCase: aTestCase ]
		ifFalse: [ self remoteRunTestCase: aTestCase ]
]

{ #category : #accessing }
RmRunnerExecutionEnvironment >> runner [

	^ runner
]

{ #category : #accessing }
RmRunnerExecutionEnvironment >> runnerId: anId [

	runner id: anId
]
