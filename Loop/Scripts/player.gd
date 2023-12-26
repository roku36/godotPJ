extends CharacterBody2D

@onready var test_label: Label = $"../HUD/TestLabel"
@onready var circle_bar: ColorRect = $"../HUD/CircleBar"
@onready var ghost: Node2D = $"../Ghost"
@onready var level_selector: Node = $"../LevelSelector"

@export var acceleration: float = 500.0
@export var max_speed: float = 1000.0
@export var turn_speed: float = 0.1
@export var spd_on_dist: Curve
@export var limit_on_dist: Curve
@export var limit_width: float = 100.0
var impact: PackedScene = preload("res://Scenes/impact.tscn")

var mousex_delta:float = 0.0

var closest_reflector: Node2D = null
var closest_reflector_distance: float = INF

func _ready() -> void:
	velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	mousex_delta = lerp(mousex_delta, 0.0, 0.02)
	circle_bar.material.set_shader_parameter("fill_ratio", -mousex_delta/1000)
	if Global.state == Global.READY or Global.state == Global.TITLE or Global.state == Global.LAUNCH:
		# set position to start of the curve
		self.position = level_selector.road_path.curve.sample_baked(0)
		self.rotation = level_selector.road_path.curve.get_point_out(0).angle()
	if Global.state == Global.STARTED:
		check_closest_reflector()
		velocity = velocity.limit_length(max_speed)
		# damp
		velocity *= 0.95
		update_rotation(mousex_delta, delta)
		# update_pathfollow()
		move_to_follower()
		move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mousex_delta += event.relative.x
		# update test_label text to mousex_delta
		test_label.text = str(mousex_delta)
		# circle_bar.material.set_shader_parameter("fill_ratio", -mousex_delta/1000)
	if event.is_action_pressed("ui_accept"):
		# if distance is < 100
		if closest_reflector != null and closest_reflector_distance < 100:
			print("Closest enemy distance: " + str(closest_reflector_distance))
			print("Closest enemy rotation: " + str(closest_reflector.rotation))
			reflection_to(closest_reflector.rotation, closest_reflector.global_position)
			# add impact instance to the position
			var impact_instance: Node2D = impact.instantiate()
			impact_instance.global_position = closest_reflector.global_position
			get_parent().add_child(impact_instance)


func update_rotation(turn_input: float, delta: float) -> void:
	rotation += turn_input * turn_speed * delta


func reflection_to(angle: float, _pos: Vector2) -> void:
	# self.rotation = lerp_angle(self.rotation, angle + Vector2.DOWN.angle(), 1)
	self.rotation = angle
	# self.position = pos
	velocity = Vector2.RIGHT.rotated(angle) * velocity.length()


func check_closest_reflector() -> void:
	closest_reflector= null
	closest_reflector_distance = INF
	for reflector in get_tree().get_nodes_in_group("Reflector"):
		var distance: float = reflector.global_position.distance_to(global_position)
		if distance < closest_reflector_distance:
			closest_reflector_distance = distance
			closest_reflector=reflector 

# move toward pathfollower2d.
func move_to_follower() -> void:
	var followerDirXVec: Vector2 = Vector2.from_angle(level_selector.path_follow_player.rotation)
	var followerDirYVec: Vector2 = Vector2.from_angle(level_selector.path_follow_player.rotation).rotated(PI/2)
	var followerDist: Vector2 = level_selector.path_follow_player.position - self.position
	# self.rotation = lerp_angle(self.rotation, followerDirXVec.angle(), 0.03)
	# self.position += followerDirXVec * followerDist.dot(followerDirXVec)

	var XVec_dist: float = -followerDist.dot(followerDirXVec.normalized())
	var YVec_dist: float = followerDist.dot(followerDirYVec.normalized())
	level_selector.path_follow_player.progress += XVec_dist * 0.5
	level_selector.path_follow_player.progress_ratio = clamp(level_selector.path_follow_player.progress_ratio, 0.0, 1.0)
	# self.velocity += Vector2.from_angle(self.rotation) * 30.0
	var spd: float = spd_on_dist.sample(abs(YVec_dist)/300.0)
	self.velocity += Vector2.from_angle(self.rotation) * spd

	# YVec_dist and velocity is same direction, add 1 to spd_on_dist
	# var YVec_velocity: float = self.velocity.dot(followerDirYVec.normalized())
	# print YVec_dist and YVec_velocity
	if YVec_dist < 0:
		self.get_node("Icon").modulate= Color.RED
	else:
		self.get_node("Icon").modulate= Color.GREEN
	
	if Vector2.from_angle(self.rotation).dot(followerDirYVec) < 0:
		self.get_node("ColorRect").color = Color.RED
	else:
		self.get_node("ColorRect").color = Color.GREEN
		
	# if (Vector2.from_angle(self.rotation).dot(followerDirYVec) > 0) == (YVec_dist > 0):
	# if ((Vector2.from_angle(self.rotation).dot(followerDirYVec) < 0) and (YVec_dist < 0)) or \
	# 	((Vector2.from_angle(self.rotation).dot(followerDirYVec) > 0) and (YVec_dist > 0)):
	# 	self.velocity += Vector2.from_angle(self.rotation) * 10.0
	
	var limit_ratio: float = limit_on_dist.sample(abs(YVec_dist)/limit_width)

	# if YVec_dist > 100 or YVec_dist < -100:
	# 	self.velocity -= (self.velocity.dot(followerDirYVec.normalized()) - YVec_dist* 0.01) * followerDirYVec.normalized()

	if self.velocity.dot(followerDirYVec) * YVec_dist < 0:
		self.velocity -= followerDirYVec * (self.velocity.dot(followerDirYVec.normalized()) * limit_ratio)

	# # 方向成分に減衰を適用
	# var dir_component: Vector2 = self.velocity.dot(followerDirYVec.normalized()) * followerDirYVec.normalized()
	# self.velocity += (dir_component * 0.98) - dir_component

