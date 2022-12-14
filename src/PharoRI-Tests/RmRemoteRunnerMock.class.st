Class {
	#name : #RmRemoteRunnerMock,
	#superclass : #RmRemoteRunner,
	#category : #'PharoRI-Tests'
}

{ #category : #initialization }
RmRemoteRunnerMock >> initialize [

	super initialize.
	readChannel := RmOutputStreamMock new.
	writeChannel := RmOutputStreamMock new
]
