"
An error happened in a remote worker, and is preferable to handle it as it, not a regular post-mortem error.
"
Class {
	#name : #RmRemoteError,
	#superclass : #Error,
	#instVars : [
		'remoteError'
	],
	#category : #'PharoRI-Base'
}

{ #category : #accessing }
RmRemoteError >> remoteError [

	^ remoteError
]

{ #category : #accessing }
RmRemoteError >> remoteError: anObject [

	remoteError := anObject
]
