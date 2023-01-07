Extension { #name : #Warning }

{ #category : #'*PharoRI-SUnit' }
Warning >> remoteSUnitAnnounce: aTestCase toResult: aTestResult [
	
	aTestResult addFailure: aTestCase failure: self
]
