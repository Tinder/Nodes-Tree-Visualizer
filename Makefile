.PHONY: serve
serve:
	@npm install --prefix server >/dev/null 2>&1
	node server/index.js

.PHONY: open
open: fix
open:
	xed Package.swift

.PHONY: fix
fix: XCSHAREDDATA = .swiftpm/xcode/package.xcworkspace/xcshareddata
fix:
	@mkdir -p $(XCSHAREDDATA)
	@/usr/libexec/PlistBuddy -c \
		"Delete :FILEHEADER" \
		"$(XCSHAREDDATA)/IDETemplateMacros.plist" >/dev/null 2>&1 || true
	@header=$$'\n//  Copyright © ___YEAR___ Tinder \(Match Group, LLC\)\n//'; \
	/usr/libexec/PlistBuddy -c \
		"Add :FILEHEADER string $$header" \
		"$(XCSHAREDDATA)/IDETemplateMacros.plist" >/dev/null 2>&1

.PHONY: lint
lint: format ?= emoji
lint:
	@swift package plugin \
		swiftlint lint --strict --progress --reporter "$(format)"

.PHONY: analyze
analyze: target ?= Nodes-Tree-Visualizer
analyze: destination ?= generic/platform=iOS
analyze: format ?= emoji
analyze:
	@DERIVED_DATA="$$(mktemp -d)"; \
	XCODEBUILD_LOG="$$DERIVED_DATA/xcodebuild.log"; \
	xcodebuild \
		-scheme "$(target)" \
		-destination "$(destination)" \
		-derivedDataPath "$$DERIVED_DATA" \
		-configuration "Debug" \
		-skipPackagePluginValidation \
		CODE_SIGNING_ALLOWED="NO" \
		> "$$XCODEBUILD_LOG"; \
	swift package plugin \
		swiftlint analyze --strict --progress --reporter "$(format)" --compiler-log-path "$$XCODEBUILD_LOG"

.PHONY: docs
docs: target ?= Nodes-Tree-Visualizer
docs: destination ?= generic/platform=iOS
docs: open ?= OPEN
docs: DERIVED_DATA_PATH = .build/documentation/data
docs: ARCHIVE_PATH = .build/documentation/archive
docs:
	@mkdir -p "$(DERIVED_DATA_PATH)" "$(ARCHIVE_PATH)"
	xcodebuild docbuild \
		-scheme "$(target)" \
		-destination "$(destination)" \
		-derivedDataPath "$(DERIVED_DATA_PATH)" \
		-skipPackagePluginValidation \
		OTHER_DOCC_FLAGS="--warnings-as-errors"
	@find "$(DERIVED_DATA_PATH)" \
		-type d \
		-name "$(target).doccarchive" \
		-exec cp -R {} "$(ARCHIVE_PATH)/" \;
	$(if $(filter $(open),OPEN),@open "$(ARCHIVE_PATH)/$(target).doccarchive",)
