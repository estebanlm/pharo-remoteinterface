"
A command that will end current remote worker execution.
"
Class {
	#name : #RmQuit,
	#superclass : #RmCommand,
	#category : #'PharoRI-Commands'
}

{ #category : #execution }
RmQuit >> execute [

	runner stopFromCommand: self.
	^ true
]
