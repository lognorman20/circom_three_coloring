SHELL := /bin/bash
.SHELLFLAGS := -e # make the script stop if a command fails

ARTIFACT_DIR := artifacts
CIRCUIT_DIR := circuits
COMP_DIR := $(ARTIFACT_DIR)/compilation
SETUP_DIR := $(ARTIFACT_DIR)/setup
PROOF_DIR := $(ARTIFACT_DIR)/proof
WTNS_INPUT := $(CIRCUIT_DIR)/input.json

circuit:
	@echo "Compiling circuit..."
	circom $(CIRCUIT_DIR)/main.circom --r1cs --wasm --sym
	mkdir -p $(ARTIFACT_DIR)/{setup,compilation,proof}
	mv *_js *.r1cs *.sym $(COMP_DIR)
	node $(COMP_DIR)/main_js/generate_witness.js $(COMP_DIR)/main_js/main.wasm $(WTNS_INPUT) $(COMP_DIR)/main_js/witness.wtns
	snarkjs wtns check $(COMP_DIR)/main.r1cs $(COMP_DIR)/main_js/witness.wtns
	@echo "Finished compiling circuit!"

ptau:
	@echo "Starting powers of tau..."
	snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
	echo "WADDUP" | snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v
	snarkjs powersoftau verify pot12_0001.ptau
	snarkjs powersoftau beacon pot12_0001.ptau pot12_beacon.ptau 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon"
	snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v
	snarkjs groth16 setup $(COMP_DIR)/main.r1cs pot12_final.ptau $(SETUP_DIR)/main_0000.zkey
	snarkjs powersoftau verify pot12_final.ptau
	echo "YESSIR" | snarkjs zkey contribute $(SETUP_DIR)/main_0000.zkey $(SETUP_DIR)/main_0001.zkey --name="1st Contributor Name" -v
	snarkjs zkey verify $(COMP_DIR)/main.r1cs pot12_final.ptau $(SETUP_DIR)/main_0001.zkey
	snarkjs zkey beacon $(SETUP_DIR)/main_0001.zkey $(SETUP_DIR)/circuit_final.zkey 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2"
	snarkjs zkey verify $(COMP_DIR)/main.r1cs pot12_final.ptau $(SETUP_DIR)/circuit_final.zkey
	snarkjs zkey export verificationkey $(SETUP_DIR)/circuit_final.zkey $(SETUP_DIR)/verification_key.json

	rm -rf *.ptau
	@echo "Finished powers of tau. The setup is complete!"

proof:
	@echo "Proving the circuit with witness..."
	snarkjs groth16 fullprove $(WTNS_INPUT) $(COMP_DIR)/main_js/main.wasm $(SETUP_DIR)/circuit_final.zkey $(PROOF_DIR)/proof.json $(PROOF_DIR)/public.json
	@echo "Verifying the circuit with witness..."
	snarkjs groth16 verify $(SETUP_DIR)/verification_key.json $(PROOF_DIR)/public.json $(PROOF_DIR)/proof.json
	@echo "Successfully generated and verified a proof for the circuit!"

clean:
	rm -rf artifacts *.r1cs *.sym *_js *.ptau
	@echo "Cleaned directory."

all: circuit ptau proof

.PHONY: circuit ptau proof clean all
