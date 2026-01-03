extends CharacterBody2D

@onready var animation_tree: AnimationTree = $Animation/AnimationTree

@onready var move_state_machine = animation_tree.get("parameters/MoveStateMachine/playback")
@onready var tool_state_machine = animation_tree.get("parameters/ToolStateMachine/playback")

var direction: Vector2
var speed := 50
var current_tool: Enum.Tool = Enum.Tool.AXE

func _physics_process(delta: float) -> void:
	get_basic_input()
	move()
	animate()

func get_basic_input():
	if Input.is_action_just_pressed("tool_forward") or Input.is_action_just_pressed("tool_backward"):
		var dir = Input.get_axis("tool_backward", "tool_forward")
		current_tool = (current_tool + int(dir)) % Enum.Tool.size()
	
	if Input.is_action_just_pressed("action"):
		tool_state_machine.travel(Data.TOOL_STATE_ANIMATIONS[current_tool])
		animation_tree.set("parameters/ToolOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func move():
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
	
func animate():
	if direction:
		move_state_machine.travel('Walk')
		var direction_rounded = Vector2(round(direction.x), round(direction.y))
		animation_tree.set("parameters/MoveStateMachine/Idle/blend_position", direction_rounded)
		animation_tree.set("parameters/MoveStateMachine/Walk/blend_position", direction_rounded)
		for animation in Data.TOOL_STATE_ANIMATIONS.values():
			var animation_name: String = "parameters/ToolStateMachine/"+ animation + "/blend_position"
			animation_tree.set(animation_name, direction_rounded)
	else:
		move_state_machine.travel('Idle')

func tool_use_emit():
	print('tool')
