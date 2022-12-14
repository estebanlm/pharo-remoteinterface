Class {
	#name : #RmWorkerArchetype,
	#superclass : #Object,
	#instVars : [
		'arguments'
	],
	#pools : [
		'GSpawnFlags'
	],
	#category : #'PharoRI-Runner'
}

{ #category : #'accessing - arguments' }
RmWorkerArchetype >> addFlag: aString [

	(self arguments includes: aString) ifTrue: [ ^ self ].
	self arguments add: aString
	
	
]

{ #category : #'accessing - arguments' }
RmWorkerArchetype >> arguments [
		
	arguments ifNotNil: [ ^ arguments ].
	
	arguments := OrderedCollection new.
	arguments add: '--worker'.
	arguments add: self imageName.
	arguments add: 'mi'.
	arguments add: 'start'.
	
	^ arguments
]

{ #category : #accessing }
RmWorkerArchetype >> imageName [
		
	^ self subclassResponsibility
]

{ #category : #'accessing - arguments' }
RmWorkerArchetype >> interactive [

	self addFlag: '--interactive'
]

{ #category : #'accessing - arguments' }
RmWorkerArchetype >> logToStderr [

	self addFlag: '--logToStderr'
]

{ #category : #'accessing - arguments' }
RmWorkerArchetype >> poolSize: aNumber [

	self addFlag: ('--poolSize={1}' format: { aNumber })
]

{ #category : #starting }
RmWorkerArchetype >> runnerStarted: aRunner [
]

{ #category : #starting }
RmWorkerArchetype >> spawn [

	^ TFProcessLocalWorker useSameThreadDuring: [ 
		GIOPipedProcess 
			spawn: (FileLocator vmDirectory parent / 'pharo') fullName
			arguments: self arguments asArray
			flags: G_SPAWN_DEFAULT ]
]

{ #category : #starting }
RmWorkerArchetype >> workerStartedOn: aRunner [
	"this is executed after spawning a worker"
]
