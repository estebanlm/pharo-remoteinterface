Class {
	#name : #RmDrTestsRemoteRunnerPlugin,
	#superclass : #DTTestsRunnerPlugin,
	#instVars : [
		'worker'
	],
	#category : #'PharoRI-DrTests'
}

{ #category : #'api - accessing' }
RmDrTestsRemoteRunnerPlugin class >> pluginName [

	^ 'Remote Tests Runner'
]

{ #category : #'api - accessing' }
RmDrTestsRemoteRunnerPlugin class >> weight [

	^ 1
]

{ #category : #private }
RmDrTestsRemoteRunnerPlugin >> ensureRemoteWorker [

	self isRemoteWorkerRunning ifTrue: [ ^ worker ].

	worker := RmRemoteRunner new.
	worker archetype poolSize: 10.
	worker spawn.

	WeakRegistry default
		add: self
		finalizer: (RmRemoteWorkerFinalizer newWorker: worker).

	^ worker
]

{ #category : #private }
RmDrTestsRemoteRunnerPlugin >> handleTestAnnouncement: ann [
	
	self flag: #TODO. "Dirty"
	ann test class = TestSuite ifTrue: [ 
		self announceStatusChanged: ('Running test {1}.' format: { ann test name }) ]
]

{ #category : #private }
RmDrTestsRemoteRunnerPlugin >> isRemoteWorkerRunning [
	
	^ worker notNil 
		and: [ worker isRunning ]
]

{ #category : #private }
RmDrTestsRemoteRunnerPlugin >> runSuite: testSuite [

	self ensureRemoteWorker.
	self subscribe.
	^ [ (worker runSuite: testSuite) value ] 
		ensure: [ self unsubscribe ].
]

{ #category : #private }
RmDrTestsRemoteRunnerPlugin >> runTestSuites: testSuites [
	| result |

	result := TestAsserter classForTestResult new.
	CurrentExecutionEnvironment runTestsBy: [ 
		testSuites 
			do: [ :testSuite | 
				result mergeWith: (self runSuite: testSuite) ]
			displayingProgress: 'Running Tests' ].
		
	^ result
]

{ #category : #private }
RmDrTestsRemoteRunnerPlugin >> subscribe [
	
	worker announcer
		when: TestAnnouncement 
		send: #handleTestAnnouncement:
		to: self.

]

{ #category : #private }
RmDrTestsRemoteRunnerPlugin >> unsubscribe [
	
	worker announcer unsubscribe: self
]
