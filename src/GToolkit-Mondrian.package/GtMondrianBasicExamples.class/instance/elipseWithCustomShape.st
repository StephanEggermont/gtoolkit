examples
elipseWithCustomShape
	<gtExample>
	| view |
	view := GtMondrian new.
	view nodes
		shape: [ :anInteger | 
			BlElement new
				geometry: BlEllipse new;
				border: (BlBorder paint: Color black width: 2);
				size: (anInteger max: 5) asPoint;
				constraintsDo: [ :constraints | constraints padding: (BlInsets all: 10) ] ];
		with: (1 to: 20).
	view layout circle radius: 200.
	^ view