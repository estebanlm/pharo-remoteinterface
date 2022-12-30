# Pharo Remote Interface

The Pharo Remote Interface (RI) is a very simple framework to spawn and comunicate pharo processes (images), using the standard IO files and STON ([Smalltalk Object Notation](https://github.com/svenvc/ston)) as communicating pipes.

[![CI](https://github.com/estebanlm/pharo-remoteinterface/actions/workflows/runTests.yml/badge.svg)](https://github.com/estebanlm/pharo-remoteinterface/actions/workflows/runTests.yml)

The RI package uses the GIO functionality present in Glib ([bindings can be found here](https://github.com/pharo-spec/gtk-bindings)) to spawn and communicate process.

## Install

```Smalltalk
Metacello new
	repository: 'github://estebanlm/pharo-remoteinterface';
	baseline: 'PharoRI';
	load.
```

## Usage

The easiest way to use it is just executing:

```Smalltalk
runner := RmRemoteRunner new.
runner spawn.
```

and then you can execute commands synchronously: 

```Smalltalk
runner runCommand: [ 42 factorial ]
```

or asynchronously: 

```Smalltalk
runner 
	runCommand: [ 42 factorial ]
	onSuccess: [ :result | result inspect ]
```

**IMPORTANT: The blocks passed to the spawned image need to be "clean blocks", for obvious reasons they can't have references to `self`, `super` or variables.**

## Monitoring the remote image

There is a small tool that help to monitor what happens in the spawned image, you can open it by executing: 

```Smalltalk
RmRunnerMonitorPresenter open.
```

To use it, you need first to enable the logging on the remote image: 

```Smalltalk
runner listenToLog.
```

## Using PharoRI for testing

TODO
