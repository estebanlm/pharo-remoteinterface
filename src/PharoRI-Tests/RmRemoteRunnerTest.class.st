Class {
	#name : #RmRemoteRunnerTest,
	#superclass : #RmTestCase,
	#instVars : [
		'worker'
	],
	#pools : [
		'RmConstants'
	],
	#category : #'PharoRI-Tests'
}

{ #category : #running }
RmRemoteRunnerTest >> setUp [
	
	super setUp.
	worker := RmRemoteRunnerMock new.
	RmCommandIdGenerator reset
]

{ #category : #tests }
RmRemoteRunnerTest >> testIsAlive [

	worker := RmRemoteRunner new.
	self deny: worker isRunning.
	worker spawn.
	[ self assert: worker isAlive ]
	ensure: [ worker remoteWorker forceTerminate ].
	self deny: worker isAlive
]

{ #category : #tests }
RmRemoteRunnerTest >> testIsRunning [

	worker := RmRemoteRunner new.
	self deny: worker isRunning.
	worker spawn.
	[ self assert: worker isRunning ]
	ensure: [ worker forceTerminate ].
	self deny: worker isRunning
]

{ #category : #tests }
RmRemoteRunnerTest >> testPing [

	worker := RmRemoteRunner new.
	worker spawn.
	[ self assert: worker ping ]
	ensure: [ worker remoteWorker forceTerminate ].
	self deny: worker ping
]

{ #category : #tests }
RmRemoteRunnerTest >> testRunCommandOnSuccessOnError [
	| command result sem |

	worker := RmRemoteRunner new.
	worker spawn.
	
	command := RmEvaluate do: [ 42 factorial ].
	sem := Semaphore new.
	result := false.
	[
		worker 
			runCommand: command 
			onSuccess: [ :aValue | 
				result := aValue.
				sem signal ]
			onError: [ :e |
				sem signal ].
		sem wait ]
	ensure: [ 
		worker forceTerminate ].
	
	self assert: result equals: 42 factorial
]

{ #category : #tests }
RmRemoteRunnerTest >> testSynchronizeCodeChanges [
	| factory |

	factory := ClassFactoryForTestCase new.
	worker := RmRemoteRunner new.
	worker archetype: RmThisImageArchetype new.
	[ 
		| class block | 

		worker spawn.
	
		class := factory newClass.
		class compile: 'method1 ^ 42'.
		block := self class evaluate: ('[ {1} new method1 ]' format: { class name }).
		self 
			assert: (worker evaluate: block) 
			equals: 42 ]
	ensure: [ 
		factory cleanUp.
		worker forceTerminate ]
]

{ #category : #tests }
RmRemoteRunnerTest >> testTryError [
	| error errorLine errorInFuture errorAnnounced future |

	errorInFuture := nil.
	future := (worker pushFutureFor: RmCommand new)
		onError: [ :e | errorInFuture := e ];
		yourself.

	error := Error new messageText: 'Test'.
	errorLine := self writeAnswer: ERROR object: (error asPmiAnswer
		id: future id;
		yourself). 

	errorAnnounced := nil.
	worker announcer
		when: RmRemoteErrorAnnouncement
		do: [ :ann | errorAnnounced := ann answer value ].

	worker tryError: errorLine.
	
	self assert: future isFinished.
	self assert: future isError.
	self assert: errorInFuture notNil.
	self assert: errorInFuture messageText equals: 'Test'.	
	
	self assert: errorAnnounced notNil.
	self assert: errorAnnounced messageText equals: 'Test'
]

{ #category : #tests }
RmRemoteRunnerTest >> testTryNotify [
	| notifyLine objectAnnounced |

	"Notification are just announced, not kept as errors"

	notifyLine := self writeAnswer: NOTIFY object: 42 asPmiNotification. 

	objectAnnounced := nil.
	worker announcer
		when: RmRemoteNotificationAnnouncement
		do: [ :ann | objectAnnounced := ann value ].

	self assert: (worker tryNotify: notifyLine).

	self assert: objectAnnounced notNil.
	self assert: objectAnnounced equals: 42
]

{ #category : #tests }
RmRemoteRunnerTest >> testTrySuccess [
	| future result line |

	future := (worker pushFutureFor: (RmEvaluate do: [ 42 ]))
		onSuccess: [ :value | result := value ];
		yourself.

	line := self writeAnswer: RESULT object: (42 asPmiAnswer
		id: future id;
		yourself). 

	worker trySuccess: line.
	
	self assert: future isFinished.
	self assert: future isSuccess.
	self assert: future value equals: 42.
	self assert: result equals: 42
]

{ #category : #private }
RmRemoteRunnerTest >> writeAnswer: aType object: anObject [  
	| runner |
	
	runner := RmRemoteWorkerMock new.
	runner writeAnswer: aType object: anObject.
	^ runner stdout contents
	
	
]
