Class {
	#name : #RmBaseRunnerModel,
	#superclass : #Object,
	#instVars : [
		'announcements'
	],
	#category : #'PharoRI-GUI'
}

{ #category : #accessing }
RmBaseRunnerModel >> announcements [

	^ announcements
]

{ #category : #testing }
RmBaseRunnerModel >> hasAnnouncements [
	
	^ announcements notEmpty
]

{ #category : #accessing }
RmBaseRunnerModel >> iconName [

	^ nil
]

{ #category : #initialization }
RmBaseRunnerModel >> initialize [
	
	super initialize.
	announcements := OrderedCollection new
]

{ #category : #accessing }
RmBaseRunnerModel >> label [
	
	^ self subclassResponsibility
]

{ #category : #accessing }
RmBaseRunnerModel >> maybeAdd: anAnnouncement [

	self subclassResponsibility
]

{ #category : #removing }
RmBaseRunnerModel >> removeAll [
	
	announcements removeAll
]
