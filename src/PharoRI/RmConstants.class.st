"
Define constats for the exchange protocol.
"
Class {
	#name : #RmConstants,
	#superclass : #SharedPool,
	#classVars : [
		'COMMAND',
		'ERROR',
		'MARKER_SIZE',
		'NOTIFY',
		'RESULT'
	],
	#category : #'PharoRI-Base'
}

{ #category : #initialization }
RmConstants class >> initialize [

	COMMAND := '-c:'.
	RESULT := '-r:'.
	NOTIFY := '-n:'.
	ERROR := '-e:'.
	MARKER_SIZE := 3
]
