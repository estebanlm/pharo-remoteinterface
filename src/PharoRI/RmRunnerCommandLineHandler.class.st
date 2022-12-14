"
Usage: mi [--pool=aNumber] [--logToStderr] start
--pool=aNumber  Size of the run process pool to execute commands (a TKTWorkerPool) 
--logToStderr   Redirects log to stderr
start           Initiates the worker and prepares redies it to listen for commands   

example: 

mi --pool=10 --logToStderr start 


"
Class {
	#name : #RmRunnerCommandLineHandler,
	#superclass : #CommandLineHandler,
	#instVars : [
		'applicationName',
		'runnerClass',
		'runner'
	],
	#category : #'PharoRI-CommandLine'
}

{ #category : #accessing }
RmRunnerCommandLineHandler class >> commandName [

	^ 'mi'
]

{ #category : #defaults }
RmRunnerCommandLineHandler class >> defaultRunnerClass [

	^ RmRemoteWorker
]

{ #category : #activation }
RmRunnerCommandLineHandler >> activate [

	self activateHelpWithoutArguments ifTrue: [ ^ self ].
	(self hasOption: 'poolSize') ifTrue: [ 
		self useRunner: (RmRemotePoolWorker new
			poolSize: (self optionAt: 'poolSize') asNumber;
			yourself) ].
	(self hasOption: 'logToStderr') ifTrue: [ self logToStderr ].
	
	(self argumentAt: 1) = 'start' ifTrue: [ self startRunner ].
	
	'Runner by command line STARTED' asBeaconSignal emit
]

{ #category : #actions }
RmRunnerCommandLineHandler >> logToStderr [
	
	FileLogger new 
		stream: Stdio stderr;
		start
]

{ #category : #private }
RmRunnerCommandLineHandler >> runner [

	^ runner ifNil: [ runner := self runnerClass new ]
]

{ #category : #private }
RmRunnerCommandLineHandler >> runnerClass [

	^ runnerClass ifNil: [ self class defaultRunnerClass ]
]

{ #category : #actions }
RmRunnerCommandLineHandler >> startRunner [

	[ self runner quitOnStop: true; start ] fork
]

{ #category : #private }
RmRunnerCommandLineHandler >> useRunner: aRunner [

	runner := aRunner
]

{ #category : #private }
RmRunnerCommandLineHandler >> useRunnerClass: aClass [

	runnerClass := aClass
]
