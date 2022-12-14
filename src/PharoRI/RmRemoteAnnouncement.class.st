Class {
	#name : #RmRemoteAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'answer'
	],
	#category : #'PharoRI-Base'
}

{ #category : #'instance creation' }
RmRemoteAnnouncement class >> newAnswer: anAnswer [

	^ self new answer: anAnswer
]

{ #category : #accessing }
RmRemoteAnnouncement >> answer [

	^ answer
]

{ #category : #accessing }
RmRemoteAnnouncement >> answer: anObject [

	answer := anObject
]
