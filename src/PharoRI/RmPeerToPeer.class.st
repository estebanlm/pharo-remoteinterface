"
An abstract base for runners and workers.
"
Class {
	#name : #RmPeerToPeer,
	#superclass : #Object,
	#pools : [
		'RmConstants'
	],
	#category : #'PharoRI-Base'
}

{ #category : #serializing }
RmPeerToPeer class >> materializeLine: aString [

	^ self basicNew materializeLine: aString
]

{ #category : #'private - testing' }
RmPeerToPeer >> isCommand: line [

	^ line beginsWith: COMMAND
]

{ #category : #'private - testing' }
RmPeerToPeer >> isError: line [

	^ line beginsWith: ERROR
]

{ #category : #'private - testing' }
RmPeerToPeer >> isNotify: line [

	^ line beginsWith: NOTIFY
]

{ #category : #'private - testing' }
RmPeerToPeer >> isResult: line [

	^ line beginsWith: RESULT
]

{ #category : #'private - serializing' }
RmPeerToPeer >> materialize: aString [

	^ STON fromString: aString
]

{ #category : #'private - serializing' }
RmPeerToPeer >> materializeLine: aLine [

	^ self materialize: (self removeMarker: aLine)
]

{ #category : #private }
RmPeerToPeer >> removeMarker: aLine [

	^ aLine allButFirst: MARKER_SIZE
]

{ #category : #'private - serializing' }
RmPeerToPeer >> serialize: anObject [
	
	^ STON toString: anObject
]
