extends CharacterBody2D

@export var MAX_SPEED: int
@export var ACCELERATION: int
@export var FRICTION: int

enum {
	MOVE,
	ATTACK
}

var state = MOVE
var starting_direction = Vector2(1, 0)

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var joystick = get_node("Controls")


func _ready():
	animationTree.active = true
	animationTree.set("parameters/Idle/blend_position", starting_direction)


func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)


func move_state(delta):
	var direction_input = Vector2.ZERO
	direction_input = joystick.get_value()

	if direction_input != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", direction_input)
		animationTree.set("parameters/Run/blend_position", direction_input)
		animationTree.set("parameters/Attack/blend_position", direction_input)
		animationState.travel("Run")
		velocity = velocity.move_toward(direction_input * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animationState.travel("Idle")
		
	move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK


func attack_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	animationState.travel("Attack")
	
	
func attack_animation_finished():
	state = MOVE

