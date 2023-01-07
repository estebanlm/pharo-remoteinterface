"
A command that will execute a test case in the remote worker, informing its results.
Notice runing a test suite will also trigger notifications for each test ran. This notifications can be read by listening to the worker announcer: 

```
worker := RmRemoteRunner new.
worker spawn.

worker announcer 
	when: TestAnnouncement 
	do: [ :ann | ann crTrace ].

worker runTest: myTestCase
```
"
Class {
	#name : #RmRunTestCase,
	#superclass : #RmCommand,
	#instVars : [
		'testCase'
	],
	#category : #'PharoRI-SUnit-Commands'
}

{ #category : #execution }
RmRunTestCase >> execute [
	"return test result"

	^ RmRunnerExecutionEnvironment inWorkerDuring: [
		RmRemoteTestSuite new 
			when: TestAnnouncement do: [ :ann | runner notify: ann ];
			addTest: self testCase;
			run ]
]

{ #category : #accessing }
RmRunTestCase >> testCase [

	^ testCase
]

{ #category : #accessing }
RmRunTestCase >> testCase: aTestCase [

	testCase := aTestCase
]
