extends TileMapLayer

var grass_list = Array()

func add_node(pos: Vector2i):
	grass_list.append(pos)

func flush_nodes():
	self.set_cells_terrain_connect(grass_list, 1, 0)
	grass_list.clear()
