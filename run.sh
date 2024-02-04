#!/bin/bash
circom three_coloring.circom --r1cs --wasm --sym && cd *_js && node generate_witness.js three_coloring.wasm ../input.json witness.wtns && cd ..