@tool
extends Node2D

var WallColor = Color.html("#97b0d8")
var ShadowColor = Color.html("#6d819c")
var LightColor = Color.html("#c6e8ff")

const shadow_width = 8
const shadow_height = 5

var wall_nodes: Array[Vector2i] = []
var shadows: Array[Array] = []

func add_node(pos: Vector2i, shadow_map: Array):
	wall_nodes.append(pos)
	shadows.append(shadow_map)

func flush_nodes():
	queue_redraw()

func _draw():
	if wall_nodes:
		for i in range(len(wall_nodes)):
			var node = wall_nodes[i]
			draw_rect(Rect2(node.x * Globals.grid_size, node.y * Globals.grid_size, Globals.grid_size, Globals.grid_size), WallColor)

			var shadow = shadows[i]
			if shadow[0]: # right
				draw_rect(Rect2((node.x + 1) * Globals.grid_size - shadow_width, node.y * Globals.grid_size, shadow_width, Globals.grid_size), ShadowColor)
			#if shadow[1]: # left
				#draw_rect(Rect2(node.x * Globals.grid_size, node.y * Globals.grid_size, shadow_width, Globals.grid_size), LightColor)
			#if shadow[2]: # up
				#draw_rect(Rect2(node.x * Globals.grid_size, node.y * Globals.grid_size, Globals.grid_size, shadow_width), LightColor)
			if shadow[3]:  # down
				draw_rect(Rect2(node.x * Globals.grid_size, (node.y + 1) * Globals.grid_size - shadow_height, Globals.grid_size, shadow_height), ShadowColor)
			if shadow[4]:  # right-down
				draw_rect(Rect2((node.x + 1) * Globals.grid_size - shadow_width, (node.y + 1) * Globals.grid_size - shadow_height, shadow_width, shadow_height), ShadowColor)
