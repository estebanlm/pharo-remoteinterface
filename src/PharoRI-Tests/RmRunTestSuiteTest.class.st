Class {
	#name : #RmRunTestSuiteTest,
	#superclass : #RmCommandTest,
	#category : #'PharoRI-Tests'
}

{ #category : #accessing }
RmRunTestSuiteTest class >> commandToTest [

	^ RmRunTestSuite	
]

{ #category : #tests }
RmRunTestSuiteTest >> assertResult: aTestResult [

	self assert: aTestResult hasPassed
]

{ #category : #accessing }
RmRunTestSuiteTest >> commandToTest [

	^ RmRunTestSuite
]

{ #category : #initialization }
RmRunTestSuiteTest >> miTest1 [
		
	self assert: true
]

{ #category : #initialization }
RmRunTestSuiteTest >> setUpCommand [

	command suite: (TestSuite new 
		addTest: (self class selector: #miTest1);
		yourself) 
]
