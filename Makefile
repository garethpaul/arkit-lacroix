.PHONY: build check lint test verify

UNITY ?= unity
DOTNET ?= dotnet
override ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

lint:
	$(ROOT)scripts/check-baseline.sh

test:
	$(ROOT)scripts/check-baseline.sh
	$(ROOT)scripts/check-anchor-lifecycle.sh
	@if command -v "$(DOTNET)" >/dev/null 2>&1; then \
		DOTNET="$(DOTNET)" "$(ROOT)scripts/run-native-interface-contracts.sh"; \
	else \
		echo "dotnet unavailable; production ARKit native-interface contracts skipped"; \
	fi
	@echo "No automated Unity editor test runner is checked in; run scene/device tests with Unity 5.6.1p1."

build:
	$(ROOT)scripts/check-baseline.sh
	@if command -v "$(UNITY)" >/dev/null 2>&1; then \
		echo "Unity executable found at $(UNITY), but no batch build method is checked in; export iOS from Unity 5.6.1p1."; \
	else \
		echo "Unity executable not found; full Unity/iOS build requires a Unity 5.6.1p1 host."; \
	fi

verify: lint test build

check: verify
