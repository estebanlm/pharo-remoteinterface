Extension { #name : #Error }

{ #category : #'*PharoRI-SUnit' }
Error >> remoteSUnitAnnounce: aTestCase toResult: aTestResult [

	aTestResult addError: aTestCase error: self
]
