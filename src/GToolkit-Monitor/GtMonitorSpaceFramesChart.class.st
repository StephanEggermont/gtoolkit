Class {
	#name : #GtMonitorSpaceFramesChart,
	#superclass : #BrVerticalPane,
	#instVars : [
		'currentLogger',
		'profiledSpace',
		'toolbar',
		'startButton',
		'stopButton',
		'resetButton'
	],
	#category : #'GToolkit-Monitor-Space Profiler'
}

{ #category : #initialization }
GtMonitorSpaceFramesChart >> initialize [
	super initialize.
	
	self matchParent.
	self alignTopCenter.
	self padding: (BlInsets all: 10).
	
	toolbar := BrToolbar new
		look: BrGlamorousToolbarLook new.
	
	startButton := BrButton new
		disable;
		look: BrGlamorousButtonWithLabelLook new;
		beSmall;
		label: 'Start';
		action: [ :aButton | self start ].

	stopButton := BrButton new
		disable;
		beSmall;
		look: BrGlamorousButtonWithLabelLook new;
		label: 'Stop';
		action: [ self stop ].
		
	resetButton := BrButton new
		disable;
		look: BrGlamorousButtonWithLabelLook new;
		beSmall;
		label: 'Reset';
		action: [ self reset ].

	toolbar addItems: { startButton . stopButton . resetButton }.
	
	self addChild: toolbar.
]

{ #category : #'private - profiling' }
GtMonitorSpaceFramesChart >> instrumentSpace [
	profiledSpace ifNotNil: [ :anOpenedSpace | self instrumentSpace: anOpenedSpace space ]
]

{ #category : #'private - profiling' }
GtMonitorSpaceFramesChart >> instrumentSpace: aSpace [
	aSpace enqueueTask: (BlTaskAction new action: [ aSpace telemetry: BlMemoryTelemetry new ])
]

{ #category : #'hooks - children' }
GtMonitorSpaceFramesChart >> onAddedToSceneGraph [
	super onAddedToSceneGraph.
	
	self startLogger.
	self instrumentSpace
]

{ #category : #'hooks - children' }
GtMonitorSpaceFramesChart >> onRemovedFromSceneGraph [
	super onRemovedFromSceneGraph.
	
	self stopLogger.
	self uninstrumentSpace
]

{ #category : #accessing }
GtMonitorSpaceFramesChart >> profileSpace: anOpenedSpace [

	profiledSpace = anOpenedSpace
		ifTrue: [ ^ self ].

	self
		stop;
		reset.

	self removeChildNamed: #chart.
	
	profiledSpace := anOpenedSpace.
	currentLogger := BlTelemetryLogger new.

	(currentLogger gtFramesFor: GtPhlowEmptyView new)
		asElementDo: [ :aChart | self addChild: aChart as: #chart ].
		
	self start
]

{ #category : #'api - profiler' }
GtMonitorSpaceFramesChart >> reset [
	self resetLogger
]

{ #category : #'private - profiling' }
GtMonitorSpaceFramesChart >> resetLogger [
	currentLogger ifNotNil: [ :aLogger | aLogger reset ].
]

{ #category : #'api - profiler' }
GtMonitorSpaceFramesChart >> start [

	self
		instrumentSpace;
		startLogger.
		
	stopButton enable.
	startButton disable.
	resetButton disable
]

{ #category : #'private - profiling' }
GtMonitorSpaceFramesChart >> startLogger [
	currentLogger ifNotNil: [ :aLogger | aLogger start ].
]

{ #category : #'api - profiler' }
GtMonitorSpaceFramesChart >> stop [
	self
		stopLogger;
		uninstrumentSpace.

	stopButton disable.
	startButton enable.
	resetButton enable
]

{ #category : #'private - profiling' }
GtMonitorSpaceFramesChart >> stopLogger [
	currentLogger ifNotNil: [ :aLogger | aLogger stop ].
]

{ #category : #'private - profiling' }
GtMonitorSpaceFramesChart >> uninstrumentSpace [
	profiledSpace ifNotNil: [ :anOpenedSpace | self uninstrumentSpace: anOpenedSpace space ]
]

{ #category : #'private - profiling' }
GtMonitorSpaceFramesChart >> uninstrumentSpace: aSpace [
	aSpace enqueueTask: (BlTaskAction new action: [ aSpace telemetry: BlNullTelemetry new ])
]