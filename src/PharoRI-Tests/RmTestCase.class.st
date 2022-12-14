Class {
	#name : #RmTestCase,
	#superclass : #TestCase,
	#category : #'PharoRI-Tests'
}

{ #category : #testing }
RmTestCase class >> isAbstract [

	^ super isAbstract or: [ self = RmTestCase ]
]
