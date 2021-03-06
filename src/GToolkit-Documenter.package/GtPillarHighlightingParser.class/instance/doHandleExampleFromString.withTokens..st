handling
doHandleExampleFromString: exampleString withTokens: aToken
	| previewAttributeBlock exampleMethod attributesToAdd expandingAttribute previewAttribute |
	exampleMethod := Compiler evaluate: exampleString.
	self targetText
		attributes: {(BrTextForegroundAttribute paint: Color blue muchDarker)}
		from: aToken first stop + 1
		to: aToken last start - 1.
	previewAttributeBlock := [ BrTextAdornmentDynamicAttribute new
		beAppend;
		elementBlock: [ [aToken second asDictionary
				at: 'show'
				ifPresent: [ :selector | 
					| exampleElement |
					exampleElement := GtPillarExampleElement
						withCode: (aToken second asDictionary includesKey: 'noCode') not.
					exampleElement
						margin: (BlInsets all: 10);
						constraintsDo: [ :c | 
							c textFlow pushLine.
							c horizontal matchParent.
							c vertical fitContent ].
					exampleElement
						example: exampleMethod gtExample
						showBlock: [ :returnValue | 
							| composite |
							composite := BlElement new
								constraintsDo: [ :c | 
									c vertical matchParent.
									c horizontal matchParent ].
							returnValue
								perform: selector asSymbol
								withArguments: {composite}.
							composite ] ]
				ifAbsent: [ (GtExamplesStyler
						editorElementOnSourceCode: exampleMethod sourceCode
						inClass: exampleMethod methodClass)
						margin: (BlInsets all: 10) ]] value "on: Error do: [ :err | BlElement new background: Color red ]" ] ].
	expandingAttribute := BrTextExpandButtonAttribute new
		attributesCreatingBlock: previewAttributeBlock.
	attributesToAdd := OrderedCollection with: expandingAttribute.
	(aToken second asDictionary includesKey: 'expanded')
		ifTrue: [ previewAttribute := previewAttributeBlock value.
			attributesToAdd add: previewAttribute.
			expandingAttribute isExpanded: true.
			expandingAttribute createdAttributes: {previewAttribute} ].
	^ self targetText
		attributes: attributesToAdd
		from: aToken last start
		to: aToken last stop