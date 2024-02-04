# Circom Three Coloring

Verifying if a graph has a valid [Three Coloring](https://en.wikipedia.org/wiki/Graph_coloring) in [Circom](https://docs.circom.io/).

An edge list of different integers as nodes is used to represent a graph. For example,
```
"graph": [[0,1],[0,2],[1,2]],
```
creates the graph
```
   0
  / \
 1---2
```

To reprsesent the colors of each node, a separate `colors` array is used
```
"colors": [0,1,2]
```
where each number in `colors` represents a different color. The index in the array
maps to the color of the `ith` node. For example, `colors[1]` will give you the color
of the node labeled `1`.

Combining these two inputs, a colored graph is represented programmatically. 

## Run

To run this code, make use of the `Makefile`. A description of each option is as follows:

`make all`: Cleans the directory, compiles the Circom circuit, generates witnesses, fully runs the Powers of Tau Ceremony, and finally generates and verifies a proof for the circuit given a set of witnesses. The witnesses used are in `circuits/input.json`.

`make circuit`: Compiles the Circom circuit and generates witnesses. The output can be found in `artifacts/compilation`.

`make ptau`: Runs the Powers of Tau Ceremony. `make circuit` must be ran before this command. The output can be found in `artifacts/setup`.

`make proof`: Generates and verifies a proof for the circuit given the inputs in `circuits/input.json`. The output can be found in `artifacts/proof`.

`make clean`: Cleans the repository of all files relating to the compilation, setup, or proving stage.

To change the inputs of the proof, alter the `circuits/input.json` file's contents. The file contains two keys:

```
{
    "graph": [[0,1],[1,2],[2,3],[2,4],[3,4],[4,0]],
    "colors": [0,1,0,1,2]
}
```

Additionally, change the inputs to `circuits/main.circom` need to be changed. 
```
component main {public [graph, colors]} = ThreeColoring(N,M);
```
Set `N` (number of nodes) and `M` (number of edges) according to the graph in `input.json`.