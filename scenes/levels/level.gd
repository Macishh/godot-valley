extends Node2D

@onready var water_layer: TileMapLayer = $Layers/WaterLayer
@onready var grass_layer: TileMapLayer = $Layers/GrassLayer
@onready var soil_layer: TileMapLayer = $Layers/SoilLayer
@onready var soil_water_layer: TileMapLayer = $Layers/SoilWaterLayer

func _on_player_tool_use(tool: Enum.Tool, pos: Vector2) -> void:
	var grid_coord: Vector2i = Vector2i(int(pos.x / Data.TILE_SIZE), int(pos.y / Data.TILE_SIZE))
	match tool:
		Enum.Tool.HOE:
			var cell = grass_layer.get_cell_tile_data(grid_coord) as TileData
			if cell and cell.get_custom_data('Farmable'): 
				soil_layer.set_cells_terrain_connect([grid_coord], 0, 0)
		Enum.Tool.WATER:
			if grid_coord in soil_layer.get_used_cells():
				soil_water_layer.set_cell(grid_coord, 0, Vector2(randi_range(0, 2), 0))
		Enum.Tool.FISH:
			if not grid_coord in grass_layer.get_used_cells():
				print('Fishing')
