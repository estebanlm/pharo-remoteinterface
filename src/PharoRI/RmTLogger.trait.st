Trait {
	#name : #RmTLogger,
	#category : #'PharoRI-Base'
}

{ #category : #logging }
RmTLogger >> log: aValuable [

	aValuable value printToStderr
]
