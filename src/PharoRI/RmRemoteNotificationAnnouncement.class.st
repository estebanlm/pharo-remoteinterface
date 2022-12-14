Class {
	#name : #RmRemoteNotificationAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'value'
	],
	#category : #'PharoRI-Base'
}

{ #category : #'instance creation' }
RmRemoteNotificationAnnouncement class >> newValue: anObject [

	^ self new value: anObject
]

{ #category : #accessing }
RmRemoteNotificationAnnouncement >> value [

	^ value
]

{ #category : #accessing }
RmRemoteNotificationAnnouncement >> value: anObject [

	value := anObject
]
