Class {
	#name : #RmRunnerPresenter,
	#superclass : #StPresenter,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'clearButton',
		'detailText',
		'announcementList',
		'inspectButton',
		'stopButton',
		'runnerToolbar',
		'listenButton'
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
				ifNil: [ '' ] ].
			
	self whenSelectionChangedDo: [ self updateSelectionBasedActions ]
]

{ #category : #'api - focus' }
RmRunnerPresenter >> defaultKeyboardFocus [
	
	^ announcementList
]

{ #category : #layout }
RmRunnerPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: (SpBoxLayout newHorizontal
				hAlignEnd;
				add: runnerToolbar;
				yourself) 
			expand: false;
		add: (SpPanedLayout newVertical
			add: announcementList;
			add: detailText;
			yourself);
		yourself
]

{ #category : #private }
RmRunnerPresenter >> disableAllActions [

	^ runnerToolbar items do: [ :each | each enabled: false ]
]

{ #category : #actions }
RmRunnerPresenter >> doClear [

	self model removeAll.
	self updatePresenter
]

{ #category : #actions }
RmRunnerPresenter >> doDisableLogging [

	self model disableLogging
]

{ #category : #actions }
RmRunnerPresenter >> doEnableLogging [

	self model enableLogging
]

{ #category : #actions }
RmRunnerPresenter >> doInspect [
	| line object |

	line := announcementList selectedItem signal target.
	object := RmPeerToPeer materializeLine: (line copyAfter: Character space).
	self application tools inspector inspect: object
]

{ #category : #actions }
RmRunnerPresenter >> doStop [
	
	self model stop
]

{ #category : #initialization }
RmRunnerPresenter >> initializePresenters [

	runnerToolbar := self newToolbar 
		add: (inspectButton := self newToolbarButton
			label: 'Inspect';
			icon: (self iconNamed: #smallInspectIt);
			action: [ self doInspect ];
			yourself);
		add: (clearButton := self newToolbarButton
			label: 'Clear';
			icon: (self iconNamed: #smallDelete);
			help: 'Clear log events';
			action: [ self doClear ];
			yourself);
		add: (listenButton := self newToolbarToggleButton
			label: 'Listen';
			icon: (self iconNamed: #smallVolume);
			help: 'Enable/disable listening to log.';
			state: self model isListening;
			whenActivatedDo: [ self doEnableLogging ];
			whenDeactivatedDo: [ self doDisableLogging ];
			yourself);
		add: (stopButton := self newToolbarButton
			label: 'Stop';
			icon: (self iconNamed: #stop);
			help: 'Stop worker';
			action: [ self doStop ];
			yourself);
		yourself.

	announcementList := self newList
		display: [ :each | each line ];
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
RmRunnerPresenter >> updateActions [

	self updateSelectionBasedActions.
	listenButton enabled: self model isRunning.
	stopButton enabled: self model isRunning
]

{ #category : #initialization }
RmRunnerPresenter >> updatePresenter [

	self model ifNil: [
			announcementList items: #().
			self disableAllActions.
			^ self ].

	"announcementList updateItemsKeepingSelection: "
	announcementList items: self model announcements.
	announcementList 
		selectIndex: self model announcements size 
		scrollToSelection: true.
	self updateActions
]

{ #category : #initialization }
RmRunnerPresenter >> updateSelectionBasedActions [

	inspectButton enabled: announcementList selectedItem notNil
]
