Class {
	#name : #RmRemoteWorkerTest,
	#superclass : #RmTestCase,
	#instVars : [
		'runner'
	],
	#pools : [
		'RmConstants'
	],
	#category : #'PharoRI-Tests'
}

{ #category : #utilities }
RmRemoteWorkerTest >> longTestCase [

	self timeLimit: 60 seconds.
]

{ #category : #running }
RmRemoteWorkerTest >> setUp [

	super setUp.
	runner := RmRemoteWorkerMock new
]

{ #category : #tests }
RmRemoteWorkerTest >> testNotify [
	| notified worker |

	runner notify: TestAnnouncement new asRmNotification.
	self 
		assert: runner stdout contents trimmed  
		equals: '-n:TestAnnouncement{}'.

	notified := false.		
	worker := RmRemoteRunnerMock new. 
	worker announcer 
		when: TestAnnouncement 
		do: [ :ann | notified := true ].
		
	worker handleLine: runner stdout contents.
	
	self assert: notified
]

{ #category : #tests }
RmRemoteWorkerTest >> testNotifyNotAnAnnouncement [
	| notified worker value |

	runner notify: 42 asRmNotification.
	self 
		assert: runner stdout contents trimmed  
		equals: '-n:RmRemoteNotificationAnnouncement{#value:42}'.

	notified := false.		
	worker := RmRemoteRunnerMock new. 
	worker announcer 
		when: RmRemoteNotificationAnnouncement 
		do: [ :ann | 
			value := ann value.
			notified := true ].
		
	worker handleLine: runner stdout contents.
	
	self assert: notified.
	self assert: value equals: 42
]

{ #category : #tests }
RmRemoteWorkerTest >> testProcessCommand [
	| commandString |

	commandString := STON toString: (RmEvaluate do: [ 42 factorial ]).
	runner processCommand: COMMAND, commandString.
	
	self 
		assert: (runner stdout contents first: MARKER_SIZE)
		equals: RESULT
]

{ #category : #tests }
RmRemoteWorkerTest >> testProcessCommandWithError [
	| commandString |

	self longTestCase.

	commandString := STON toString: (RmEvaluate do: [ 42/0 ]).
	runner processCommand: COMMAND, commandString.
	
	self 
		assert: (runner stdout contents first: MARKER_SIZE)
		equals: ERROR.
	self 
		assert: (STON fromString: (runner stdout contents allButFirst: 3) trimmed) value class
		equals: ZeroDivide
]

{ #category : #tests }
RmRemoteWorkerTest >> testProcessCommandWithWarning [
	| commandString |

	self longTestCase.

	self timeLimit: 60 seconds.
	commandString := STON toString: (RmEvaluate do: [ Warning signal ]).
	runner processCommand: COMMAND, commandString.
	
	self 
		assert: (runner stdout contents first: MARKER_SIZE)
		equals: ERROR.
	self 
		assert: (STON fromString: (runner stdout contents allButFirst: 3) trimmed) value class
		equals: Warning
]

{ #category : #tests }
RmRemoteWorkerTest >> testStop [

	runner := RmRemoteWorkerMock new start.
	self assert: runner isRunning.
	runner stop.
	self deny: runner isRunning
]
