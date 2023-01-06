"
A remote execution worker. 
It has the job of start listeners (based on `GIOChannel`) and process commands from host image.
"
Class {
	#name : #RmRemoteWorker,
	#superclass : #RmPeerToPeer,
	#instVars : [
		'running',
		'stdin',
		'stdout',
		'quitOnStop',
		'readListener'
	],
	#classVars : [
		'RunningWorker'
	],
	#category : #'PharoRI-Worker'
}

{ #category : #accessing }
RmRemoteWorker class >> start [

	^ self new start 
]

{ #category : #accessing }
RmRemoteWorker class >> startStandalone [

	^ self new 
		quitOnStop: true;		
		start 
]

{ #category : #'ston-core' }
RmRemoteWorker class >> stonAllInstVarNames [
	"In case I serialize an exception... it will end here and I do not want to serialize anything of"
	
	^ #()
]

{ #category : #private }
RmRemoteWorker >> basicHandleLine: aString [ 
	
	(aString size < MARKER_SIZE
		or: [ (self isCommand: aString) not ]) 
		ifTrue: [ self error: ('Invalid command: {1}' format: { aString }) ].
	
	self processCommand: aString
]

{ #category : #private }
RmRemoteWorker >> handleLine: aString [

	aString isEmptyOrNil ifTrue: [ ^ self ].
	
	[ 'Received: ', aString ] emit.
	[ self basicHandleLine: aString ]
	on: Exception
	do: [ :e | self writeError: (e freezeUpTo: thisContext home) ]
]

{ #category : #initialization }
RmRemoteWorker >> initialize [

	super initialize.
	quitOnStop := false.
	running := false
]

{ #category : #testing }
RmRemoteWorker >> isReadListenerRunning [
	
	^ readListener notNil and: [ readListener isRunning ]
]

{ #category : #testing }
RmRemoteWorker >> isRunning [

	^ running
]

{ #category : #private }
RmRemoteWorker >> launchReadListener [

	self isReadListenerRunning ifTrue: [ ^ self ].

	readListener := self stdin 
		newReadLineListener: 'runner_read' 
		receiver: self 
		selector: #handleLine:.
	readListener start
]

{ #category : #'private - factory' }
RmRemoteWorker >> newStdin [

	^ GIOChannel newStdin
]

{ #category : #'private - factory' }
RmRemoteWorker >> newStdout [

	^ GIOChannel newStdout
]

{ #category : #accessing }
RmRemoteWorker >> notify: anObject [

	self writeNotify: anObject
]

{ #category : #private }
RmRemoteWorker >> processCommand: aString [
	| command |

	command := self materializeLine: aString.
	[ 
		self 
			writeResult: (command executeOn: self)
			ofCommand: command ]
	on: Exception
	do: [ :e | 
		self 
			writeError: (e freezeUpTo: thisContext home) 
			ofCommand: command ]
]

{ #category : #accessing }
RmRemoteWorker >> quitOnStop: aBoolean [

	quitOnStop := aBoolean
]

{ #category : #starting }
RmRemoteWorker >> start [ 

	TFProcessLocalWorker useSameThreadDuring: [ 
		running ifTrue: [ ^ self ].
		running := true.
		self stdin.
		self stdout.
		self launchReadListener.
		'Remote runner started' emit ].
	"register worker to avoid GC. This is important! (but there should be just one worker 
	 for images, and in that case we need to register just one"
	RunningWorker := self
]

{ #category : #private }
RmRemoteWorker >> stdin [

	^ stdin ifNil: [ stdin := self newStdin ]
]

{ #category : #private }
RmRemoteWorker >> stdout [

	^ stdout ifNil: [ stdout := self newStdout ]
]

{ #category : #starting }
RmRemoteWorker >> stop [

	self stopFromCommand: nil

]

{ #category : #starting }
RmRemoteWorker >> stopFromCommand: aCommand [

	aCommand ifNotNil: [ 
		self writeResult: true ofCommand: aCommand ].

	quitOnStop ifTrue: [ 
		Smalltalk snapshot: false andQuit: true ].

	TFProcessLocalWorker useSameThreadDuring: [ 
		running := false.
		readListener ifNotNil: [ readListener terminate ].
		self stdin close.
		self stdout close.
		stdin := nil.
		stdout := nil.
		'Runner stopped' emit ].
]

{ #category : #private }
RmRemoteWorker >> writeAnswer: aType object: anObject [
	| line |

	line := self serialize: anObject.
	TFProcessLocalWorker useSameThreadDuring: [ 
		self stdout 
			write: aType;
			writeLine: line;
			flush ].

	[ 'Sent: {1}{2}' format: {  aType. line } ] emit
]

{ #category : #private }
RmRemoteWorker >> writeError: anError [

	self 
		writeAnswer: ERROR 
		object: anError asPmiAnswer
]

{ #category : #private }
RmRemoteWorker >> writeError: anError ofCommand: aCommand [

	self 
		writeAnswer: ERROR 
		object: (anError asPmiAnswer
			id: aCommand id;
			yourself)
]

{ #category : #private }
RmRemoteWorker >> writeNotify: anObject [

	self 
		writeAnswer: NOTIFY 
		object: anObject asPmiNotification
]

{ #category : #private }
RmRemoteWorker >> writeResult: anObject ofCommand: aCommand [

	self 
		writeAnswer: RESULT 
		object: (anObject asPmiAnswer
			id: aCommand id;
			yourself)
]
