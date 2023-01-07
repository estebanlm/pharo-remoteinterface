Extension { #name : #TestSkipped }

{ #category : #'*PharoRI-SUnit' }
TestSkipped >> remoteSUnitAnnounce: aTestCase toResult: aTestResult [

	aTestResult addSkip: aTestCase
]
