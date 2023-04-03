extends CharacterBody2D

@onready var state_machine = $AnimationTree.get("parameters/playback")
@onready var animatedsprite = $AnimatedSprite2D

@export var gravity = 900
@export var walk_speed = 100
@export var jump_force = 300
var bool_state_fall = false

func _physics_process(delta):
#	DEBUG
#	print("Player, frame: %s, state: %s" % [$AnimatedSprite2D.frame, state_machine.get_current_node()])
#	print(velocity.y)
#	print(state_machine.get_current_node())
#	print(debug_input())
#	print(animatedsprite.frame)
	if not is_on_floor():
		velocity.y += gravity * delta
		
	var h_axis = Input.get_action_strength("right") - Input.get_action_strength("left")
	velocity.x = h_axis*walk_speed
	if is_on_floor():
		if abs(velocity.x)>0:
			state_machine.travel("move")
		else:
			state_machine.travel("idle")
	else:
		if velocity.y>=0:
			state_machine.travel("fall_loop")
		else:
			state_machine.travel("jump")
		

	if velocity.x < 0:
		$AnimatedSprite2D.scale.x = -1
	elif velocity.x > 0:
		$AnimatedSprite2D.scale.x = 1

	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = -jump_force
	
	if Input.is_action_just_pressed("attack"):
		state_machine.travel("attack1")
	
	move_and_slide()

	if position.y>800:
		position.y=0

func debug_input():
	if Input.is_action_just_pressed("up"):
		return "up"
	if Input.is_action_just_pressed("attack"):
		return "attack"
	if Input.get_action_strength("right"):
		return "right"
	if Input.get_action_strength("left"):
		return "left"

func hitdir():
	return $AnimatedSprite2D.scale.x
