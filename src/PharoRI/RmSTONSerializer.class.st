Class {
	#name : #RmSTONSerializer,
	#superclass : #SignalSerializer,
	#category : #'PharoRI-Base'
}

{ #category : #serializing }
RmSTONSerializer >> serializeSignal: aSignal logger: aLogger [

	^ STON toString: aSignal
]

{ #category : #serializing }
RmSTONSerializer >> serializeSignal: aSignal on: aStream logger: aLogger [

	STON put: aSignal onStream: aStream.
	aStream cr
]
