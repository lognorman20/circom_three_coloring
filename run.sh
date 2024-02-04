#!/bin/bash
set -e # make the script stop if a command fales

circom main.circom --r1cs --wasm --sym
cd *_js
node generate_witness.js main.wasm ../input.json witness.wtns
cd ..
snarkjs wtns check main.r1cs main_js/witness.wtns