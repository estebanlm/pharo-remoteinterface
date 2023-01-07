Extension { #name : #BlockClosure }

{ #category : #'*PharoRI' }
BlockClosure >> asRmCommand [

	^ RmEvaluate do: self
]

{ #category : #'*PharoRI' }
BlockClosure >> stonOn: stonWriter [
	RmBlockClosureWriter ston: self on: stonWriter
]
