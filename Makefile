.PHONY: build check lint test verify

UNITY ?= unity
DOTNET ?= dotnet
# Set REQUIRE_NATIVE_CONTRACTS=1 wherever dotnet is guaranteed (CI) so that a
# missing or misdirected compiler cannot silently skip the only live assertions
# in the repository and still report success.
REQUIRE_NATIVE_CONTRACTS ?= 0
override ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

lint:
	$(ROOT)scripts/check-baseline.sh

test:
	$(ROOT)scripts/check-baseline.sh
	$(ROOT)scripts/check-anchor-lifecycle.sh
	@if command -v "$(DOTNET)" >/dev/null 2>&1; then \
		DOTNET="$(DOTNET)" "$(ROOT)scripts/run-native-interface-contracts.sh" && \
		DOTNET="$(DOTNET)" "$(ROOT)scripts/check-contract-mutation-detection.sh"; \
	elif [ "$(REQUIRE_NATIVE_CONTRACTS)" = "1" ]; then \
		echo "dotnet is unavailable but REQUIRE_NATIVE_CONTRACTS=1; refusing to report success without running the production ARKit native-interface contracts." >&2; \
		exit 1; \
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
