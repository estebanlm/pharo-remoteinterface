Extension { #name : #RmRemoteRunner }

{ #category : #'*PharoRI-SUnit' }
RmRemoteRunner >> runSuite: suite [

	^ self runCommand: (RmRunTestSuite new 
		suite: suite;
		yourself)
]

{ #category : #'*PharoRI-SUnit' }
RmRemoteRunner >> runTest: aTestCase [

	^ self runCommand: (RmRunTestCase new 
		testCase: aTestCase;
		yourself) 
]
