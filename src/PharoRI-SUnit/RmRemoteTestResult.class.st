"
A test result specialised to be used in remote images, to answer a bit more information to the host  
"
Class {
	#name : #RmRemoteTestResult,
	#superclass : #TestResult,
	#instVars : [
		'errorTraces',
		'failureTraces'
	],
	#category : #'PharoRI-SUnit-Base'
}

{ #category : #adding }
RmRemoteTestResult >> addError: testCase error: anError [

	self addError: testCase.
	self errorTraces
		at: testCase 
		put: anError asRmAnswer
]

{ #category : #adding }
RmRemoteTestResult >> addFailure: testCase failure: aFailure [

	self addFailure: testCase.
	self failureTraces
		at: testCase 
		put: aFailure
]

{ #category : #accessing }
RmRemoteTestResult >> errorTraces [

	^ errorTraces ifNil: [ errorTraces := Dictionary new ]
]

{ #category : #accessing }
RmRemoteTestResult >> failureTraces [

	^ failureTraces ifNil: [ failureTraces := Dictionary new ]
]

{ #category : #running }
RmRemoteTestResult >> runCase: aTestCase [
	
	[
		aTestCase announce: TestCaseStarted withResult: self.
		aTestCase runCaseManaged.
		aTestCase announce: TestCaseEnded  withResult: self.
		self addPass: aTestCase ]
	on: self class failure, self class skip, self class warning, self class error
	do: [ :e | e remoteSUnitAnnounce: aTestCase toResult: self ]
]

{ #category : #running }
RmRemoteTestResult >> runCaseForDebug: aTestCase [
	
	[
		aTestCase announce: TestCaseStarted withResult: self.
		aTestCase runCaseManaged.
		aTestCase announce: TestCaseEnded  withResult: self.
		"To not affect performance of big test suites following logic is not inside addPass: method"
		errors remove: aTestCase ifAbsent: [].
		failures remove: aTestCase ifAbsent: [].
		self addPass: aTestCase ]
	on: self class failure, self class skip, self class warning, self class error
	do: [ :e | 
		e remoteSUnitAnnounce: aTestCase toResult: self. 
		e pass ]
]
