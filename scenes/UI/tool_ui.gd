extends Control

@onready var tool_container: HBoxContainer = $ToolContainer
@onready var hide_timer: Timer = $HideTimer

const TOOL_TEXTURES = {
	Enum.Tool.AXE: preload("res://graphics/icons/axe.png"),
	Enum.Tool.HOE: preload("res://graphics/icons/hoe.png"),
	Enum.Tool.WATER: preload("res://graphics/icons/water.png"),
	Enum.Tool.SWORD: preload("res://graphics/icons/sword.png"),
	Enum.Tool.FISH: preload("res://graphics/icons/fish.png"),
	Enum.Tool.SEED: preload("res://graphics/icons/wheat.png"),}
var tool_texture_scene = preload("res://scenes/UI/tool_ui_texture.tscn")

func _ready() -> void:
	tool_container.hide()
	texture_setup(Enum.Tool.values(), TOOL_TEXTURES, tool_container)
	
func texture_setup(enum_list: Array, textures: Dictionary, container: HBoxContainer):
	for enum_id in enum_list:
		var tool_texture = tool_texture_scene.instantiate()
		tool_texture.setup(enum_id, textures[enum_id])
		container.add_child(tool_texture)

func reveal():
	hide_timer.start()
	tool_container.show()
	var target = get_parent().current_tool
	
	for texture in tool_container.get_children():
		texture.highlight(target == texture.tool_enum)


func _on_hide_timer_timeout() -> void:
	tool_container.hide()
