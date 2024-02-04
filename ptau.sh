#!/bin/bash
set -e # make the script stop if a command fales

echo "STARTING POWERS OF TAU"
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
echo "WADDUP" | snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v
snarkjs powersoftau verify pot12_0001.ptau
snarkjs powersoftau beacon pot12_0001.ptau pot12_beacon.ptau 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon"
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v
snarkjs groth16 setup main.r1cs pot12_final.ptau main_0000.zkey
snarkjs powersoftau verify pot12_final.ptau
echo "YESSIR" | snarkjs zkey contribute main_0000.zkey main_0001.zkey --name="1st Contributor Name" -v
snarkjs zkey export verificationkey main_0001.zkey verification_key.json
echo "FINISHED POWERS OF TAU"

# clean up
echo "CLEANING UP"
rm -rf *.r1cs *.ptau *.sym
mv *.zkey artifacts
mv verification_key.json artifacts

echo "Setup complete. Now use the run and verify script."