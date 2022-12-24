"
A command that will replay in worker an epicea entry generated on the main image.
"
Class {
	#name : #RmReplay,
	#superclass : #RmCommand,
	#instVars : [
		'entry'
	],
	#category : #'PharoRI-Commands'
}

{ #category : #'instance creation' }
RmReplay class >> newEntry: anEntry [

	^ self new
		entry: anEntry;
		yourself
]

{ #category : #accessing }
RmReplay >> entry [

	^ entry
]

{ #category : #accessing }
RmReplay >> entry: anObject [

	entry := anObject
]

{ #category : #execution }
RmReplay >> execute [

	[ 'Replying: {1}' format: { self entry } ] emit.
	SystemAnnouncer uniqueInstance suspendAllWhile: [
		EpMonitor disableDuring: [ 
			self entry content applyCodeChange.	
		] 
	].

	^ true
]
