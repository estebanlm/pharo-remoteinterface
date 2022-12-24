Class {
	#name : #RmRemoteSignalAnnouncement,
	#superclass : #RmRemoteRunnerAnnouncement,
	#instVars : [
		'signal'
	],
	#category : #'PharoRI-Runner'
}

{ #category : #accessing }
RmRemoteSignalAnnouncement >> line [

	^ self signal printString
]

{ #category : #parsing }
RmRemoteSignalAnnouncement >> parseSignal: aString [

	signal := [ 
			STON fromString: aString ]
		on: Error do: [ :e | 
			StringSignal new
				message: aString;
				yourself ]
]

{ #category : #accessing }
RmRemoteSignalAnnouncement >> runnerId [

	^ self runner id
]

{ #category : #accessing }
RmRemoteSignalAnnouncement >> signal [

	^ signal
]

{ #category : #accessing }
RmRemoteSignalAnnouncement >> signal: anObject [

	signal := anObject
]
