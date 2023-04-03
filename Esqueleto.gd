extends CharacterBody2D

@onready var state_machine = $AnimationTree.get("parameters/playback")
var hurt = false
var knockback = false
var frame = 0
var hitdir = 1

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const gravity = 900
const walk_speed = 80


func _physics_process(delta):
	#DEBUG
	#frame += 1
	#print("Skeleton, animation frame: %s, current frame: %s state: %s" % [$AnimatedSprite2D.frame, frame, state_machine.get_current_node()])
	if not is_on_floor():
		velocity.y += gravity * delta
	if is_on_floor():
		state_machine.travel("idle")
	if hurt:
		state_machine.travel("hurt")
		$AnimatedSprite2D.scale.x = hitdir
		velocity.x += -100*hitdir
		knockback = true
		hurt = false
	if knockback:
		if abs(velocity.x)>0:
			velocity = velocity.move_toward(Vector2.ZERO,5)
		else:
			knockback = false
	
	
	move_and_slide()


func _on_hurtbox_area_entered(area):
	if area.name == "PAttackHitbox":
		hitdir = area.get_parent().get_parent().hitdir()*-1
		hurt = true
