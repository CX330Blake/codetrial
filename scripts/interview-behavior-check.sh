#!/bin/sh
set -eu

# The interviewer behaviour check. Outside the gate: it makes Gemini requests.
#
# The judgement lives in `tests/interview_behavior.rs`, and so does reading the
# key the way the binary does: GOOGLE_API_KEY from the config file
# `scripts/gemini-check.sh` names, over the environment. This script only names
# that file.
#
#   BEHAVIOR_PROBLEMS=3sum,coin-change   which problems to script (default three)
#   GEMINI_BEHAVIOR_MODEL=...            text model standing in for the live one

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
CODETRIAL_ENV="${CODETRIAL_ENV:-$ROOT/config/codetrial.env.local}"
# Cargo runs the test from the package root, not from where this was invoked.
case $CODETRIAL_ENV in
    /*) ;;
    *) CODETRIAL_ENV="$PWD/$CODETRIAL_ENV" ;;
esac
export CODETRIAL_ENV

cargo test --manifest-path "$ROOT/Cargo.toml" --test interview_behavior -- \
    --ignored --nocapture
