Class {
	#name : #RmRemotePoolWorker,
	#superclass : #RmRemoteWorker,
	#instVars : [
		'scheduler',
		'mutex',
		'poolSize'
	],
	#category : #'PharoRI-Worker'
}

{ #category : #defaults }
RmRemotePoolWorker class >> defaultPoolSize [

	^ 1
]

{ #category : #initialization }
RmRemotePoolWorker >> initialize [

	super initialize.
	mutex := Mutex new
]

{ #category : #accessing }
RmRemotePoolWorker >> poolSize [

	^ poolSize ifNil: [ poolSize := self class defaultPoolSize ]
]

{ #category : #accessing }
RmRemotePoolWorker >> poolSize: aNumber [

	poolSize := aNumber
]

{ #category : #private }
RmRemotePoolWorker >> processCommand: aString [

	scheduler schedule: [ super processCommand: aString ]
]

{ #category : #starting }
RmRemotePoolWorker >> start [

	self startScheduler.
	super start
]

{ #category : #private }
RmRemotePoolWorker >> startScheduler [
	
	scheduler := TKTWorkerPool new.
	scheduler poolMaxSize: self poolSize.
	scheduler start
]

{ #category : #starting }
RmRemotePoolWorker >> stop [ 

	self stopScheduler.
	super stop
]

{ #category : #private }
RmRemotePoolWorker >> stopScheduler [
	
	scheduler stop.
	scheduler := nil
]

{ #category : #writing }
RmRemotePoolWorker >> writeAnswer: aType object: anObject [

	^ mutex critical: [ 
		super writeAnswer: aType object: anObject ]
]
