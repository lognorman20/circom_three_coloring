// Credit for `CalulateTotal` and `AtIndex` goes to @rubydusa:
// https://medium.com/@rubydusa/graceful-tree-labeling-in-circom-a-look-into-a-circom-circuit-89eccec31f61?source=user_profile---------1----------------------------

pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

template CalculateTotal(N) {
    signal input in[N];
    signal output out;

    signal outs[N];
    outs[0] <== in[0];

    for (var i=1; i < N; i++) {
        outs[i] <== outs[i - 1] + in[i];
    }

    out <== outs[N - 1];
}

template AtIndex(N) {
    signal input array[N];
    signal input index;

    signal output out;

    component result = CalculateTotal(N);
    for (var i = 0; i < N; i++) {
        var isEqual = IsEqual()([i, index]);
        result.in[i] <== isEqual * array[i];
    }

    out <== result.out;
}

// Checks if a given graph is three colorable.
// N = # nodes
// M = # edges
template ThreeColoring(N, M) {
    signal input graph[M][2];
    signal input colors[N];
    signal output out;

    // check nodes incident to the ith edge to see if they're the same color
    var capMeter = 0;
    for (var i = 0; i < M; i++) {
        var leftNode = graph[i][0];
        var rightNode = graph[i][1];

        var leftColor = AtIndex(N)(index <== leftNode, array <== colors);
        var rightColor = AtIndex(N)(index <== rightNode, array <== colors);

        var eq = IsEqual()([leftColor, rightColor]);
        capMeter += eq;

        // debugging
        if (eq) {
            log("the two bad nodes are", leftNode, rightNode);
            log("their colors are", leftColor, rightColor);
        }
    }

    out <== IsZero()(capMeter);
    log("output:", out);
}
