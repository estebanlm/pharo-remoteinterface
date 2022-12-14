Class {
	#name : #RmOutputStreamMock,
	#superclass : #Stream,
	#instVars : [
		'stream'
	],
	#category : #'PharoRI-Tests'
}

{ #category : #'instance creation' }
RmOutputStreamMock class >> new [

	^ self basicNew initialize
]

{ #category : #testing }
RmOutputStreamMock >> atEnd [
	"Answer whether the receiver can access any more objects."

	^ stream atEnd
]

{ #category : #accessing }
RmOutputStreamMock >> contents [
	"Answer all of the contents of the receiver."

	^ stream contents
]

{ #category : #accessing }
RmOutputStreamMock >> flush [

	stream flush
]

{ #category : #initialization }
RmOutputStreamMock >> initialize [

	super initialize.
	stream := String new writeStream
]

{ #category : #accessing }
RmOutputStreamMock >> next [
	"Answer the next object accessible by the receiver."

	^ stream next
]

{ #category : #accessing }
RmOutputStreamMock >> nextPut: anObject [ 
	"Insert the argument, anObject, as the next object accessible by the 
	receiver. Answer anObject."
	
	stream nextPut: anObject
]

{ #category : #accessing }
RmOutputStreamMock >> write: aString [

	self nextPutAll: aString
]

{ #category : #accessing }
RmOutputStreamMock >> writeLine: aString [

	self nextPutAll: aString.
	self nextPutAll: String cr
]
