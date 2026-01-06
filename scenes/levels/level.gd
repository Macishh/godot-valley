extends Node2D

@onready var water_layer: TileMapLayer = $Layers/WaterLayer
@onready var grass_layer: TileMapLayer = $Layers/GrassLayer
@onready var soil_layer: TileMapLayer = $Layers/SoilLayer
@onready var soil_water_layer: TileMapLayer = $Layers/SoilWaterLayer

var plat_scene = preload("res://scenes/objects/plant.tscn")
var used_cells: Array[Vector2i]

func _on_player_tool_use(tool: Enum.Tool, pos: Vector2) -> void:
	var grid_coord: Vector2i = Vector2i(int(pos.x / Data.TILE_SIZE), int(pos.y / Data.TILE_SIZE))
	grid_coord.x += -1 if pos.x < 0 else 0
	grid_coord.y += -1 if pos.y < 0 else 0
	var has_soil = grid_coord in soil_layer.get_used_cells()
	match tool:
		Enum.Tool.HOE:
			var cell = grass_layer.get_cell_tile_data(grid_coord) as TileData
			if cell and cell.get_custom_data('Farmable'): 
				soil_layer.set_cells_terrain_connect([grid_coord], 0, 0)
		Enum.Tool.WATER:
			if has_soil:
				soil_water_layer.set_cell(grid_coord, 0, Vector2(randi_range(0, 2), 0))
		Enum.Tool.FISH:
			if not grid_coord in grass_layer.get_used_cells():
				print('Fishing')
		Enum.Tool.SEED:
			if has_soil and grid_coord not in used_cells:
				var plant = plat_scene.instantiate()
				plant.setup(grid_coord, $Objects)
				used_cells.append(grid_coord)
		Enum.Tool.AXE, Enum.Tool.SWORD:
			for object in get_tree().get_nodes_in_group('Objects'):
				if object.position.distance_to(pos) < 20:
					object.hit(tool)
