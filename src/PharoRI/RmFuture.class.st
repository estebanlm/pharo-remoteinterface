Class {
	#name : #RmFuture,
	#superclass : #Object,
	#instVars : [
		'worker',
		'successBlock',
		'errorBlock',
		'command',
		'status',
		'success',
		'value',
		'abortBlock'
	],
	#category : #'PharoRI-Base'
}

{ #category : #'instance creation' }
RmFuture class >> newWorker: aWorker command: aCommand [

	^ self basicNew
		initializeWorker: aWorker command: aCommand;
		yourself
]

{ #category : #execution }
RmFuture >> abort [

	abortBlock ifNil: [ ^ self ].
	abortBlock value
]

{ #category : #execution }
RmFuture >> execute [

	worker sendCommand: command
]

{ #category : #private }
RmFuture >> finishSuccess: aBoolean [

	status := #finished.
	success := aBoolean
]

{ #category : #accessing }
RmFuture >> id [

	^ command id
]

{ #category : #initialization }
RmFuture >> initialize [

	super initialize.
	status := #waiting.
	success := false.
]

{ #category : #initialization }
RmFuture >> initializeWorker: aWorker command: aCommand [

	self initialize.
	worker := aWorker. 
	command := aCommand.
	
]

{ #category : #testing }
RmFuture >> isError [
	
	^ self isSuccess not
]

{ #category : #testing }
RmFuture >> isFinished [
	
	^ status = #finished
]

{ #category : #testing }
RmFuture >> isSuccess [
	
	^ success
]

{ #category : #testing }
RmFuture >> isWaiting [
	
	^ status = #waiting
]

{ #category : #accessing }
RmFuture >> onAbort: aBlock [

	abortBlock := aBlock
]

{ #category : #accessing }
RmFuture >> onError: aBlock [

	errorBlock := aBlock
]

{ #category : #accessing }
RmFuture >> onSuccess: aBlock [

	successBlock := aBlock
]

{ #category : #execution }
RmFuture >> resolveAsError: anError [

	self finishSuccess: false.
	value := nil.

	errorBlock ifNil: [ 
		('Error received without handler: {1}' format: { anError }) crTrace.
		^ self ].
	errorBlock cull: anError
]

{ #category : #execution }
RmFuture >> resolveAsSuccess: result [

	self finishSuccess: true.
	value := result.

	successBlock ifNil: [ ^ self ].
	successBlock cull: result
]

{ #category : #accessing }
RmFuture >> value [
	"answer the result value of a finished in success future. 
	 otherwise it will answer nil"

	^ value
]
