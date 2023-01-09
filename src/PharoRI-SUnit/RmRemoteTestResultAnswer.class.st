Class {
	#name : #RmRemoteTestResultAnswer,
	#superclass : #RmAnswer,
	#category : #'PharoRI-SUnit-Commands'
}

{ #category : #'instance creation' }
RmRemoteTestResultAnswer class >> newValue: aRemoteTestResult [

	^ self new value: aRemoteTestResult
]

{ #category : #accessing }
RmRemoteTestResultAnswer >> value: aRemoteTestResult [

	aRemoteTestResult errorTraces copy 
		keysAndValuesDo: [ :testCase :error |
			 aRemoteTestResult errorTraces 
				at: testCase 
				put: (FLSerializer serializeToByteArray: error) ].
	aRemoteTestResult failureTraces removeAll.

	super value: aRemoteTestResult
	
]
