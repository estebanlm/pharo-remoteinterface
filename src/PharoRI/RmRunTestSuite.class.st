"
A command that will execute a test suite in the remote worker, informing its results.
Notice runing a test suite will also trigger notifications for each test ran. This notifications can be read by listening to the worker announcer: 

```
worker := RmRemoteRunner new.
worker spawn.

worker announcer 
	when: TestAnnouncement 
	do: [ :ann | ann crTrace ].

worker runSuite: myTestSuite
```
"
Class {
	#name : #RmRunTestSuite,
	#superclass : #RmCommand,
	#instVars : [
		'suite'
	],
	#category : #'PharoRI-Commands'
}

{ #category : #execution }
RmRunTestSuite >> execute [
	"return test result"

	^ RmRunnerExecutionEnvironment inWorkerDuring: [ 
		self suite 
			when: TestAnnouncement do: [ :ann | runner notify: ann ];
			run ]
]

{ #category : #accessing }
RmRunTestSuite >> suite [

	^ suite
]

{ #category : #accessing }
RmRunTestSuite >> suite: aTestSuite [

	suite := aTestSuite
]
