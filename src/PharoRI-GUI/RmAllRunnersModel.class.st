Class {
	#name : #RmAllRunnersModel,
	#superclass : #RmBaseRunnerModel,
	#category : #'PharoRI-GUI'
}

{ #category : #accessing }
RmAllRunnersModel >> label [
	
	^ '<All>'
]

{ #category : #accessing }
RmAllRunnersModel >> maybeAdd: anAnnouncement [

	announcements add: anAnnouncement
]
