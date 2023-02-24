extends PopupPanel

onready var esya_konteyner = $DikeyBolucu/CerceveOrtalayici/EsyaKonteyner
onready var esya_kutusu = $DikeyBolucu/CerceveOrtalayici/EsyaKonteyner/Cerceve
var evrensel_gorev

var bir_kalite_kutusu = load("res://resimler/esyalar/cerceveler/1.webp")
var iki_kalite_kutusu = load("res://resimler/esyalar/cerceveler/2.webp")
var uc_kalite_kutusu = load("res://resimler/esyalar/cerceveler/3.webp")
var dort_kalite_kutusu = load("res://resimler/esyalar/cerceveler/4.webp")
var bes_kalite_kutusu = load("res://resimler/esyalar/cerceveler/5.webp")

func baslat(tanri_gorevi,ana_gorev):
	$DikeyBolucu/Ust/GorevIsmi.text = ana_gorev.baslik
	$DikeyBolucu/Ust/KalanSure.text = tanri_gorevi.suresi
	$DikeyBolucu/AsamaOrtalayici/GorevAsama.max_value = int(ana_gorev.gorev_tamamlama_sarti)
	$DikeyBolucu/AsamaOrtalayici/GorevAsama.value = int(tanri_gorevi.gorev_sarti_sayisi)
	$DikeyBolucu/AsamaOrtalayici/GorevAsama/GorevAsamaYazisi2.text = String ($DikeyBolucu/AsamaOrtalayici/GorevAsama.value) +" / "+String($DikeyBolucu/AsamaOrtalayici/GorevAsama.max_value)
	$DikeyBolucu/Aciklama.text = ana_gorev.aciklama
	evrensel_gorev = ana_gorev
		

func _ready():
	if evrensel_gorev.zorluk_seviyesi == "1":	#kolay

		var esya_kutusu2 = esya_kutusu.duplicate()
		esya_kutusu2.texture = bes_kalite_kutusu
		esya_kutusu2.get_node("Esya/yuzde").text = "%60"
		esya_kutusu2.visible = true
		esya_konteyner.add_child(esya_kutusu2)
		
		var esya_kutusu3 = esya_kutusu.duplicate()
		esya_kutusu3.texture = dort_kalite_kutusu
		esya_kutusu3.get_node("Esya/yuzde").text = "%30"
		esya_kutusu3.visible = true
		esya_konteyner.add_child(esya_kutusu3)
		
		var esya_kutusu4 = esya_kutusu.duplicate()
		esya_kutusu4.texture = uc_kalite_kutusu
		esya_kutusu4.get_node("Esya/yuzde").text = "%10"
		esya_kutusu4.visible = true
		esya_konteyner.add_child(esya_kutusu4)
		
	elif evrensel_gorev.zorluk_seviyesi == "2":	#orta
		var esya_kutusu2 = esya_kutusu.duplicate()
		esya_kutusu2.texture = dort_kalite_kutusu
		esya_kutusu2.get_node("Esya/yuzde").text = "%60"
		esya_kutusu2.visible = true
		esya_konteyner.add_child(esya_kutusu2)
		
		var esya_kutusu3 = esya_kutusu.duplicate()
		esya_kutusu3.texture = uc_kalite_kutusu
		esya_kutusu3.get_node("Esya/yuzde").text = "%30"
		esya_kutusu3.visible = true
		esya_konteyner.add_child(esya_kutusu3)
		
		var esya_kutusu4 = esya_kutusu.duplicate()
		esya_kutusu4.texture = iki_kalite_kutusu
		esya_kutusu4.get_node("Esya/yuzde").text = "%10"
		esya_kutusu4.visible = true
		esya_konteyner.add_child(esya_kutusu4)
		
	else:	#zor
		var esya_kutusu2 = esya_kutusu.duplicate()
		esya_kutusu2.texture = iki_kalite_kutusu
		esya_kutusu2.get_node("Esya/yuzde").text = "%70"
		esya_kutusu2.visible = true
		esya_konteyner.add_child(esya_kutusu2)
		
		var esya_kutusu3 = esya_kutusu.duplicate()
		esya_kutusu3.texture = bir_kalite_kutusu
		esya_kutusu3.get_node("Esya/yuzde").text = "%30"
		esya_kutusu3.visible = true
		esya_konteyner.add_child(esya_kutusu3)


func _on_GorevPopup_popup_hide():
	queue_free()
