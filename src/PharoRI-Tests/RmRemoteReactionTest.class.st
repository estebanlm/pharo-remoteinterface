Class {
	#name : #RmRemoteReactionTest,
	#superclass : #TestCase,
	#category : #'PharoRI-Tests'
}

{ #category : #tests }
RmRemoteReactionTest >> testUnexpectedTermination [
	| worker |

	worker := RmRemoteRunner new.
	worker spawn.
	
	self assert: worker isRunning.
	self 
		should: [ worker runCommand: [ Smalltalk quitPrimitive ] ]
		raise: Error.
	self deny: worker isRunning.
	self deny: worker isAlive
]
