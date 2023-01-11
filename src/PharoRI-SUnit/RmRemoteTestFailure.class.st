"
A test failure exception to handle failures from remote images.
"
Class {
	#name : #RmRemoteTestFailure,
	#superclass : #TestFailure,
	#instVars : [
		'exception'
	],
	#category : #'PharoRI-SUnit-Base'
}

{ #category : #testing }
RmRemoteTestFailure class >> captureIfSignalledWhenStepping [

	^ super captureIfSignalledWhenStepping or: [ self == RmRemoteTestFailure ]
]

{ #category : #signalling }
RmRemoteTestFailure class >> signalForException: anError [

	^ self new
		exception: anError;
		signal
]

{ #category : #accessing }
RmRemoteTestFailure >> exception [

	^ exception
]

{ #category : #accessing }
RmRemoteTestFailure >> exception: anObject [

	exception := anObject
]

{ #category : #notification }
RmRemoteTestFailure >> notifyUserOfCommand: aCommand [

	self exception signalContext stack inspect
]

{ #category : #accessing }
RmRemoteTestFailure >> originException [

	^ self exception
]
