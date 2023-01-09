"
A remote runner, a tool to execute code in a separated image.
Remote images are defined by an archetype (see `PmiWorkerArchetype` hierarchy).
The default archetype for the runner is an instance of `PmiThisImageArchetype`, which will spawn a replica of current image, and it will kept it synchronized with changes made to current one.

IMPORTANT: The worker images need to include this package to be able to act as worker.

The simplest way to execute a runner is: 
```
worker := PmiRemoteRunner new.
worker spawn
```
"
Class {
	#name : #RmRemoteRunner,
	#superclass : #RmPeerToPeer,
	#instVars : [
		'id',
		'remoteWorker',
		'readChannel',
		'writeChannel',
		'errorChannel',
		'announcer',
		'archetype',
		'errorListener',
		'readListener',
		'scheduler',
		'futures'
	],
	#classVars : [
		'ActiveRunners',
		'LogAnnouncer'
	],
	#pools : [
		'GSpawnFlags'
	],
	#category : #'PharoRI-Runner'
}

{ #category : #accessing }
RmRemoteRunner class >> activeRunners [

	^ ActiveRunners
]

{ #category : #defaults }
RmRemoteRunner class >> defaultArchetype [

	^ RmThisImageArchetype new
]

{ #category : #initialization }
RmRemoteRunner class >> initialize [

	SessionManager default registerUserClassNamed: self name
]

{ #category : #accessing }
RmRemoteRunner class >> logAnnouncer [

	^ LogAnnouncer ifNil: [ LogAnnouncer := Announcer new ]
]

{ #category : #'instance creation' }
RmRemoteRunner class >> newId: aString [

	^ self new 
		id: aString;
		yourself
]

{ #category : #private }
RmRemoteRunner class >> registerWorker: aRunner [

	ActiveRunners ifNil: [ ActiveRunners := WeakRegistry new ].
	ActiveRunners add: aRunner.
	
	self logAnnouncer announce: (RmRemoteRunnerRegisteredAnnouncement new 
		runner: aRunner;
		yourself)
]

{ #category : #'system startup' }
RmRemoteRunner class >> shutDown: quitting [

	quitting ifFalse: [ ^ self ].
	ActiveRunners ifNotNil: [ 
		ActiveRunners do: [ :each | each terminate ].
		ActiveRunners := nil ]
]

{ #category : #private }
RmRemoteRunner >> announce: ann [

	announcer ifNil: [ ^ self ].
	announcer announce: ann
]

{ #category : #accessing }
RmRemoteRunner >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
RmRemoteRunner >> archetype [

	^ archetype ifNil: [ archetype := self class defaultArchetype ]
]

{ #category : #accessing }
RmRemoteRunner >> archetype: aWorkerAchetype [

	archetype := aWorkerAchetype
]

{ #category : #private }
RmRemoteRunner >> basicHandleLine: line [

	(self tryError: line) 	ifTrue: [ ^ self ].
	(self tryNotify: line) 	ifTrue: [ ^ self ].
	(self trySuccess: line) 	ifTrue: [ ^ self ].
	(self tryCommand: line) 	ifTrue: [ ^ self ].

	line trimmed ifEmpty: [ ^ self ].
	
	Warning signal:	('Unknown answer {1}' format: { line })
]

{ #category : #private }
RmRemoteRunner >> cleanUp [

	remoteWorker := nil.
	readChannel := nil.
	writeChannel := nil.
	errorChannel := nil.
	remoteWorker := nil
]

{ #category : #private }
RmRemoteRunner >> ensureRunning [

	self isRunning ifTrue: [ ^ self ].
	self spawn
]

{ #category : #'private - channels' }
RmRemoteRunner >> errorChannel [
		
	^ errorChannel
]

{ #category : #commands }
RmRemoteRunner >> evaluate: aBlock [

	^ self runCommand: aBlock asRmCommand
]

{ #category : #finalization }
RmRemoteRunner >> executor [

	^ RmRemoteRunnerFinalizer for: self
]

{ #category : #starting }
RmRemoteRunner >> forceTerminate [

	remoteWorker ifNotNil: #forceTerminate.
	self terminate
	
]

{ #category : #'private - future' }
RmRemoteRunner >> futureAt: anId [

	^ futures 
		at: anId
		ifAbsent: [ 
			self error: 'Retrieving a future for an unknown request.' ]
]

{ #category : #private }
RmRemoteRunner >> handleError: anError [

	anError pass
]

{ #category : #private }
RmRemoteRunner >> handleLine: line [

	[ self basicHandleLine: line ]
	on: Error, Warning
	fork: [ :e |
		(e isKindOf: Warning)
			ifTrue: [ self handleWarning: e ]
			ifFalse: [ self handleError: e ] ]
]

{ #category : #private }
RmRemoteRunner >> handleWarning: aWarning [

	aWarning emit.
	aWarning resume
]

{ #category : #accessing }
RmRemoteRunner >> id [

	^ id ifNil: [ id := UUID new asString ]
]

{ #category : #accessing }
RmRemoteRunner >> id: anIdentifier [

	id := anIdentifier
]

{ #category : #initialization }
RmRemoteRunner >> initialize [

	super initialize.
	self intializeScheduler.
	futures := IdentityDictionary new
]

{ #category : #initialization }
RmRemoteRunner >> intializeScheduler [
	
	scheduler := TKTWorkerPool new.
	scheduler poolMaxSize: 10.
	scheduler start
]

{ #category : #testing }
RmRemoteRunner >> isAlive [

	^ self isRunning 
		and: [ self ping ]
]

{ #category : #testing }
RmRemoteRunner >> isErrorListenerRunning [
	
	^ errorListener notNil and: [ errorListener isRunning ]
]

{ #category : #testing }
RmRemoteRunner >> isReadListenerRunning [
	
	^ readListener notNil and: [ readListener isRunning ]
]

{ #category : #testing }
RmRemoteRunner >> isRunning [

	^ readListener notNil 
		and: [ readListener isRunning ]
]

{ #category : #'private - listeners' }
RmRemoteRunner >> launchSynchronizationListener [
	
	self sourceChangesAnnouncer weak 
		when: EpEntryAdded 
		send: #synchronizeChange: 
		to: self
]

{ #category : #'private - listeners' }
RmRemoteRunner >> launchWaitForAnswerListener [

	self isReadListenerRunning ifTrue: [ ^ self ].

	readListener := self readChannel 
		newReadLineListener: ('read_{1}' format: { remoteWorker pid })
		receiver: self
		selector: #handleLine:.
	readListener announcer 
		when: GIOChannelTerminatedAnnouncement
		send: #terminatedWithStatus:
		to: self.
	readListener start
]

{ #category : #'private - listeners' }
RmRemoteRunner >> launchWaitForLogListener [

	self isErrorListenerRunning ifTrue: [ ^ self ].

	errorListener := self errorChannel 
		newReadLineListener: ('error_{1}' format: { remoteWorker pid })
		receiver: self
		selector: #logWorkerSignal:.
	errorListener start
]

{ #category : #accessing }
RmRemoteRunner >> listenToFile [

	self isRunning 
		ifFalse: [ self error: 'RemoteWorker not running' ].
		
	self runCommand: [ 
		FileLogger new 
			filename: 'worker.log';
			append: true;
			serializer: RmSTONSerializer new;
			start.
		true	]
]

{ #category : #accessing }
RmRemoteRunner >> listenToLog [

	self isRunning 
		ifFalse: [ self error: 'RemoteWorker not running' ].
		
	self launchWaitForLogListener.
	self runCommand: [ 
		FileLogger new 
			serializer: RmSTONSerializer new;
			stream: Stdio stderr;
			start.
		true	]
]

{ #category : #private }
RmRemoteRunner >> logWorkerSignal: line [

	self class logAnnouncer announce: (RmRemoteSignalAnnouncement new 
		runner: self;
		parseSignal: line;
		yourself)
]

{ #category : #commands }
RmRemoteRunner >> ping [
	| result sem |

	result := false.
	sem := Semaphore new.

	self 
		runCommand: [ true ]
		onSuccess: [ :aValue | 
			result := aValue. 
			sem signal ]
		onError: [ :e |
			result := false. 
			sem signal ].

	"timeout"
	[
		500 milliSeconds wait. 
		sem signal ] 
	fork.

	sem wait.
	
	^ result
]

{ #category : #printing }
RmRemoteRunner >> printOn: stream [

	super printOn: stream.
	stream << '(' << self id << ')'
]

{ #category : #private }
RmRemoteRunner >> pushError: anAnswer [

	"if there is no id, means an error occured outside the command/answer cycle.
	 We need yo process it"
	anAnswer id ifNil: [
		anAnswer value debug ].
	(self removeFutureAt: anAnswer id) resolveAsError: anAnswer value.
	self announce: (RmRemoteErrorAnnouncement newAnswer: anAnswer)
]

{ #category : #'private - future' }
RmRemoteRunner >> pushFuture: aFuture [

	futures at: aFuture id put: aFuture.
	^ aFuture
]

{ #category : #'private - future' }
RmRemoteRunner >> pushFutureFor: aCommand [

	^ self pushFuture: (RmFuture newWorker: self command: aCommand)
]

{ #category : #private }
RmRemoteRunner >> pushNotify: aNotification [
	
	self announce: aNotification
]

{ #category : #private }
RmRemoteRunner >> pushSuccess: anAnswer [
	
	(self removeFutureAt: anAnswer id) resolveAsSuccess: anAnswer value
]

{ #category : #commands }
RmRemoteRunner >> quit [
	| result |

	result := self runCommand: RmQuit new.
	result ifTrue: [ self terminate ].
	^ result
]

{ #category : #'private - channels' }
RmRemoteRunner >> readChannel [
		
	^ readChannel
]

{ #category : #private }
RmRemoteRunner >> registerWorkerForShutdown [

	self class registerWorker: self
]

{ #category : #private }
RmRemoteRunner >> remoteWorker [

	^ remoteWorker
]

{ #category : #'private - future' }
RmRemoteRunner >> removeFutureAt: anId [

	^ futures 
		removeKey: anId 
		ifAbsent: [ 
			self error: 'Retrieving a future for an unknown request.' ]
]

{ #category : #commands }
RmRemoteRunner >> runCommand: aCommand [
	| sem result aborted error |

	self ensureRunning.
	
	sem := Semaphore new.
	aborted := false.
	self schedule: [
		(self pushFutureFor: aCommand asRmCommand)
			onSuccess: [ :remoteAnswer |
				result := remoteAnswer.
				sem signal ];
			onError: [ :remoteError | 
				error := remoteError.
				sem signal ];
			onAbort: [ 
				aborted := true.
				sem signal ];
			execute ].
	sem wait.

	aborted ifTrue: [ self error: 'Execution terminated.' ].	
	error ifNotNil: [ 
		RmRemoteError signalForException: error ].
	
	^ result
]

{ #category : #commands }
RmRemoteRunner >> runCommand: aCommand onSuccess: aBlock [

	self ensureRunning.
	self schedule: [ 
		(self pushFutureFor: aCommand asRmCommand)
			onSuccess: aBlock;
			onError: [ :e | RmRemoteError signalForException: e ];
			onAbort: [ ];
			execute ]
]

{ #category : #commands }
RmRemoteRunner >> runCommand: aCommand onSuccess: aBlock onError: errorBlock [

	self ensureRunning.
	self schedule: [ 
		(self pushFutureFor: aCommand asRmCommand)
			onSuccess: aBlock;
			onError: errorBlock;
			onAbort: [ ];
			execute ]
]

{ #category : #private }
RmRemoteRunner >> schedule: aBlock [

	self scheduler schedule: aBlock
]

{ #category : #private }
RmRemoteRunner >> scheduler [

	^ scheduler 
]

{ #category : #private }
RmRemoteRunner >> sendCommand: aCommand [

	TFProcessLocalWorker useSameThreadDuring: [
		self writeChannel
			write: COMMAND;
			writeLine: (STON toString: aCommand);
			flush ] 
]

{ #category : #'private - listeners' }
RmRemoteRunner >> sourceChangesAnnouncer [ 

	"yeah, this does not resists demeter law"
	^ EpMonitor current log announcer
]

{ #category : #starting }
RmRemoteRunner >> spawn [ 

	remoteWorker := self archetype spawn.
	
	writeChannel := remoteWorker inChannel.
	readChannel := remoteWorker outChannel.
	errorChannel := remoteWorker errChannel.
	
	self launchWaitForAnswerListener.
	self registerWorkerForShutdown.
	
	self archetype workerStartedOn: self
]

{ #category : #'private - listeners' }
RmRemoteRunner >> stopAllListeners [

	self stopSynchronizationListener.
	self stopErrorListener.
	self stopReadListener
]

{ #category : #'private - listeners' }
RmRemoteRunner >> stopErrorListener [
	
	errorListener ifNil: [ ^ self ]. 
	errorListener stop.
	errorListener := nil
]

{ #category : #accessing }
RmRemoteRunner >> stopListenToLog [

	self isRunning 
		ifFalse: [ self error: 'RemoteWorker not running' ].
		
	self stopErrorListener
]

{ #category : #'private - listeners' }
RmRemoteRunner >> stopReadListener [
	
	readListener ifNil: [ ^ self ]. 
	readListener stop.
	readListener := nil
]

{ #category : #'private - listeners' }
RmRemoteRunner >> stopSynchronizationListener [
	
	self sourceChangesAnnouncer unsubscribe: self
]

{ #category : #private }
RmRemoteRunner >> synchronizeChange: ann [


	self isRunning ifFalse: [ ^ self ].
	ann entry content isCodeChange ifFalse: [ ^ self ].
	 
	[ 'Synchronize entry: {1}' format: { ann entry } ] emit.
	self 
		runCommand: (RmReplay newEntry: ann entry)
		onSuccess: [ ]
]

{ #category : #private }
RmRemoteRunner >> terminate [

	"Stop worker"
	remoteWorker ifNotNil: [ 
		TFProcessLocalWorker useSameThreadDuring: [ remoteWorker close ] ].
	"stop listeners"
	self stopAllListeners.
	"cleaning just to ensure everything is collected"
	self cleanUp.
	
	self class logAnnouncer announce: (RmRemoteRunnerTerminatedAnnouncement new 
		runner: self;
		yourself)
]

{ #category : #private }
RmRemoteRunner >> terminatedWithStatus: ann [

	[ 'Terminated with status: {1}' format: { ann status } ] emit.
	
	"stop listeners"
	self stopAllListeners.
	"cleaning just to ensure everything is collected"
	self cleanUp.
	
	futures do: [ :each | each abort ]
]

{ #category : #private }
RmRemoteRunner >> tryCommand: line [

	(self isCommand: line) ifFalse: [ ^ false ].
	
	self error: 'Not a peer to peer service yet!'.
	
	^ true
]

{ #category : #private }
RmRemoteRunner >> tryError: line [
	| answer |

	(self isError: line) ifFalse: [ ^ false ].
	answer := self materializeLine: line.
	self pushError: answer. 
	^ true
]

{ #category : #private }
RmRemoteRunner >> tryNotify: line [

	(self isNotify: line) ifFalse: [ ^ false ].
	self pushNotify: (self materializeLine: line).
	^ true
]

{ #category : #private }
RmRemoteRunner >> trySuccess: line [
	| answer |

	(self isResult: line) ifFalse: [ ^ false ].
	
	answer := self materializeLine: line.
	self pushSuccess: answer.

	^ true
]

{ #category : #'private - channels' }
RmRemoteRunner >> writeChannel [
		
	^ writeChannel
]
