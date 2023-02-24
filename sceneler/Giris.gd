extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().set_current_scene(self)

func _on_Credits_pressed():
	var credits_sahnesi = load("res://sceneler/tali_sahneler/Credits.tscn").instance()
	add_child(credits_sahnesi)
