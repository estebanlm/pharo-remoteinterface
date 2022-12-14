Extension { #name : #Object }

{ #category : #'*PharoRI' }
Object >> asPmiAnswer [

	^ RmAnswer newValue: self
]

{ #category : #'*PharoRI' }
Object >> asPmiNotification [

	^ RmRemoteNotificationAnnouncement newValue: self
]

{ #category : #'*PharoRI' }
Object >> emit [

	self asBeaconSignal emit
]

{ #category : #'*PharoRI' }
Object >> isException [ 
	^ false
]

{ #category : #'*PharoRI' }
Object >> stonOn: stonWriter [
	"Encode non-variable classes with a map of their instance variable and values.
	Override to customize and add a matching #fromSton: (see implementors)."

	self class isVariable
		ifTrue: [ stonWriter writeNull ]
		ifFalse: [ stonWriter writeObject: self ]
]
