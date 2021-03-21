# Fog Of War Plugin

A Godot plugin that adds a `FogOfWar` node that draws fog which can be uncovered by script or by nodes.

## Usage

Add a `FogOfWar` to the scene and configure the fog area to cover the  world. Set the fog pixel size and the other paramaters to get the effect you like.

### Uncovering The Fog

You can uncover areas of the fog manually by calling `uncover_sphere(position, radius)` or add nodes to the `UncoverFog` group. If the node has a `see_range` member, it will be used as the visibility radius.
