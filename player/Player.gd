extends CharacterBody2D

const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500

enum {
	MOVE,
	ATTACK
}

var state = MOVE

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")


func _ready():
	animationTree.active = true


func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)


func move_state(delta):
	var direction_input = Vector2.ZERO
	direction_input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction_input.y = Input.get_action_strength("ui_down") - Input.get_action_raw_strength("ui_up")
	direction_input = direction_input.normalized()
	
	if direction_input != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", direction_input)
		animationTree.set("parameters/Run/blend_position", direction_input)
		animationTree.set("parameters/Attack/blend_position", direction_input)
		animationState.travel("Run")
		velocity = velocity.move_toward(direction_input * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	set_velocity(velocity)
	move_and_slide()
	velocity = velocity
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK


func attack_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	animationState.travel("Attack")
	
	
func attack_animation_finished():
	state = MOVE
