test:
	xcodebuild -workspace PerSectionLayout.xcworkspace -scheme PerSectionLayout -sdk iphonesimulator -destination "name=iPhone Retina (4-inch),OS=7.0" clean test | xcpretty -c && exit ${PIPESTATUS[0]}
update:
	@echo "\n\033[04m+ sync and update your git submodules\033[0m"
	git submodule sync
	git submodule update --init --recursive

clean: xcode-clean

xcode-clean:
	@echo "\n\033[04m+ squeaky clean Xcode derived data, because Xcode can't be trusted\033[0m"
	rm -rf ~/Library/Developer/Xcode/DerivedData/PerSectionLayout*

kiwi: kiwi-clean kiwi-build

kiwi-clean:
	@echo "\n\033[04m+ cleaning kiwi build directory, so we can regenerate framework from source\033[0m"
	rm -rf ~/Library/Developer/Xcode/DerivedData/Kiwi*
	rm -rf tools/Kiwi.framework

kiwi-build:
	@echo "\n\033[04m+ updating kiwi from source\033[0m"
	mkdir -p tools
	$(MAKE) install -C lib/Kiwi
	cp -r lib/Kiwi/output/Debug-iphoneuniversal/Kiwi.framework tools/Kiwi.framework
	otool -h -v -V -f tools/Kiwi.framework/Kiwi | grep ^architecture
