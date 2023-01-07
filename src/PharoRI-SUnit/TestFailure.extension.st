Extension { #name : #TestFailure }

{ #category : #'*PharoRI-SUnit' }
TestFailure >> remoteSUnitAnnounce: aTestCase toResult: aTestResult [
	
	aTestResult addFailure: aTestCase failure: self
]
