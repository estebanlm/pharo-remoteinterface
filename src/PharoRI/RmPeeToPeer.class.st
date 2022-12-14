Class {
	#name : #RmPeeToPeer,
	#superclass : #Object,
	#traits : 'RmTLogger',
	#classTraits : 'RmTLogger classTrait',
	#pools : [
		'RmConstants'
	],
	#category : #'PharoRI-Base'
}

{ #category : #'private - testing' }
RmPeeToPeer >> isCommand: line [

	^ line beginsWith: COMMAND
]

{ #category : #'private - testing' }
RmPeeToPeer >> isError: line [

	^ line beginsWith: ERROR
]

{ #category : #'private - testing' }
RmPeeToPeer >> isNotify: line [

	^ line beginsWith: NOTIFY
]

{ #category : #'private - testing' }
RmPeeToPeer >> isResult: line [

	^ line beginsWith: RESULT
]

{ #category : #'private - serializing' }
RmPeeToPeer >> materialize: aString [

	^ STON fromString: aString
]

{ #category : #'private - serializing' }
RmPeeToPeer >> materializeLine: aLine [

	^ self materialize: (self removeMarker: aLine)
]

{ #category : #private }
RmPeeToPeer >> removeMarker: aLine [

	^ aLine allButFirst: MARKER_SIZE
]

{ #category : #'private - serializing' }
RmPeeToPeer >> serialize: anObject [
	
	^ STON toString: anObject
]
