extends Popup

signal tamam

func _ready():
	add_to_group("popuplar")

func _on_HayirButonu_pressed():
	queue_free()

func _on_PopupOnay_popup_hide():
#	emit_signal("tamam")
	queue_free()

func _on_EvetButonu_pressed():
	Evrensel.veriler["secim_cevabi"] = true
	emit_signal("tamam")
	get_parent().emit_signal("onay")	#cagirildigi scripte sinyali yolluyor
	queue_free()
	#buraya döndürdüğü mesaj yazılacak
