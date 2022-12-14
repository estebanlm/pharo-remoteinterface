"
An archetype that defines ""this"" image as the worker image. 
The image will be started and after that will be kept in sync using the epicea monitor to transmit changes to the worker image (See `RmThisImageArchetype>>#workerStartedOn:`)
"
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
