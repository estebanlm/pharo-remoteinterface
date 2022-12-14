"
The simples command possible, it will evaluate a **clean block** sent to the remote worker.

"
Class {
	#name : #RmEvaluate,
	#superclass : #RmCommand,
	#instVars : [
		'block'
	],
	#category : #'PharoRI-Commands'
}

{ #category : #'instance creation' }
RmEvaluate class >> do: aBlock [

	^ self new block: aBlock
]

{ #category : #accessing }
RmEvaluate >> block [

	^ block
]

{ #category : #accessing }
RmEvaluate >> block: aBlock [

	block := aBlock
]

{ #category : #execution }
RmEvaluate >> execute [

	^ self block value
]
