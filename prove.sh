#!/bin/bash
set -e # make the script stop if a command fails

BASE_DIR="artifacts"
COMP_DIR="$BASE_DIR/compilation"
SETUP_DIR="$BASE_DIR/setup"
PROOF_DIR="$BASE_DIR/proof"

INPUT_FILE="input.json"
WASM_FILE="$COMP_DIR/main_js/main.wasm"
ZKEY_FILE="$SETUP_DIR/circuit_final.zkey"
PROOF_FILE="$PROOF_DIR/proof.json"
PUBLIC_FILE="$PROOF_DIR/public.json"
VERIFICATION_KEY_FILE="$SETUP_DIR/verification_key.json"

echo "Proving the circuit with witness..."
snarkjs groth16 fullprove "$INPUT_FILE" "$WASM_FILE" "$ZKEY_FILE" "$PROOF_FILE" "$PUBLIC_FILE"
echo "Verifying the circuit with witness..."
snarkjs groth16 verify "$VERIFICATION_KEY_FILE" "$PUBLIC_FILE" "$PROOF_FILE"
echo "Success!"
