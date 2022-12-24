Class {
	#name : #RmRemoteRunnerAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'#runner => WeakSlot'
	],
	#category : #'PharoRI-Runner'
}

{ #category : #initialization }
RmRemoteRunnerAnnouncement >> initialize [
	
	self class initializeSlots: self.
	super initialize.
]

{ #category : #accessing }
RmRemoteRunnerAnnouncement >> runner [

	^ runner
]

{ #category : #accessing }
RmRemoteRunnerAnnouncement >> runner: anObject [

	runner := anObject
]
