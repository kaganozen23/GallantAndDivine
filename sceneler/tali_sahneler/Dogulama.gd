extends Control

onready var email = get_tree().get_current_scene().get_node("LoginKutusu").get_node("VBoxContainer/Email").text
onready var sifre = get_tree().get_current_scene().get_node("LoginKutusu").get_node("VBoxContainer/Sifre").text

func _ready():
	grab_focus()


func _on_TextureButton_pressed():
	if email:
		if $ColorRect/VBoxContainer/TextEdit.text:
			if (int($ColorRect/VBoxContainer/TextEdit.text) < 1000000 and int($ColorRect/VBoxContainer/TextEdit.text) > 100000):
				Evrensel.karsiya_gonder("994,%s,%s" % [email,$ColorRect/VBoxContainer/TextEdit.text])
				Evrensel.yukleniyor_goster()
			else:
				hata_yazisi()
		else:
			hata_yazisi()
					
			
func hata_yazisi():
	$ColorRect/VBoxContainer/CenterContainer/TextureButton.disabled = true
	$ColorRect/VBoxContainer/Ikaz.text = "Please Enter a Valid Auth Code!"
	$Timer.start()
	
func _on_Timer_timeout():
	$ColorRect/VBoxContainer/Ikaz.text = ""
	$ColorRect/VBoxContainer/CenterContainer/TextureButton.disabled = false
