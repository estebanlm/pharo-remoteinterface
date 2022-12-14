Class {
	#name : #RmRemoteReactionTest,
	#superclass : #TestCase,
	#instVars : [
		'worker'
	],
	#category : #'PharoRI-Tests'
}

{ #category : #running }
RmRemoteReactionTest >> tearDown [

	worker ifNotNil: [ 
		worker forceTerminate ].
	super tearDown
]

{ #category : #tests }
RmRemoteReactionTest >> testRemoteHaltRaisesDebuggerInHost [

	worker := RmRemoteRunner new.
	worker archetype logToStderr. 
	worker spawn.
	worker listenToLog.
	
	self assert: worker isRunning.
	self 
		should: [ worker runCommand: [ Halt now ] ]
		raise: RmRemoteError
]

{ #category : #tests }
RmRemoteReactionTest >> testUnexpectedTermination [

	worker := RmRemoteRunner new.
	worker spawn.

	self assert: worker isRunning.
	self 
		should: [ worker runCommand: [ Smalltalk quitPrimitive ] ]
		raise: Error.
	self deny: worker isRunning.
	self deny: worker isAlive
]
