"
An aswer contains the result of a command, identified by the id of the command it is anwering.

command id = answer id 


"
Class {
	#name : #RmAnswer,
	#superclass : #Object,
	#instVars : [
		'id',
		'value'
	],
	#category : #'PharoRI-Commands'
}

{ #category : #'instance creation' }
RmAnswer class >> newValue: anObject [

	^ self new 
		value: anObject;
		yourself
]

{ #category : #converting }
RmAnswer >> asPmiAnswer [

	^ self
]

{ #category : #accessing }
RmAnswer >> id [

	^ id
]

{ #category : #accessing }
RmAnswer >> id: anObject [

	id := anObject
]

{ #category : #accessing }
RmAnswer >> value [

	^ value
]

{ #category : #accessing }
RmAnswer >> value: anObject [

	value := anObject
]
