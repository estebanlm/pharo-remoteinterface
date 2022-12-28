Class {
	#name : #RmRemoteRunnerFinalizer,
	#superclass : #ObjectFinalizer,
	#instVars : [
		'runner'
	],
	#category : #'PharoRI-Runner'
}

{ #category : #'instance creation' }
RmRemoteRunnerFinalizer class >> for: aRunner [

	^ self new 
		runner: aRunner shallowCopy;
		yourself
]

{ #category : #finalization }
RmRemoteRunnerFinalizer >> finalize [

	self runner terminate
]

{ #category : #accessing }
RmRemoteRunnerFinalizer >> runner [

	^ runner
]

{ #category : #accessing }
RmRemoteRunnerFinalizer >> runner: anObject [

	runner := anObject
]
