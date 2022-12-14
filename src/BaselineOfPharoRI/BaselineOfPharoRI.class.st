Class {
	#name : #BaselineOfPharoRI,
	#superclass : #BaselineOf,
	#category : #BaselineOfPharoRI
}

{ #category : #baselines }
BaselineOfPharoRI >> baseline: spec [

	spec for: #common do: [ 
		self glib: spec.
		
		spec 
			package: 'PharoRI'; 
			package: 'PharoRI-DrGeo'; 
			package: 'PharoRI-Tests'.
			
			
		spec 
			group: 'default' with: #('all'); 
			group: 'core' with: #('PharoRI'); 
			group: 'tests' with: #('core' 'PharoRI-Tests'); 
			group: 'all' with: #('core' 'tests' 'PharoRI-DrGeo').
	]
]

{ #category : #'external projects' }
BaselineOfPharoRI >> glib: spec [

	spec baseline: 'Glib' with: [ 
		spec repository: 'github://pharo-spec/gtk-bindings' ]
]
