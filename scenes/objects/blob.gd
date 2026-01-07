extends CharacterBody2D

@onready var flash_sprite_2d: Sprite2D = $FlashSprite2D
@onready var player = get_tree().get_first_node_in_group('Player')
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var direction: Vector2
var speed := 20
var push_distance := 130
var push_direction: Vector2
var health := 3:
	set(value):
		health = value
		if health <= 0:
			death()

func _physics_process(_delta: float) -> void:
	direction = (player.position - position).normalized()
	velocity = direction * speed + push_direction
	move_and_slide()
	
func push():
	var tween = get_tree().create_tween()
	var target = (player.position - position).normalized() * -1 * push_distance
	tween.tween_property(self, "push_direction", target, 0.1)
	tween.tween_property(self, "push_direction", Vector2.ZERO, 0.2)

func death():
	speed = 0
	animation_player.current_animation = 'explode'

func hit(tool: Enum.Tool):
	if tool == Enum.Tool.SWORD:
		flash_sprite_2d.flash()
		push()
		health -= 1
