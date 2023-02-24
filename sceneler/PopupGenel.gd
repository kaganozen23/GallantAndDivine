extends Popup

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("popuplar")
	
func _on_TamamButonu_pressed():
	hide()
#	queue_free()


func _on_PopupGenel_popup_hide():
	release_focus()
	queue_free()


