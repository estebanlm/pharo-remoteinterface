Class {
	#name : #RmRunnerPresenter,
	#superclass : #StPresenter,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'clearButton',
		'detailText',
		'announcementList',
		'inspectButton'
	],
	#category : #'PharoRI-GUI'
}

{ #category : #'instance creation' }
RmRunnerPresenter class >> open [
	<script>
	
	self new open
]

{ #category : #initialization }
RmRunnerPresenter >> connectPresenters [

	announcementList 
		transmitTo: detailText
		transform: [ :ann | 
			ann 
				ifNotNil: [ ann signal printString ]
				ifNil: [ '' ] ]
]

{ #category : #'api - focus' }
RmRunnerPresenter >> defaultKeyboardFocus [
	
	^ announcementList
]

{ #category : #layout }
RmRunnerPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: (SpBoxLayout newHorizontal
				borderWidth: 3;
				spacing: 3;
				addLast: inspectButton expand: false;
				addLast: clearButton expand: false;
				yourself) 
			expand: false;
		add: (SpPanedLayout newVertical
			add: announcementList;
			add: detailText;
			yourself);
		yourself
]

{ #category : #actions }
RmRunnerPresenter >> doClear [

	self model removeAll.
	self updatePresenter
]

{ #category : #actions }
RmRunnerPresenter >> doInspect [
	| line object |

	line := announcementList selectedItem signal target.
	object := RmPeerToPeer materializeLine: (line copyAfter: Character space).
	self application tools inspector inspect: object
]

{ #category : #initialization }
RmRunnerPresenter >> initializePresenters [

	inspectButton := self newButton
		label: 'Inspect';
		action: [ self doInspect ];
		yourself.
	clearButton := self newButton
		label: 'Clear';
		action: [ self doClear ];
		yourself.

	announcementList := self newTable
		beResizable;
		addColumn: ((SpStringTableColumn title: 'Worker' evaluated: #runnerId) width: 200);
		addColumn: (SpStringTableColumn title: 'Log' evaluated: #line);
		yourself.
		
	detailText := self newText
		beNotEditable;
		beWrapWord;
		yourself
]

{ #category : #initialization }
RmRunnerPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: 'Remote worker monitor';
		initialExtent: 800@400;
		whenOpenedDo: [ self subscribeToAnnouncements ];
		whenClosedDo: [ self unsubscribeFromAnnouncers ]
]

{ #category : #initialization }
RmRunnerPresenter >> subscribeToAnnouncements [

	RmRemoteRunner logAnnouncer 
		when: RmRemoteSignalAnnouncement 
		send: #updateList:
		to: self
]

{ #category : #initialization }
RmRunnerPresenter >> unsubscribeFromAnnouncers [

	RmRemoteRunner logAnnouncer unsubscribe: self
]

{ #category : #initialization }
RmRunnerPresenter >> updatePresenter [

	(self model isNil or: [ self model hasAnnouncements not ]) 
		ifTrue: [  
			announcementList items: #().
			^ self ].

	announcementList updateItemsKeepingSelection: self model announcements.
	announcementList 
		selectIndex: self model announcements size 
		scrollToSelection: true
]
