accessing
exampleCompiledMethod
	^ Compiler evaluate: (self parameters at: 'example' ifAbsent: [ 'nil' ])