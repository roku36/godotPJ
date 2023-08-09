extends CharacterBody2D


const turn_spd : float = 0.03
const SPEED = 30.0

var direction : float = 0

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	var handle_input = Input.get_axis("ui_left", "ui_right")
	
	direction += turn_spd * handle_input

	self.rotation = direction

	# move toward direction vector
	if Input.is_action_pressed("ui_accept"):
		input_vector = Vector2.UP.rotated(direction)
		# velocity = velocity.move_toward(input_vector, SPEED)
		velocity += input_vector * SPEED 

	# damp velocity
	velocity *= 0.95

	move_and_slide()
