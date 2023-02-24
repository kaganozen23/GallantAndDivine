extends Control

signal exited

func baslat(gelen_texture,mesaj):
	$TextureRect.texture = gelen_texture
	$Mesaj.text = mesaj


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect.grab_focus()
	var tween = Tween.new()
	add_child(tween)
	tween.repeat = true
	tween.interpolate_property($Mesaj, "modulate", 
	  Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, 
	  Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.interpolate_property($TextureRect,"rect_scale",
			Vector2(0,0), Vector2(1,1), 5, 
			Tween.TRANS_BOUNCE , Tween.EASE_OUT)
	tween.start()


func _on_Timer_timeout():
	queue_free()


func _on_Ana_tree_exiting():
	emit_signal("exited")
	pass # Replace with function body.
