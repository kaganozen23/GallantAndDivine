extends Popup

onready var esya_kontrol = load(Evrensel.veriler["esya_kontrol_scripti"]).new(get_tree().get_current_scene())
var esya
signal onay
var galaksi
var yildiz

func baslat(yeni_esya,ana_esya,g=null,y=null):
	$TextureRect/VBoxContainer/EsyaCenter.add_child(yeni_esya.get_node("EsyaCerceve").duplicate())
	$TextureRect/VBoxContainer/CenterContainer2/EsyaIsmi.text = ana_esya.isim
	$TextureRect/VBoxContainer/CenterContainer3/EsyaAciklamasi.text = ana_esya.ozeti
	$TextureRect/VBoxContainer/CenterContainer5/NeIseYaradigi.text = ana_esya.ne_ise_yaradigi
	esya = ana_esya
	galaksi = g
	yildiz = y
	

func _ready():
	add_to_group("popuplar")
	if esya:	#esya varsa, ana sahne cagirmissa
		match esya.tipi:
			"1":	#kendine
				$TextureRect/VBoxContainer/CenterContainer4/Use.disabled = false
			"3":	#goreve
				$TextureRect/VBoxContainer/CenterContainer4/Use.disabled = false
			"5":	#toplama item,, bunun yeter sayida oldugunun esya_kontrolde
				$TextureRect/VBoxContainer/CenterContainer4/Use.disabled = false
				
	if get_parent().get_node("TextureRect/ScrollContainer/TabContainer").get_child_count() == 1:
		$TextureRect/VBoxContainer/CenterContainer4/Use.disabled = false


func _on_Control_popup_hide():
	queue_free()


func _on_CikisButon_pressed():
	hide()


func _on_Use_pressed():
	var PopupOnay = load("res://sceneler/PopupOnay.tscn").instance()
	var esya_kullanim_yeri = ""
	if galaksi:
		PopupOnay.get_node("Arkaplan/Metin/Metin").text = "Are you sure you want to use %s on %s?" % [esya.isim,galaksi.isim]
	elif yildiz:
		PopupOnay.get_node("Arkaplan/Metin/Metin").text = "Are you sure you want to use %s on %s?" % [esya.isim,yildiz.adi]
	else:
		if esya.tipi != "5":
			PopupOnay.get_node("Arkaplan/Metin/Metin").text = "Are you sure you want to use %s on yourself?" % esya.isim
		if esya.tipi == "5":
			PopupOnay.get_node("Arkaplan/Metin/Metin").text = "Are you sure you want to use %s?" % esya.isim
	PopupOnay.get_node(".").rect_scale = Vector2 (0.7,0.7)
#	PopupOnay.get_node("Arkaplan/Metin/Metin").align = 1	#center
	add_child(PopupOnay)
	PopupOnay.popup_centered()



func _on_Control_onay():
	if get_parent().get_parent().get_class() == "Popup":
#		get_parent().queue_free()
		get_parent().get_parent().queue_free()	#esya sahnesinin parent popupini free et. Tum cocuklari da gitsin.
	esya_kontrol.esya_kullan(esya,galaksi,yildiz)
	queue_free()
