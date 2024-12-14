extends TileMapLayer

func add_node(pos: Vector2i):
	self.set_cell(pos, 0, Vector2i(0, 0))

func flush_nodes():
	pass
