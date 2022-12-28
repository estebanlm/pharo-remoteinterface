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

		spec 
			package: 'PharoRI' with: [ spec requires: #('Glib') ]; 
			package: 'PharoRI-DrGeo' with: [ spec requires: #('PharoRI') ]; 
			package: 'PharoRI-Tests' with: [ spec requires: #('PharoRI') ];
			package: 'PharoRI-GUI' with: [ spec requires: #('PharoRI') ].

		spec
			group: 'default' with: #('all'); 
			group: 'core' with: #('PharoRI');
			group: 'gui' with: #('PharoRI' 'PharoRI-GUI');
			group: 'tests' with: #('core' 'PharoRI-Tests');
			group: 'all' with: #('core' 'gui' 'tests' 'PharoRI-DrGeo') ]
]

{ #category : #'external projects' }
BaselineOfPharoRI >> glib: spec [

	spec baseline: 'Glib' with: [ 
		spec repository: 'github://pharo-spec/gtk-bindings' ]
]
