extends CharacterBody2D

# @onready var level0: Path2D = $"../Level0"
# @onready var level1: Path2D = $"../Level1"
@onready var test_label: Label = $"../HUD/TestLabel"
@onready var circle_bar: ColorRect = $"../HUD/CircleBar"
@onready var ghost: Node2D = $"../Ghost"
@onready var level_selector: Node = $"../LevelSelector"

@export var acceleration: float = 500.0
@export var max_speed: float = 1000.0
@export var turn_speed: float = 0.3
@export var spd_on_dist: Curve
var impact = preload("res://Scenes/impact.tscn")

var mousex_delta:float = 0.0
var nearest_offset:float = 0.0
var nearest_point = Vector2.ZERO
var forward_point = Vector2.ZERO

var closest_reflector = null
var closest_reflector_distance = INF

func _ready() -> void:
	velocity = Vector2.ZERO

func _physics_process(delta):
	if Global.state == Global.READY or Global.state == Global.TITLE:
		# set position to start of the curve
		self.position = level_selector.road_path.curve.sample_baked(0)
		self.rotation = level_selector.road_path.curve.get_point_out(0).angle()
	if Global.state == Global.STARTED:
		check_closest_reflector()
		velocity = velocity.limit_length(max_speed)
		velocity *= 0.95
		update_rotation(mousex_delta, delta)
		update_pathfollow()
		nearest_offset = level_selector.road_path.curve.get_closest_offset(self.position)
		nearest_point = level_selector.road_path.curve.sample_baked(nearest_offset)
		forward_point = level_selector.road_path.curve.sample_baked(nearest_offset+30)
		move_to_follower()
		move_and_slide()


func _input(event):
	if event is InputEventMouseMotion:
		mousex_delta += event.relative.x
		# update test_label text to mousex_delta
		test_label.text = str(mousex_delta)
		circle_bar.material.set_shader_parameter("fill_ratio", -mousex_delta/1000)
	if event.is_action_pressed("ui_accept"):
		# if distance is < 100
		if closest_reflector != null and closest_reflector_distance < 100:
			print("Closest enemy distance: " + str(closest_reflector_distance))
			print("Closest enemy rotation: " + str(closest_reflector.rotation))
			reflection_to(closest_reflector.rotation, closest_reflector.global_position)
			# add impact instance to the position
			var impact_instance = impact.instantiate()
			impact_instance.global_position = closest_reflector.global_position
			get_parent().add_child(impact_instance)


func move_forward() -> void:
	# var push_force = (100/ center_dist) + 10
	# var restrict_force = center_dist / 3 ** 2
	# get direction to forward road
	# var road_dir : float = nearest_point.angle_to_point(forward_point)
	# road_dir += PI / 2
	# rotate if close to center
	# self.rotation = lerp_angle(self.rotation, road_dir, 10/(100+center_dist))
	# push_force = clampf(push_force, 5, 100)
	# self.velocity += Vector2.UP.rotated(self.rotation) * push_force
	pass
#
func update_pathfollow() -> void:
	var center_dist = self.position.distance_to(level_selector.path_follow_player.position)
	var spd = spd_on_dist.sample(center_dist/1000.0)
	level_selector.path_follow_player.progress += spd
	# level_selector.path_follow_player.progress += 10.0


func update_rotation(turn_input: float, delta: float) -> void:
	rotation += turn_input * turn_speed * delta


func reflection_to(angle, pos) -> void:
	self.rotation = lerp_angle(self.rotation, angle + Vector2.DOWN.angle(), 1)
	# self.position = pos
	velocity = Vector2.RIGHT.rotated(angle) * velocity.length()


func check_closest_reflector():
	closest_reflector= null
	closest_reflector_distance = INF
	for reflector in get_tree().get_nodes_in_group("Reflector"):
		var distance = reflector.global_position.distance_to(global_position)
		if distance < closest_reflector_distance:
			closest_reflector_distance = distance
			closest_reflector=reflector 

# move toward pathfollower2d.
func move_to_follower() -> void:
	var center_dist = clampf(self.position.distance_to(nearest_point), 5, 1000)
	var followerDirXVec: Vector2 = Vector2.from_angle(level_selector.path_follow_player.rotation)
	var followerDirYVec: Vector2 = Vector2.from_angle(level_selector.path_follow_player.rotation).rotated(PI/2)
	var followerDist: Vector2 = level_selector.path_follow_player.position - self.position
	self.rotation = lerp_angle(self.rotation, followerDirXVec.angle(), 0.01)
	self.position += followerDirXVec.dot(followerDist) * followerDirXVec.normalized() / followerDirXVec.length()
	self.velocity += Vector2.from_angle(self.rotation) * 10.0
	self.velocity += followerDirYVec.dot(followerDist) * followerDirYVec.normalized() / followerDirYVec.length() * 0.01
