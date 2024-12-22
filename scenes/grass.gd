@tool
extends Node2D

var GrassColor = Color.html('#3d4857')

var grass_nodes: Array[Vector2i] = []

func add_node(pos: Vector2i):
	grass_nodes.append(pos)

func flush_nodes():
	queue_redraw()

func _draw():
	if grass_nodes:
		for i in range(len(grass_nodes)):
			var node = grass_nodes[i]
			draw_rect(Rect2(node.x * Globals.grid_size, node.y * Globals.grid_size, Globals.grid_size, Globals.grid_size), GrassColor)
