extends CanvasLayer

@onready var target_time_container: VBoxContainer = $VBox
@onready var medal_textures: Dictionary = {
	"gold": $VBox/HBoxGold/TextureRect,
	"silver": $VBox/HBoxSilver/TextureRect,
	"bronze": $VBox/HBoxBronze/TextureRect,
}
@onready var medal_labels: Dictionary = {
	"gold": $VBox/HBoxGold/Label,
	"silver": $VBox/HBoxSilver/Label,
	"bronze": $VBox/HBoxBronze/Label,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	# when pressed enter key, anim medal
	# if Input.is_action_just_pressed("ui_accept"):
	# 	# anim_medal("gold")
	# 	anim_medal("silver")
	# 	# anim_medal("bronze")

func anim_medal(medal: String) -> void:
	# emphasis effect using scale
	var medal_node: TextureRect = medal_textures[medal]
	# if gold, make bronze and silver also active
	# if silver, make bronze also active
	medal_node.material.set_shader_parameter("active", true)
	if medal == "gold":
		medal_textures["silver"].material.set_shader_parameter("active", true)
		medal_textures["bronze"].material.set_shader_parameter("active", true)
	elif medal == "silver":
		medal_textures["bronze"].material.set_shader_parameter("active", true)
	
	# write your code here.


	var tween: Tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(target_time_container, "scale", Vector2(1.0, 1.0), 0.3)
	tween.parallel().tween_property(target_time_container, "position", Vector2(850, 230), 0.3)
	tween.tween_interval(0.3)
	tween.tween_property(medal_node, "scale", Vector2(1.2, 1.2), 0.1)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(medal_node, "scale", Vector2(1, 1), 0.1)
	tween.tween_interval(1.0)
	tween.tween_property(target_time_container, "scale", Vector2(0.4, 0.4), 0.3)
	tween.parallel().tween_property(target_time_container, "position", Vector2(1000, 30), 0.3)


func update_target_times() -> void:
	if not is_node_ready():
		await ready
	var achievement: String = Global.achievements[Global.current_stage]
	for medal: String in ["gold", "silver", "bronze"]:
		medal_labels[medal].text = "%.2f" % Global.target_times[Global.current_stage][medal]

	for texture: TextureRect in medal_textures.values():
		texture.material.set_shader_parameter("active", false)

	if achievement == "gold":
		medal_textures["gold"].material.set_shader_parameter("active", true)
		medal_textures["silver"].material.set_shader_parameter("active", true)
		medal_textures["bronze"].material.set_shader_parameter("active", true)
	elif achievement == "silver":
		medal_textures["silver"].material.set_shader_parameter("active", true)
		medal_textures["bronze"].material.set_shader_parameter("active", true)
	elif achievement == "bronze":
		medal_textures["bronze"].material.set_shader_parameter("active", true)


