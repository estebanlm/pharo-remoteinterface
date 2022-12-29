Class {
	#name : #BaselineOfPharoRI,
	#superclass : #BaselineOf,
	#category : #BaselineOfPharoRI
}

{ #category : #baselines }
BaselineOfPharoRI >> baseline: spec [
	<baseline>

	spec for: #common do: [ 
		self glib: spec.
		self beacon: spec.

		spec 
			package: 'PharoRI' with: [ spec requires: #('Glib' 'Beacon') ]; 
			package: 'PharoRI-DrTests' with: [ spec requires: #('PharoRI') ]; 
			package: 'PharoRI-Tests' with: [ spec requires: #('PharoRI') ];
			package: 'PharoRI-GUI' with: [ spec requires: #('PharoRI') ].

		spec
			group: 'default' with: #('all'); 
			group: 'core' with: #('PharoRI');
			group: 'gui' with: #('core' 'PharoRI-GUI');
			group: 'tests' with: #('core' 'PharoRI-Tests');
			group: 'all' with: #('core' 'gui' 'tests' 'PharoRI-DrTests') ]
]

{ #category : #'external projects' }
BaselineOfPharoRI >> beacon: spec [

	spec baseline: 'Beacon' with: [ 
		spec 
			repository: 'github://pharo-project/pharo-beacon/repository';
			loads: #('Beacon-ExtraSignals' 'Beacon-SerializingLoggers') ]
]

{ #category : #'external projects' }
BaselineOfPharoRI >> glib: spec [

	spec baseline: 'Glib' with: [ 
		spec 
			repository: 'github://pharo-spec/gtk-bindings:gtk4/src';
			loads: 'GIO-standalone' ]
]
