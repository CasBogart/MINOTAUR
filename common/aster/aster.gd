extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# i just made some bullshittttt
# im not making a state machine rn just trust that i can do it lmao
# come back later and clean some of this up? transitions get a bit wonky
func _process(_delta: float) -> void:
	if Input.is_action_pressed("move_right"):
		animated_sprite.flip_h = false
		animated_sprite.play("walkside")
	elif Input.is_action_pressed("move_left"):
		animated_sprite.flip_h = true
		animated_sprite.play("walkside")
	elif Input.is_action_pressed("move_up"):
		animated_sprite.flip_h = false
		animated_sprite.play("walkbackwards")
	elif Input.is_action_pressed("move_down"):
		animated_sprite.flip_h = false
		animated_sprite.play("walkforward")
	else:
		animated_sprite.set_frame(1)

func _physics_process(_delta: float) -> void:
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	
	if input_dir:
		velocity = input_dir * 25
	else:
		velocity = Vector2(0, 0)
	
	move_and_slide()
