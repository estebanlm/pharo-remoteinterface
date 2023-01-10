Class {
	#name : #RmRemoteTestResultAnswer,
	#superclass : #RmAnswer,
	#category : #'PharoRI-SUnit-Commands'
}

{ #category : #'instance creation' }
RmRemoteTestResultAnswer class >> newValue: aRemoteTestResult [

	^ self new value: aRemoteTestResult
]

{ #category : #private }
RmRemoteTestResultAnswer >> materializeValues: aDictionary [

	aDictionary copy keysAndValuesDo: [ :testCase :error |
		aDictionary
			at: testCase
			put: (FLMaterializer new
				disableMethodChangedWarning;
				onStream: error readStream;
				materializeRoot) ]
]

{ #category : #private }
RmRemoteTestResultAnswer >> serializeValues: aDictionary [

	aDictionary copy keysAndValuesDo: [ :testCase :error |
		aDictionary
			at: testCase
			put: (FLSerializer serializeToByteArray: error) ]
]

{ #category : #accessing }
RmRemoteTestResultAnswer >> value [
	| result |

	result := super value.
	self materializeValues: result errorTraces.
	self materializeValues: result failureTraces.

	^ result
]

{ #category : #accessing }
RmRemoteTestResultAnswer >> value: aRemoteTestResult [

	self serializeValues: aRemoteTestResult errorTraces.
	self serializeValues: aRemoteTestResult failureTraces.
	super value: aRemoteTestResult
]
