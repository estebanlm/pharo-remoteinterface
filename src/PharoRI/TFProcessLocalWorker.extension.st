Extension { #name : #TFProcessLocalWorker }

{ #category : #'*PharoRI' }
TFProcessLocalWorker class >> use: aWorker during: aBlock [
	| oldWorker |
	
	oldWorker := self worker.
	self worker: aWorker.
	^ aBlock ensure: [ 
		self worker: oldWorker ]
]

{ #category : #'*PharoRI' }
TFProcessLocalWorker class >> useSameThreadDuring: aBlock [ 

	^ self 
		use: TFSameThreadRunner uniqueInstance
		during: aBlock
]
