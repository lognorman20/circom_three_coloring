pragma circom 2.1.8;
include "./three_coloring.circom";
component main {public [graph, colors]} = ThreeColoring(3,3);