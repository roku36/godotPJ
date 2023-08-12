extends CharacterBody2D

@onready var road_path: Path2D = $"../Path2D"

@export var acceleration: float = 500.0
@export var max_speed: float = 1000.0
@export var turn_speed: float = 0.3

var mousex_delta:float = 0.0
var nearest_offset:float = 0.0
var nearest_point = Vector2.ZERO
var forward_point = Vector2.ZERO

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	velocity = Vector2.ZERO
	
func _physics_process(delta):    
	velocity = velocity.limit_length(max_speed)
	velocity *= 0.95
	update_rotation(mousex_delta, delta)
	nearest_offset = road_path.curve.get_closest_offset(self.position)
	nearest_point = road_path.curve.sample_baked(nearest_offset)
	forward_point = road_path.curve.sample_baked(nearest_offset+30)
	move_foward()
	
	mousex_delta = 0
	move_and_slide()


func _input(event):
	if event is InputEventMouseMotion:
		mousex_delta = event.relative.x

func move_foward() -> void:
	var center_dist = clampf(self.position.distance_to(nearest_point), 5, 1000)
	var push_force = (100/ center_dist) + 10
	var restrict_force = center_dist / 3 ** 2
		
	# get direction to forward road
	var road_dir : float = nearest_point.angle_to_point(forward_point)
	road_dir += PI / 2
	
	# rotate if close to center
	self.rotation = lerp_angle(self.rotation, road_dir, 10/(100+center_dist))
	push_force = clampf(push_force, 5, 100)
	self.velocity += self.position.direction_to(nearest_point) * restrict_force
	self.velocity += Vector2.UP.rotated(self.rotation) * push_force

func update_rotation(turn_input: float, delta: float) -> void:
	rotation += turn_input * turn_speed * delta


func _on_reflector_out_dir(angle, pos) -> void:
	self.rotation = lerp_angle(self.rotation, angle + Vector2.DOWN.angle(), 1)
	self.position = pos
	velocity = Vector2.RIGHT.rotated(angle) * 1000
