travis-tests:
	xcodebuild -workspace PerSectionLayout.xcworkspace -scheme PerSectionLayout -sdk iphonesimulator test | xcpretty
