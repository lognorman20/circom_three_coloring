#!/bin/bash
set -e # make the script stop if a command fails

BASE_DIR="artifacts/compilation"
CIRCUIT_FILE="main.circom"
R1CS_FILE="$BASE_DIR/main.r1cs"
WASM_FILE="$BASE_DIR/main_js/main.wasm"
WITNESS_FILE="$BASE_DIR/main_js/witness.wtns"
GEN_WITNESS_FILE="$BASE_DIR/main_js/generate_witness.js"
INPUT_FILE="input.json"

echo "COMPILING CIRCUIT"
circom "$CIRCUIT_FILE" --r1cs --wasm --sym
mkdir -p artifacts/{setup,compilation,proof}
mv *_js *.r1cs *.sym "$BASE_DIR"
node "$GEN_WITNESS_FILE" "$WASM_FILE" "$INPUT_FILE" "$WITNESS_FILE"
snarkjs wtns check "$R1CS_FILE" "$WITNESS_FILE"
echo "FINISHED COMPILING CIRCUIT"