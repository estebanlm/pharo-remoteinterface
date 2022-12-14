Class {
	#name : #RmRemoteWorkerFinalizer,
	#superclass : #Object,
	#instVars : [
		'worker'
	],
	#category : #'PharoRI-DrTests'
}

{ #category : #'instance creation' }
RmRemoteWorkerFinalizer class >> newWorker: aWorker [

	^ self new worker: aWorker
]

{ #category : #finalization }
RmRemoteWorkerFinalizer >> finalize [

	(worker isNil or: [ worker isRunning not ]) ifTrue: [ ^ self ].
	worker quit
]

{ #category : #initialization }
RmRemoteWorkerFinalizer >> initialize [
	
	self class initializeSlots: self.
	super initialize.
]

{ #category : #accessing }
RmRemoteWorkerFinalizer >> worker [

	^ worker
]

{ #category : #accessing }
RmRemoteWorkerFinalizer >> worker: aWorker [

	worker := aWorker copy
]
