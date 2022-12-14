"
A simple object that generates unique ids (by session) to be used while exchanging commands and answers etween workers. 
"
Class {
	#name : #RmCommandIdGenerator,
	#superclass : #Object,
	#instVars : [
		'nextId',
		'mutex'
	],
	#classVars : [
		'Current'
	],
	#classInstVars : [
		'session'
	],
	#category : #'PharoRI-Commands'
}

{ #category : #'instance creation' }
RmCommandIdGenerator class >> current [

	self validateSession.
	^ Current ifNil: [ Current := self new ]
]

{ #category : #'instance creation' }
RmCommandIdGenerator class >> reset [

	Current := nil
]

{ #category : #private }
RmCommandIdGenerator class >> validateSession [
	
	session = Smalltalk session ifTrue: [ ^ self ].
	
	session := Smalltalk session.
	Current := nil
]

{ #category : #initialization }
RmCommandIdGenerator >> initialize [

	super initialize. 
	mutex := Mutex new.
	nextId := 0.
]

{ #category : #accessing }
RmCommandIdGenerator >> nextId [

	^ mutex critical: [ 
		nextId := nextId + 1 ]
]
