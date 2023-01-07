"
A test suite specialised to be executed remotely.
"
Class {
	#name : #RmRemoteTestSuite,
	#superclass : #TestSuite,
	#category : #'PharoRI-SUnit-Base'
}

{ #category : #'instance creation' }
RmRemoteTestSuite class >> fromSuite: aSuite [
	
 	^ self new 
		fromSuite: aSuite;
		yourself
]

{ #category : #initialization }
RmRemoteTestSuite >> fromSuite: aSuite [
	
	name := aSuite name.
	tests := aSuite tests.
	resources := aSuite resources
]

{ #category : #accessing }
RmRemoteTestSuite >> resultClass [

	^ RmRemoteTestResult
]
