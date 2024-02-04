pragma circom 2.1.8;
include "./node_modules/circomlib/circuits/comparators.circom";

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

    // iterate over edges and check if nodes are the same color
    var capDetector = 0;
    for (var i = 0; i < M; i++) {
        var leftNode = graph[i][0];
        var rightNode = graph[i][1];

        var leftColor = AtIndex(N)(index <== leftNode, array <== colors);
        var rightColor = AtIndex(N)(index <== rightNode, array <== colors);

        var eq = IsEqual()([leftColor, rightColor]);
        capDetector += eq;
    }

    out <== IsZero()(capDetector);

    log("output:", out);
}
