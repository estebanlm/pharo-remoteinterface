Class {
	#name : #RmEvaluateTest,
	#superclass : #RmCommandTest,
	#category : #'PharoRI-Tests'
}

{ #category : #accessing }
RmEvaluateTest >> commandToTest [

	^ RmEvaluate
]

{ #category : #initialization }
RmEvaluateTest >> setUpCommand [

	command block: [ true ]
]
