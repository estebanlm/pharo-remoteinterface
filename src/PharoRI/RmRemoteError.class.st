"
An error happened in a remote worker, and is preferable to handle it as it, not a regular post-mortem error.
"
Class {
	#name : #RmRemoteError,
	#superclass : #Error,
	#instVars : [
		'exception'
	],
	#category : #'PharoRI-Base'
}

{ #category : #signalling }
RmRemoteError class >> signalForException: anError [

	^ self new
		exception: anError;
		signal
]

{ #category : #accessing }
RmRemoteError >> defaultAction [

	self exception debug
]

{ #category : #accessing }
RmRemoteError >> exception [

	^ exception
]

{ #category : #accessing }
RmRemoteError >> exception: anObject [

	exception := anObject
]
