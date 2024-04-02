.PHONY: open
open:
	xed Package.swift

.PHONY: serve
serve:
	node server/index.js
