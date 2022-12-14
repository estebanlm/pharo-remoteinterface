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
RmCommand >> asPmiCommand [

	^ self
]

{ #category : #execution }
RmCommand >> execute [

	self subclassResponsibility
]

{ #category : #execution }
RmCommand >> executeOn: aRunner [

	runner := aRunner.
	"I use my own execution environment because the TestExecutionEnvironment controls 
	 created processes and kills them, and we can screw all the runner environment 
	 (depending on processes like the gtk run loop and that, that can be created while 
	 running a test command)"
	RmRunnerExecutionEnvironment new 
		beActiveDuring: [ ^ self execute ]
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
