"
An specialised answer to return an error (which will be fuelised)
"
Class {
	#name : #RmErrorAnswer,
	#superclass : #RmAnswer,
	#category : #'PharoRI-Commands'
}

{ #category : #accessing }
RmErrorAnswer >> value [

	^ FLMaterializer new 
    disableMethodChangedWarning;
    onStream: super value readStream;
    materializeRoot
]

{ #category : #accessing }
RmErrorAnswer >> value: anError [

	super value: (FLSerializer serializeToByteArray: anError)
]
