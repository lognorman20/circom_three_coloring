#!/bin/bash
circom main.circom --r1cs --wasm --sym && cd *_js && node generate_witness.js main.wasm ../input.json witness.wtns && cd ..