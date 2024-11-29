.PHONY: open
open:
	xed Package.swift

.PHONY: serve
serve:
	@npm install --prefix server >/dev/null 2>&1
	node server/index.js
