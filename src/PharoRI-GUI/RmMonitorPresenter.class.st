Class {
	#name : #RmMonitorPresenter,
	#superclass : #StPresenter,
	#instVars : [
		'listPresenter',
		'announcements'
	],
	#category : #'PharoRI-GUI'
}

{ #category : #'instance creation' }
RmMonitorPresenter class >> open [
	<script>
	
	self new open
]

{ #category : #layout }
RmMonitorPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: listPresenter;
		yourself
]

{ #category : #initialization }
RmMonitorPresenter >> initialize [

	announcements := OrderedCollection new.
	super initialize
]

{ #category : #initialization }
RmMonitorPresenter >> initializePresenter [

	listPresenter := self newTable
		beResizable;
		addColumn: ((SpStringTableColumn title: 'Worker' evaluated: #runnerId) width: 200);
		addColumn: (SpStringTableColumn title: 'Log' evaluated: #line);
		yourself
]

{ #category : #initialization }
RmMonitorPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: 'Remote worker monitor';
		initialExtent: 800@250;
		whenOpenedDo: [ self subscribeToAnnouncements ];
		whenClosedDo: [ self unsubscribeFromAnnouncers ]
]

{ #category : #initialization }
RmMonitorPresenter >> subscribeToAnnouncements [

	RmRemoteRunner logAnnouncer 
		when: RmRemoteSignalAnnouncement 
		send: #updateList:
		to: self
]

{ #category : #initialization }
RmMonitorPresenter >> unsubscribeFromAnnouncers [

	RmRemoteRunner logAnnouncer unsubscribe: self
]

{ #category : #private }
RmMonitorPresenter >> updateList: ann [

	announcements add: ann.
	self updatePresenter
]

{ #category : #initialization }
RmMonitorPresenter >> updatePresenter [

	listPresenter updateItemsKeepingSelection: announcements.
	listPresenter selectIndex: announcements size
]
