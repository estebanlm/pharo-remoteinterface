Extension { #name : #BlockClosure }

{ #category : #'*PharoRI' }
BlockClosure >> asPmiCommand [

	^ RmEvaluate do: self
]

{ #category : #'*PharoRI' }
BlockClosure >> stonOn: stonWriter [
	RmBlockClosureWriter ston: self on: stonWriter
]
