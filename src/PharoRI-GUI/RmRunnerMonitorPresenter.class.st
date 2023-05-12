Class {
	#name : #RmRunnerMonitorPresenter,
	#superclass : #StPresenter,
	#instVars : [
		'runnerList',
		'runnerPresenter',
		'runners',
		'runnerListToolbar'
	],
	#category : #'PharoRI-GUI'
}

{ #category : #'instance creation' }
RmRunnerMonitorPresenter class >> open [
	<script>
	
	self new open
]

{ #category : #'world menu' }
RmRunnerMonitorPresenter class >> runnerMonitorMenu: aBuilder [
	<worldMenu>
	
	(aBuilder item: #'Remote Worker Monitor')
		parent: #SystemTools;
		action: [ self open ];
		order: 4;
		help: 'Monitor your remote workers.';
		icon: (aBuilder iconNamed: self taskbarIconName)
]

{ #category : #'world menu' }
RmRunnerMonitorPresenter class >> taskbarIconName [

	^ #processBrowser
]

{ #category : #private }
RmRunnerMonitorPresenter >> allRunnerModels [

	^ runners 
		ifNil: [ 
			runners := self collectRunnerModels ]
]

{ #category : #private }
RmRunnerMonitorPresenter >> collectRunnerModels [
	
	^ ((RmRemoteRunner activeRunners 
			ifNotNil: [ :aRegistry | aRegistry keys ]
			ifNil: [ #() ])
		reject: [ :each | each isNil ])
		collect: [ :each | RmRunnerModel on: each ]
		as: Array
]

{ #category : #initialization }
RmRunnerMonitorPresenter >> connectPresenters [

	runnerList transmitTo: runnerPresenter
]

{ #category : #'api - focus' }
RmRunnerMonitorPresenter >> defaultKeyboardFocus [
	
]

{ #category : #layout }
RmRunnerMonitorPresenter >> defaultLayout [

	^ SpPanedLayout newHorizontal
		positionOfSlider: 30 percent;
		add: (SpBoxLayout newVertical 
			add: runnerListToolbar expand: false;
			add: runnerList;
			yourself);
		add: runnerPresenter;
		yourself
]

{ #category : #actions }
RmRunnerMonitorPresenter >> doRefresh [

	runners := runners select: [ :each | each isRunning ].
	self updatePresenter
]

{ #category : #initialization }
RmRunnerMonitorPresenter >> initializePresenters [

	runnerListToolbar := self newToolbar.
	runnerListToolbar add: (self newToolbarButton
		label: 'Refresh';
		icon: (self iconNamed: #smallUpdate);
		help: 'Refresh runner list'; 
		action: [ self doRefresh ];
		yourself).

	runnerList := self newList
		display: [ :aModel | aModel label ];
		displayIcon: [ :aModel | aModel iconName ifNotNil: [ :aName | self iconNamed: aName ] ];
		yourself.
	runnerPresenter := self instantiate: RmRunnerPresenter
]

{ #category : #initialization }
RmRunnerMonitorPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: 'Remote worker monitor';
		initialExtent: 800@400;
		whenOpenedDo: [ self subscribeToAnnouncements ];
		whenClosedDo: [ self unsubscribeFromAnnouncers ]
]

{ #category : #private }
RmRunnerMonitorPresenter >> runnerRegistered: ann [

	self allRunnerModels.
	runners := runners copyWith: (RmRunnerModel on: ann runner).
	self updatePresenter 
]

{ #category : #private }
RmRunnerMonitorPresenter >> runnerTerminated: ann [

	self updatePresenter
]

{ #category : #private }
RmRunnerMonitorPresenter >> runnerUnregistered: ann [
	| modelToRemove |

	self allRunnerModels.
	modelToRemove := runners 
		detect: [ :each | each runner == ann runner ]
		ifNone: [ nil ].	
	modelToRemove ifNil: [ ^ self ].
	modelToRemove = runnerList selectedItem
		ifTrue: [ runnerList selectFirst ].
	runners := runners copyWithout: modelToRemove.
	self updatePresenter 
]

{ #category : #initialization }
RmRunnerMonitorPresenter >> subscribeToAnnouncements [

	RmRemoteRunner logAnnouncer 
		when: RmRemoteSignalAnnouncement send: #updateList: to: self;
		when: RmRemoteRunnerRegisteredAnnouncement send: #runnerRegistered: to: self;
		when: RmRemoteRunnerUnregisteredAnnouncement send: #runnerUnregistered: to: self;
		when: RmRemoteRunnerTerminatedAnnouncement send: #runnerTerminated: to: self
]

{ #category : #initialization }
RmRunnerMonitorPresenter >> unsubscribeFromAnnouncers [

	RmRemoteRunner logAnnouncer unsubscribe: self
]

{ #category : #private }
RmRunnerMonitorPresenter >> updateList: ann [

	runners do: [ :each | each maybeAdd: ann ].
	runnerPresenter updatePresenter
]

{ #category : #initialization }
RmRunnerMonitorPresenter >> updatePresenter [

	runnerList selectedItem 
		ifNotNil: [ 
			runnerList updateItemsKeepingSelection: self allRunnerModels ] 
		ifNil: [ 
			runnerList items: self allRunnerModels ]
]
