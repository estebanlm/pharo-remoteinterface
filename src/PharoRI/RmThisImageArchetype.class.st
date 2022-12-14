Class {
	#name : #RmThisImageArchetype,
	#superclass : #RmWorkerArchetype,
	#category : #'PharoRI-Runner'
}

{ #category : #accessing }
RmThisImageArchetype >> imageName [

	^ FileLocator image fullName
]

{ #category : #starting }
RmThisImageArchetype >> workerStartedOn: aRunner [

	aRunner launchSynchronizationListener
]
