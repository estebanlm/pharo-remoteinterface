Class {
	#name : #RmRemoteWorkerMock,
	#superclass : #RmRemoteWorker,
	#category : #'PharoRI-Tests'
}

{ #category : #private }
RmRemoteWorkerMock >> launchReadListener [
	"nothing"
]

{ #category : #'instance creation' }
RmRemoteWorkerMock >> newStdin [

	^ String new writeStream
]

{ #category : #'instance creation' }
RmRemoteWorkerMock >> newStdout [

	^ RmOutputStreamMock new
]
