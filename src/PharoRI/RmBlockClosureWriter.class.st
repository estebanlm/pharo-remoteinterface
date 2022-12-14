"
This is just a simple hack for ston to support basic clean blocks.
"
Class {
	#name : #RmBlockClosureWriter,
	#superclass : #Object,
	#instVars : [
		'string'
	],
	#category : #'PharoRI-STON'
}

{ #category : #'instance creation' }
RmBlockClosureWriter class >> fromSton: stonReader [

	^ (super fromSton: stonReader) block
]

{ #category : #'instance creation' }
RmBlockClosureWriter class >> ston: aBlock on: stonWriter [
	
	aBlock isClean
		ifFalse: [ stonWriter writeNull ]
		ifTrue: [ 
			self new
				string: aBlock sourceNode value sourceCode;
				stonOn: stonWriter ]
]

{ #category : #accessing }
RmBlockClosureWriter >> block [

	^ self class evaluate: string
]

{ #category : #accessing }
RmBlockClosureWriter >> string: aStringRepresentation [

	string := aStringRepresentation
]
