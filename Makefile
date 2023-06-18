TARGET_CODESIGN = $(shell which ldid)

all: tipa

tipa:
	@set -o pipefail; \
		xcodebuild -project Amber.xcodeproj -scheme Amber -archivePath build/Amber.xcarchive archive -destination "platform=iOS" CODE_SIGNING_ALLOWED=NO
	@cp -R build/Amber.xcarchive/Products/Applications/Amber.app build/Amber.app
	@$(TARGET_CODESIGN) -Sentitlements.plist build/Amber.app/Amber
	@$(TARGET_CODESIGN) -Sentitlements.plist build/Amber.app
	@mkdir build/Payload
	@mv build/Amber.app build/Payload
	@mv build/Payload Payload
	@tar -czf build/Amber.tipa Payload
	@rm -rf Payload
	@rm -rf build/Amber.app
	@rm -rf build/Amber.xcarchive
