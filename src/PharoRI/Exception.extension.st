Extension { #name : #Exception }

{ #category : #'*PharoRI' }
Exception >> asPmiAnswer [

	^ RmErrorAnswer newValue: self
]

{ #category : #'*PharoRI' }
Exception >> isException [
	^ true
]

{ #category : #'*PharoRI' }
Exception >> stonOn: aWriter [
	| csignalContext chandlerContext couterContext |

	csignalContext := signalContext.
	chandlerContext := handlerContext.
	couterContext := outerContext.
	signalContext := nil.
	handlerContext := nil.
	outerContext := nil.
	super stonOn: aWriter.
	signalContext := csignalContext.
	handlerContext := chandlerContext.
	outerContext := couterContext
]
