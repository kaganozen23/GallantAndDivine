extends Popup

var secim = null
signal tamam

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("popuplar")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Warfare_pressed():
	secim = "savas_yetenegi"
	hide()
	queue_free()

func _on_Calamity_pressed():
	secim = "felaket_yetenegi"
	hide()
	queue_free()


func _on_Chaos_pressed():
	secim = "kaos_yetenegi"
	hide()
	queue_free()


func _on_Fortune_pressed():
	secim = "ekonomi_yetenegi"
	hide()
	queue_free()


func _on_Divine_pressed():
	secim = "ilahi_yetenegi"
	hide()
	queue_free()


func _on_Renaissance_pressed():
	secim = "ronesans_yetenegi"
	hide()
	queue_free()

func _on_Main_popup_hide():
	Evrensel.veriler.secim_cevabi = secim
	emit_signal("tamam")
