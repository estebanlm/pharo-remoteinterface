Class {
	#name : #RmRunnerModel,
	#superclass : #RmBaseRunnerModel,
	#instVars : [
		'#runner => WeakSlot'
	],
	#category : #'PharoRI-GUI'
}

{ #category : #'instance creation' }
RmRunnerModel class >> on: aRunner [

	^ self new runner: aRunner
]

{ #category : #accessing }
RmRunnerModel >> disableLogging [

	runner startListenToLog
]

{ #category : #accessing }
RmRunnerModel >> enableLogging [

	runner startListenToLog
]

{ #category : #accessing }
RmRunnerModel >> iconName [

	^ self runner isRunning
		ifTrue: [ #testGreen ]
		ifFalse: [ #testRed ]
]

{ #category : #initialization }
RmRunnerModel >> initialize [
	
	self class initializeSlots: self.
	super initialize.
]

{ #category : #testing }
RmRunnerModel >> isRunning [
	
	^ runner isRunning 
]

{ #category : #accessing }
RmRunnerModel >> label [
	
	^ self runner id
]

{ #category : #accessing }
RmRunnerModel >> maybeAdd: anAnnouncement [

	anAnnouncement runner == self runner ifFalse: [ ^ self ].
	announcements add: anAnnouncement
]

{ #category : #accessing }
RmRunnerModel >> runner [

	^ runner
]

{ #category : #accessing }
RmRunnerModel >> runner: anObject [

	runner := anObject
]

{ #category : #accessing }
RmRunnerModel >> stop [
	
	runner quit
]
