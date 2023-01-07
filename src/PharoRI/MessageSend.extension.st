Extension { #name : #MessageSend }

{ #category : #'*PharoRI' }
MessageSend >> asRmCommand [

	^ RmEvaluate do: self
]
