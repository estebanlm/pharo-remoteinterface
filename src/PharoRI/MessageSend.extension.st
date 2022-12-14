Extension { #name : #MessageSend }

{ #category : #'*PharoRI' }
MessageSend >> asPmiCommand [

	^ RmEvaluate do: self
]
