Class {
	#name : #RmCommandTest,
	#superclass : #RmTestCase,
	#instVars : [
		'command',
		'worker'
	],
	#category : #'PharoRI-Tests'
}

{ #category : #testing }
RmCommandTest class >> isAbstract [

	^ super isAbstract or: [ self = RmCommandTest ]
]

{ #category : #asserting }
RmCommandTest >> assertResult: anObject [

	self assert: anObject
]

{ #category : #accessing }
RmCommandTest >> command [

	^ command
]

{ #category : #accessing }
RmCommandTest >> commandToTest [

	^ self subclassResponsibility
]

{ #category : #accessing }
RmCommandTest >> runner [

	^ worker
]

{ #category : #running }
RmCommandTest >> setUp [

	super setUp.
	worker := RmRemoteWorkerMock new.
	command := self commandToTest new.
	self setUpCommand
]

{ #category : #running }
RmCommandTest >> setUpCommand [
]

{ #category : #tests }
RmCommandTest >> testExecute [
	| result |

	result := self command executeOn: self runner.
	self assertResult: result
]
