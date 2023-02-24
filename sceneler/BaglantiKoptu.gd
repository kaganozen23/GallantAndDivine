extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	grab_focus()
	var tween = Tween.new()
	add_child(tween)
	tween.repeat = true
	tween.interpolate_property($Arkaplan/Metin, "modulate", 
	  Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2, 
	  Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
