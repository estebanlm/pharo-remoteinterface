"
A command to be executed in a remote worker
"
Class {
	#name : #RmCommand,
	#superclass : #Object,
	#instVars : [
		'id',
		'runner'
	],
	#category : #'PharoRI-Commands'
}

{ #category : #accessing }
RmCommand class >> nextId [

	^ RmCommandIdGenerator current nextId
]

{ #category : #converting }
RmCommand >> asRmCommand [

	^ self
]

{ #category : #execution }
RmCommand >> execute [

	self subclassResponsibility
]

{ #category : #execution }
RmCommand >> executeOn: aRunner [

	runner := aRunner.
	^ self execute
]

{ #category : #accessing }
RmCommand >> id [

	^ id
]

{ #category : #initialization }
RmCommand >> initialize [

	super initialize.
	id := self class nextId
]
