test:
	xcodebuild -workspace PerSectionLayout.xcworkspace -scheme PerSectionLayout -sdk iphonesimulator clean test | xcpretty -c && exit ${PIPESTATUS[0]}
