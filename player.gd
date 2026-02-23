extends CharacterBody2D

@export var walk_speed = 4.0
const TILE_SIZE = 16

@onready var anim_player = $AnimationPlayer

var initial_position = Vector2(0, 0)
var input_direction = Vector2(0, 0)
var last_direction = "Down"
var is_moving = false
var percent_moved_to_next_tile = 0.0

func _ready():
	initial_position = position
	anim_player.play("IdleDown")

func _physics_process(delta):
	if is_moving:
		move(delta)
	else:
		process_player_input()

func process_player_input():
	input_direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		input_direction = Vector2(1, 0)
		last_direction = "Right"
	elif Input.is_action_pressed("ui_left"):
		input_direction = Vector2(-1, 0)
		last_direction = "Left"
	elif Input.is_action_pressed("ui_down"):
		input_direction = Vector2(0, 1)
		last_direction = "Down"
	elif Input.is_action_pressed("ui_up"):
		input_direction = Vector2(0, -1)
		last_direction = "Up"

	if input_direction != Vector2.ZERO:
		anim_player.play("Walk" + last_direction)
		initial_position = position
		percent_moved_to_next_tile = 0.0
		is_moving = true
	else:
		anim_player.play("Idle" + last_direction)

func move(delta):
	percent_moved_to_next_tile += walk_speed * delta
	if percent_moved_to_next_tile >= 1.0:
		position = initial_position + (input_direction * TILE_SIZE)
		percent_moved_to_next_tile = 0.0
		is_moving = false
	else:
		position = initial_position + (input_direction * TILE_SIZE * percent_moved_to_next_tile)
