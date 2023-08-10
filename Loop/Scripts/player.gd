extends CharacterBody2D

@export var acceleration: float = 500.0
@export var max_speed: float = 1000.0
@export var turn_speed: float = 0.3
@export var restrict_force: float = 150.0

var mousex_delta = 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	velocity = Vector2.ZERO
	
func _physics_process(delta):    
	velocity = velocity.limit_length(max_speed)
	velocity *= 0.95
	update_rotation(mousex_delta, delta)
	var nearest_offset = get_parent().nearest_offset
	
	move_and_slide()
	mousex_delta = 0

func _input(event):
	if event is InputEventMouseMotion:
		mousex_delta = event.relative.x

func update_rotation(turn_input: float, delta: float) -> void:
	rotation += turn_input * turn_speed * delta
