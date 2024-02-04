const snarkjs = require("snarkjs");
const fs = require("fs");

async function run() {
    const witnessInputs = JSON.parse(fs.readFileSync("input.json"));

    const { proof, publicSignals } = await snarkjs.groth16.fullProve(witnessInputs, "main_js/main.wasm", "artifacts/main_0001.zkey");

    console.log("Proof: ");
    console.log(JSON.stringify(proof, null, 1));

    const vKey = JSON.parse(fs.readFileSync("artifacts/verification_key.json"));

    const res = await snarkjs.groth16.verify(vKey, publicSignals, proof);

    if (res === true) {
        console.log("Verification OK");
    } else {
        console.log("Invalid proof");
    }

}

run().then(() => {
    process.exit(0);
});