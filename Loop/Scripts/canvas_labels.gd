extends CanvasLayer

# array of node,
# Gold
# Silver
# Bronze
# $VBox/HBox/TextureRect/{{medal}}
@onready var medal_labels: Dictionary = {
	"Gold": $VBox/HBoxGold/TextureRect,
	"Silver": $VBox/HBoxSilver/TextureRect,
	"Bronze": $VBox/HBoxBronze/TextureRect,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# when pressed enter key, anim medal
	if Input.is_action_just_pressed("ui_accept"):
		# anim_medal("Gold")
		anim_medal("Silver")
		# anim_medal("Bronze")

func anim_medal(medal: String) -> void:
	# emphasis effect using scale
	var medal_node: TextureRect = medal_labels[medal]
	# if gold, make bronze and silver also active
	# if silver, make bronze also active
	medal_node.material.set_shader_parameter("active", true)
	if medal == "Gold":
		medal_labels["Silver"].material.set_shader_parameter("active", true)
		medal_labels["Bronze"].material.set_shader_parameter("active", true)
	elif medal == "Silver":
		medal_labels["Bronze"].material.set_shader_parameter("active", true)
	
	# write your code here.


	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(medal_node, "scale", Vector2(1.2, 1.2), 0.1)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(medal_node, "scale", Vector2(1, 1), 0.1)

