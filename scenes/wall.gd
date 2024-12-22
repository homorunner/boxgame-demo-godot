@tool
extends Node2D

var WallColor = Color.html("#97b0d8")

var wall_nodes: Array[Vector2i] = []

func add_node(pos: Vector2i):
	wall_nodes.append(pos)

func flush_nodes():
	queue_redraw()

func _draw():
	if wall_nodes:
		for i in range(len(wall_nodes)):
			var node = wall_nodes[i]
			draw_rect(Rect2(node.x * Globals.grid_size, node.y * Globals.grid_size, Globals.grid_size, Globals.grid_size), WallColor)
