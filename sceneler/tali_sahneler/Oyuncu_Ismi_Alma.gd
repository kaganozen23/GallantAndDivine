extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var regex_isim = RegEx.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	regex_isim.compile("^[a-zA-Z0-9]*$")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureButton_pressed():
	if (regex_isim.search($ColorRect/VBoxContainer/TextEdit.text) and $ColorRect/VBoxContainer/TextEdit.text.length() >=3 and $ColorRect/VBoxContainer/TextEdit.text.length() <=10):
		$ColorRect/VBoxContainer/Ikaz.text = ""
		Evrensel.karsiya_gonder("992,%s,%s" % [$ColorRect/VBoxContainer/TextEdit.text,Evrensel.veriler["oyuncu"].id])
		Evrensel.yukleniyor_goster()
		Evrensel.veriler["oyuncu"].nick = $ColorRect/VBoxContainer/TextEdit.text
	else:
		$ColorRect/VBoxContainer/Ikaz.text = "Please Enter a Valid Name!"
