pragma circom 2.1.8;
include "./node_modules/circomlib/circuits/comparators.circom";

// Flattens a 2D array into a 1D array
template Flatten(M) {
    signal input graph[M][2];
    signal output out[M * 2];

    for (var i = 0; i < M; i++) {
        for (var j = 0; j < 2; j++) {
            out[(2 * i) + j] <== graph[i][j];
        }
    }
}

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
// N is the number of nodes in the graph
// M is the number of edges in the graph
template ThreeColoring(N, M) {
    signal input graph[M][2];
    signal input colors[N];
    signal output out;
    signal output arr[M * 2];

    // flatten out the 2D array, could be moved to the Javascript
    component c = Flatten(M);
    c.graph <== graph;
    c.out ==> arr;

    // iterate over edges and check if nodes are the same color
    var capDetector = 0;
    for (var i = 0; i < M * 2; i++) {
        if (i % 2 != 1) {
            var leftNode = arr[i];
            var rightNode = arr[i + 1];

            var leftColor = AtIndex(N)(index <== leftNode, array <== colors);
            var rightColor = AtIndex(N)(index <== rightNode, array <== colors);

            var eq = IsEqual()([leftColor, rightColor]);
            capDetector += eq;
        }
    }

    out <== IsZero()(capDetector);

    log("output:", out);
}

component main = ThreeColoring(3, 3);