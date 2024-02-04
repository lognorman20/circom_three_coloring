#!/bin/bash
set -e # make the script stop if a command fails

# Define file names as variables
PTAU_FILE="pot12_0000.ptau"
CONTRIB_FILE_1="pot12_0001.ptau"
BEACON_FILE="pot12_beacon.ptau"
FINAL_PTAU_FILE="pot12_final.ptau"
ZKEY_FILE_1="main_0000.zkey"
ZKEY_FILE_2="main_0001.zkey"
FINAL_ZKEY_FILE="circuit_final.zkey"
VERIFICATION_KEY_FILE="verification_key.json"
R1CS_FILE="artifacts/compilation/main.r1cs"

echo "STARTING POWERS OF TAU"
snarkjs powersoftau new bn128 12 "$PTAU_FILE" -v
echo "WADDUP" | snarkjs powersoftau contribute "$PTAU_FILE" "$CONTRIB_FILE_1" --name="First contribution" -v
snarkjs powersoftau verify "$CONTRIB_FILE_1"
snarkjs powersoftau beacon "$CONTRIB_FILE_1" "$BEACON_FILE" 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon"
snarkjs powersoftau prepare phase2 "$CONTRIB_FILE_1" "$FINAL_PTAU_FILE" -v
snarkjs groth16 setup "$R1CS_FILE" "$FINAL_PTAU_FILE" "$ZKEY_FILE_1"
snarkjs powersoftau verify "$FINAL_PTAU_FILE"
echo "YESSIR" | snarkjs zkey contribute "$ZKEY_FILE_1" "$ZKEY_FILE_2" --name="1st Contributor Name" -v
snarkjs zkey verify "$R1CS_FILE" "$FINAL_PTAU_FILE" "$ZKEY_FILE_2"
snarkjs zkey beacon "$ZKEY_FILE_2" "$FINAL_ZKEY_FILE" 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2"
snarkjs zkey verify "$R1CS_FILE" "$FINAL_PTAU_FILE" "$FINAL_ZKEY_FILE"
snarkjs zkey export verificationkey "$FINAL_ZKEY_FILE" "$VERIFICATION_KEY_FILE"
echo "FINISHED POWERS OF TAU"

# clean up
echo "CLEANING UP"
rm -rf *.r1cs *.ptau *.sym
mv *.zkey artifacts/setup
mv "$VERIFICATION_KEY_FILE" artifacts/setup

echo "Setup complete. Now use the run and verify script."