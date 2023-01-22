extends CharacterBody2D

@export var MAX_SPEED: int
@export var ACCELERATION: int
@export var FRICTION: int

enum {
	IDLE,
	RUN,
	ATTACK
}

var state = IDLE
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
		IDLE:
			idle_state(delta)
		RUN:
			run_state(delta)
		ATTACK:
			attack_state(delta)

func idle_state(delta):
	var direction_input = Vector2.ZERO
	direction_input = joystick.get_value()
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	if direction_input != Vector2.ZERO:
		state = RUN
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	if animationState.get_current_node() != "Idle":
		animationState.travel("Idle")

func run_state(delta):
	var direction_input = Vector2.ZERO
	direction_input = joystick.get_value()

	if direction_input != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", direction_input)
		animationTree.set("parameters/Run/blend_position", direction_input)
		animationTree.set("parameters/Attack/blend_position", direction_input)
		if animationState.get_current_node() != "Run":
			animationState.travel("Run")
		velocity = velocity.move_toward(direction_input * MAX_SPEED, ACCELERATION * delta)
	else:
		state = IDLE
		
	move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK


func attack_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	if animationState.get_current_node() != "Attack":
		animationState.travel("Attack")
	
	
func attack_animation_finished():
	state = IDLE

