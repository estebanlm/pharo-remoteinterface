Class {
	#name : #RmCompiledMethodWriter,
	#superclass : #Object,
	#instVars : [
		'methodClassName',
		'selector'
	],
	#category : #'PharoRI-STON'
}

{ #category : #accessing }
RmCompiledMethodWriter >> method [
	
	^ (Smalltalk classNamed: methodClassName) compiledMethodAt: selector asSymbol
]

{ #category : #accessing }
RmCompiledMethodWriter >> methodClassName: aString [

	methodClassName := aString
]

{ #category : #accessing }
RmCompiledMethodWriter >> selector: aString [

	selector := aString
]
