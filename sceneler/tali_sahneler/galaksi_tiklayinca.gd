extends Popup

var galaksi

func baslat(g):
	galaksi = g
	$TextureRect/Label.text = galaksi.isim

func _ready():
	pass # Replace with function body.

func _on_DiveIn_pressed():
	get_parent().emit_signal("dive_in",galaksi)
	hide()


func _on_UsePossession_pressed():
	get_parent().emit_signal("use_possession",galaksi)
	hide()


func _on_Main_popup_hide():
	queue_free()
