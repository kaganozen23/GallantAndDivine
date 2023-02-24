extends TextureRect

var yeni_tanri
onready var roma_rune = $TanriSembolleri/VBoxContainer/HBoxContainer/Roma
onready var sumer_rune = $TanriSembolleri/VBoxContainer/HBoxContainer/Sumer
onready var misir_rune = $TanriSembolleri/VBoxContainer/HBoxContainer/Misir
onready var yunan_rune = $TanriSembolleri/VBoxContainer/HBoxContainer/Yunan
onready var iskandinav_rune = $TanriSembolleri/VBoxContainer/HBoxContainer/Iskandinav
signal onay

func _ready():
	Evrensel.muzik_degistir("res://sesler/Heroic Demise.ogg")
	yeni_tanri = $TanriGrid/GridContainer/Tanri.duplicate()
	$TanriGrid/GridContainer/Tanri.visible = false
	Evrensel.veriler["yielded"] = tanrilari_doldur()

	
func tanrilari_doldur():
	Evrensel.yukleniyor_goster()
	Evrensel.karsiya_gonder("1")
	yield()
	roma_rune.emit_signal("pressed")
	Evrensel.yukleniyor_kaybet()
		
func _on_TextureButton_pressed():
	Evrensel.sahne_degistir(get_tree().get_current_scene(),Evrensel.veriler["server_secim_sahnesi"])


func _on_Roma_pressed():
	roma_rune.pressed = true
	for node in $TanriGrid/GridContainer.get_children():
		node.free()
	$TanriGrid/TanriGridBaslik.text= "Roman Gods"
	for tanri in Evrensel.veriler["tum_tanrilar"]:
		if tanri.koken == "roman":
			var tanri_texture = load("res://resimler/tanrilar/portre/%s_portre_130_130.webp" % tanri.isim)
			var eklenecek_tanri = yeni_tanri.duplicate()
			eklenecek_tanri.get_node("TanriPortre").texture = tanri_texture
			eklenecek_tanri.name = tanri.isim
			eklenecek_tanri.visible = true
			eklenecek_tanri.hint_tooltip = tanri.iyi_mi
			eklenecek_tanri.connect("pressed",self,"_on_tanri_pressed",[eklenecek_tanri])
			$TanriGrid/GridContainer.add_child(eklenecek_tanri)
	$TanriGrid/GridContainer.get_child(0).emit_signal("pressed")
	for child in $TanriSembolleri/VBoxContainer/HBoxContainer.get_children():
		if child.name != "Roma":
			child.pressed = false

func _on_Sumer_pressed():
	sumer_rune.pressed = true
	for node in $TanriGrid/GridContainer.get_children():
		node.free()
	$TanriGrid/TanriGridBaslik.text= "Sumerian Gods"
	for tanri in Evrensel.veriler["tum_tanrilar"]:
		if tanri.koken == "sumerian":
			var tanri_texture = load("res://resimler/tanrilar/portre/%s_portre_130_130.webp" % tanri.isim)
			var eklenecek_tanri = yeni_tanri.duplicate()
			eklenecek_tanri.get_node("TanriPortre").texture = tanri_texture
			eklenecek_tanri.name = tanri.isim
			eklenecek_tanri.visible = true
			eklenecek_tanri.hint_tooltip = tanri.iyi_mi
			eklenecek_tanri.connect("pressed",self,"_on_tanri_pressed",[eklenecek_tanri])
			$TanriGrid/GridContainer.add_child(eklenecek_tanri)
	$TanriGrid/GridContainer.get_child(0).emit_signal("pressed")
	for child in $TanriSembolleri/VBoxContainer/HBoxContainer.get_children():
		if child.name != "Sumer":
			child.pressed = false

func _on_Misir_pressed():
	misir_rune.pressed = true
	for node in $TanriGrid/GridContainer.get_children():
		node.free()
	$TanriGrid/TanriGridBaslik.text= "Egyptian Gods"
	for tanri in Evrensel.veriler["tum_tanrilar"]:
		if tanri.koken == "egyptian":
			var tanri_texture = load("res://resimler/tanrilar/portre/%s_portre_130_130.webp" % tanri.isim)
			var eklenecek_tanri = yeni_tanri.duplicate()
			eklenecek_tanri.get_node("TanriPortre").texture = tanri_texture
			eklenecek_tanri.name = tanri.isim
			eklenecek_tanri.visible = true
			eklenecek_tanri.hint_tooltip = tanri.iyi_mi
			eklenecek_tanri.connect("pressed",self,"_on_tanri_pressed",[eklenecek_tanri])
			$TanriGrid/GridContainer.add_child(eklenecek_tanri)
	$TanriGrid/GridContainer.get_child(0).emit_signal("pressed")
	for child in $TanriSembolleri/VBoxContainer/HBoxContainer.get_children():
		if child.name != "Misir":
			child.pressed = false

func _on_Yunan_pressed():
	yunan_rune.pressed = true
	for node in $TanriGrid/GridContainer.get_children():
		node.free()
	$TanriGrid/TanriGridBaslik.text= "Greek Gods"
	for tanri in Evrensel.veriler["tum_tanrilar"]:
		if tanri.koken == "greek":
			var tanri_texture = load("res://resimler/tanrilar/portre/%s_portre_130_130.webp" % tanri.isim)
			var eklenecek_tanri = yeni_tanri.duplicate()
			eklenecek_tanri.get_node("TanriPortre").texture = tanri_texture
			eklenecek_tanri.name = tanri.isim
			eklenecek_tanri.visible = true
			eklenecek_tanri.hint_tooltip = tanri.iyi_mi
			eklenecek_tanri.connect("pressed",self,"_on_tanri_pressed",[eklenecek_tanri])
			$TanriGrid/GridContainer.add_child(eklenecek_tanri)
	$TanriGrid/GridContainer.get_child(0).emit_signal("pressed")
	for child in $TanriSembolleri/VBoxContainer/HBoxContainer.get_children():
		if child.name != "Yunan":
			child.pressed = false

func _on_Iskandinav_pressed():
	iskandinav_rune.pressed = true
	for node in $TanriGrid/GridContainer.get_children():
		node.free()
	$TanriGrid/TanriGridBaslik.text= "Scandinavian Gods"
	for tanri in Evrensel.veriler["tum_tanrilar"]:
		if tanri.koken == "scandinavian":
			var tanri_texture = load("res://resimler/tanrilar/portre/%s_portre_130_130.webp" % tanri.isim)
			var eklenecek_tanri = yeni_tanri.duplicate()
			eklenecek_tanri.get_node("TanriPortre").texture = tanri_texture
			eklenecek_tanri.name = tanri.isim
			eklenecek_tanri.visible = true
			eklenecek_tanri.hint_tooltip = tanri.iyi_mi
			eklenecek_tanri.connect("pressed",self,"_on_tanri_pressed",[eklenecek_tanri])
			$TanriGrid/GridContainer.add_child(eklenecek_tanri)
	$TanriGrid/GridContainer.get_child(0).emit_signal("pressed")
	for child in $TanriSembolleri/VBoxContainer/HBoxContainer.get_children():
		if child.name != "Iskandinav":
			child.pressed = false
			
func _on_tanri_pressed(buton):
	for node in $TanriGrid/GridContainer.get_children():
		node.pressed = false
	buton.pressed = true
	$TanriBuyuk/Container/TanriBuyukResim/TanriIsmi.text = "Virtuos God: " + buton.name.to_upper() if buton.hint_tooltip == "True" else "Evil God: " + buton.name.to_upper()
	var tanri_buyuk_texture = load ("res://resimler/tanrilar/buyuk/%s_290_470.webp" % buton.name)
	$TanriBuyuk/Container/TanriBuyukResim.texture = tanri_buyuk_texture
	barlari_doldur(buton)

func barlari_doldur(buton):
	for bar in $TanriBuyuk/Container/Barlar.get_children():
		bar.value = 0
	for tanri in Evrensel.veriler["tum_tanrilar"]:
		if tanri.isim == buton.name:
			Evrensel.veriler["oyuncu_tanrisi"] = tanri
	if Evrensel.veriler["oyuncu_tanrisi"] != null:
		var tween = Tween.new()
		add_child(tween)
		tween.interpolate_property($TanriBuyuk/Container/Barlar/WarfareBar, "value", 0, int(Evrensel.veriler["oyuncu_tanrisi"].savas_yetenegi), 1, Tween.TRANS_QUAD, Tween.EASE_OUT)
		$TanriBuyuk/Container/Barlar/WarfareBar/WarfareBarText.text = Evrensel.veriler["oyuncu_tanrisi"].savas_yetenegi
		tween.interpolate_property($TanriBuyuk/Container/Barlar/CalamityBar,"value", 0, int(Evrensel.veriler["oyuncu_tanrisi"].felaket_yetenegi), 1, Tween.TRANS_QUAD, Tween.EASE_OUT)
		$TanriBuyuk/Container/Barlar/CalamityBar/CalamityBarText.text = Evrensel.veriler["oyuncu_tanrisi"].felaket_yetenegi
		tween.interpolate_property($TanriBuyuk/Container/Barlar/ChaosBar,"value", 0, int(Evrensel.veriler["oyuncu_tanrisi"].kaos_yetenegi), 1, Tween.TRANS_QUAD, Tween.EASE_OUT)
		$TanriBuyuk/Container/Barlar/ChaosBar/ChaosBarText.text = Evrensel.veriler["oyuncu_tanrisi"].kaos_yetenegi
		tween.interpolate_property($TanriBuyuk/Container/Barlar/FortuneBar,"value", 0, int(Evrensel.veriler["oyuncu_tanrisi"].ekonomi_yetenegi), 1, Tween.TRANS_QUAD, Tween.EASE_OUT)
		$TanriBuyuk/Container/Barlar/FortuneBar/FortuneBarText.text = Evrensel.veriler["oyuncu_tanrisi"].ekonomi_yetenegi
		tween.interpolate_property($TanriBuyuk/Container/Barlar/DivineBar,"value", 0, int(Evrensel.veriler["oyuncu_tanrisi"].ilahi_yetenegi), 1, Tween.TRANS_QUAD, Tween.EASE_OUT)		
		$TanriBuyuk/Container/Barlar/DivineBar/DivineBarText.text = Evrensel.veriler["oyuncu_tanrisi"].ilahi_yetenegi
		tween.interpolate_property($TanriBuyuk/Container/Barlar/RenaissanceBar,"value", 0, int(Evrensel.veriler["oyuncu_tanrisi"].ronesans_yetenegi), 1, Tween.TRANS_QUAD, Tween.EASE_OUT)		
		$TanriBuyuk/Container/Barlar/RenaissanceBar/RenaissanceBarText.text = Evrensel.veriler["oyuncu_tanrisi"].ronesans_yetenegi
		tween.start()

func _on_TanriSecim_pressed():
	yield(secim_popup_goster(),"completed")
	if(Evrensel.veriler["secim_cevabi"]):
		Evrensel.efekt_ver("res://sesler/tanrisecim.ogg")
		Evrensel.veriler["secim_cevabi"] = false
		if Evrensel.veriler["oyuncu"].id and Evrensel.veriler["oyuncu_evreni_id"] and Evrensel.veriler["oyuncu_tanrisi"]:
			var tanri_id = null
			for tanri in Evrensel.veriler["tum_tanrilar"]:
				if tanri.isim == Evrensel.veriler["oyuncu_tanrisi"].isim:
					tanri_id = tanri.id
			if tanri_id:
				Evrensel.yukleniyor_goster()
				Evrensel.karsiya_gonder(("5,%s,%s,%s" % [Evrensel.veriler["oyuncu"].id, Evrensel.veriler["oyuncu_evreni_id"], tanri_id] ))	


func secim_popup_goster():
	var PopupOnay = load("res://sceneler/PopupOnay.tscn").instance()
	PopupOnay.get_node("Arkaplan/Metin/Metin").text = "Are you sure that you want to choose one of '%s' '%s' as your permanent possession?\nYour choice will affect both your and others destiny!" % [$TanriGrid/TanriGridBaslik.text, Evrensel.veriler["oyuncu_tanrisi"].isim.to_upper()]
	get_tree().get_current_scene().add_child(PopupOnay)
	PopupOnay.popup_centered()
	yield(PopupOnay,"tamam")


