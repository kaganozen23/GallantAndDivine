extends Control

onready var zaman_bari = $Ana/DikeyBolucu/Ust/YatayBolucuUst/IkinciBolum/Ortalayici2/ZamanBar
onready var tanri_portre = $Ana/DikeyBolucu/Ust/YatayBolucuUst/IlkBolum/TanriPorteCerceve
onready var tween = Tween.new()
signal onay

func _ready():
	get_tree().set_current_scene(self)
	Evrensel.yukleniyor_goster()
	if Evrensel.kayit_dosyasi.load_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"]) == OK:
		if Evrensel.kayit_dosyasi.has_section("ses_ayarlari"):
			if Evrensel.kayit_dosyasi.get_value("ses_ayarlari","efekt") == false:
				$Ana/DikeyBolucu/Ust/YatayBolucuUst/IkinciBolum/ButonBar/Ses.pressed = true
			if Evrensel.kayit_dosyasi.get_value("ses_ayarlari","muzik") == false:
				$Ana/DikeyBolucu/Ust/YatayBolucuUst/IkinciBolum/ButonBar/Muzik.pressed = true
				
		if not Evrensel.kayit_dosyasi.has_section("ilk_giris%s" % Evrensel.veriler["oyuncu_evreni_id"]):
			Evrensel.kayit_dosyasi.set_value("ilk_giris%s" % Evrensel.veriler["oyuncu_evreni_id"],"deger",true)
			Evrensel.kayit_dosyasi.save_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"])
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Welcome to GaD!"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Welcome to the endless world of Gallant and Divine. For once, you are granted with all possesions. It is in your very hands to rule the universe! Create your own strategy in this mysterious journey."
			get_tree().get_current_scene().add_child(PopupGenel)
			PopupGenel.popup_centered()				
			
#	Evrensel.veriler.yielded = bilgileri_al()						
	add_child(tween)
	tween.interpolate_property($Ana/DikeyBolucu/Alt/YatayBolucu/DikeyBolucuAlt/Revelations/Revelations, "modulate", 
			Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1.5, 
			Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	


#func bilgileri_al():


func _process(delta):
	if Evrensel.veriler["bildirim_bayragi"]:
#		$Ana/DikeyBolucu/Ust/YatayBolucuUst/IkinciBolum/ButonBar/Bildirim.texture_normal = load ("res://resimler/bildirim_yeni.webp")
		bildirim_tween()
		Evrensel.veriler["bildirim_bayragi"] = false
	if Evrensel.veriler["evren_zamani"]:
		if zaman_bari.value != Evrensel.veriler["evren_zamani"]:
			zaman_bari.value = Evrensel.veriler["evren_zamani"]
			zaman_bari.get_node("ZamanBarYazisi").text = str(Evrensel.veriler["evren_zamani"])+"/100"
	if Evrensel.veriler["oyuncu_tanrisi"]:
		if tanri_portre.get_node("TanriIsmi").text != Evrensel.veriler["oyuncu_tanrisi"].isim:
			tanri_portre.get_node("TanriIsmi").text = Evrensel.veriler["oyuncu_tanrisi"].isim
		if not tanri_portre.get_node("TanriPortre").texture:
			var tanri_texture = load("res://resimler/tanrilar/portre/%s_portre_130_130.webp" % Evrensel.veriler["oyuncu_tanrisi"].isim)
			tanri_portre.get_node("TanriPortre").texture = tanri_texture
	#buraya tanri ozelliklerinin guncellemesi gelecek

func bildirim_tween():
	tween.repeat = true
	tween.start()

func _on_Galaksi_pressed():
	var galaksi = load(Evrensel.veriler["galaksi_sahnesi"]).instance()
	$Ana/DikeyBolucu.get_child(1).queue_free()
	$Ana/DikeyBolucu.add_child(galaksi)
	$Ana/DikeyBolucu.move_child(galaksi,1)


func _on_Journey_pressed():
	Evrensel.muzik_degistir("res://sesler/journey.ogg")
	var gorev = load(Evrensel.veriler["gorev_sahnesi"]).instance()
	$Ana/DikeyBolucu.get_child(1).queue_free()
	$Ana/DikeyBolucu.add_child(gorev)
	$Ana/DikeyBolucu.move_child(gorev,1)

func _on_Cikis_pressed():
	Evrensel._ready()	#tum evrensel.verileri sifirla
	var giris_sahnesi = load(Evrensel.veriler["giris_sahnesi"]).instance()
	get_tree().get_root().add_child(giris_sahnesi)
	queue_free()	

func _on_TanriPorteCerceve_pressed():
	var popup = load(Evrensel.veriler["tanri_bilgileri_popup"]).instance()
	popup.add_to_group("popuplar")
#	get_tree().get_current_scene().add_child(popup)
	add_child(popup)
	popup.popup_centered()


func _on_Possession_pressed():
	Evrensel.muzik_degistir("res://sesler/possession.ogg")
	var esya = load(Evrensel.veriler["esya_sahnesi"]).instance()
	$Ana/DikeyBolucu.get_child(1).queue_free()
	$Ana/DikeyBolucu.add_child(esya)
	$Ana/DikeyBolucu.move_child(esya,1)




func _on_Titanomahia_pressed():
	Evrensel.muzik_degistir("res://sesler/Juhani Junkala - Epic Boss Battle [Seamlessly Looping].ogg")
	var titanomakhia = load(Evrensel.veriler["titanomakhia_sahnesi"]).instance()
	$Ana/DikeyBolucu.get_child(1).queue_free()
	$Ana/DikeyBolucu.add_child(titanomakhia)
	$Ana/DikeyBolucu.move_child(titanomakhia,1)


func _on_Revelations_pressed():
	Evrensel.karsiya_gonder("26,%s" % Evrensel.veriler["oyuncu_tanrisi_id"])	#veritabanindaki bildirimleri sil
	tween.repeat = false
	tween.reset_all()
	tween.stop_all()
	var bildirim_sahnesi = load(Evrensel.veriler["bildirim_sahnesi"]).instance()
	$Ana/DikeyBolucu.get_child(1).queue_free()
	$Ana/DikeyBolucu.add_child(bildirim_sahnesi)
	$Ana/DikeyBolucu.move_child(bildirim_sahnesi,1)	


func _on_Causerie_pressed():	#chat ekrani acilir
	Evrensel.muzik_degistir("res://sesler/causerie.ogg")
	var chat_sahnesi = load(Evrensel.veriler["chat_sahnesi"]).instance()
	$Ana/DikeyBolucu.get_child(1).queue_free()
	$Ana/DikeyBolucu.add_child(chat_sahnesi)
	$Ana/DikeyBolucu.move_child(chat_sahnesi,1)	


func _on_Panteon_pressed():
	
	Evrensel.muzik_degistir("res://sesler/Land of fearless.ogg")
	var panteon = load(Evrensel.veriler["panteon_sahnesi"]).instance()
	$Ana/DikeyBolucu.get_child(1).queue_free()
	$Ana/DikeyBolucu.add_child(panteon)
	$Ana/DikeyBolucu.move_child(panteon,1)


func _on_Muzik_pressed():
	if Evrensel.kayit_dosyasi.load_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"]) == OK:
		if Evrensel.kayit_dosyasi.has_section("ses_ayarlari"):
			var yeni_muzik_ayari = not Evrensel.kayit_dosyasi.get_value("ses_ayarlari","muzik")
			Evrensel.kayit_dosyasi.set_value("ses_ayarlari","muzik",yeni_muzik_ayari)
			Evrensel.muzik_sesi = yeni_muzik_ayari
			if yeni_muzik_ayari:
				get_tree().call_group("muzikler","play")
			else:
				get_tree().call_group("muzikler","stop")
			Evrensel.kayit_dosyasi.save_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"])


func _on_Ses_pressed():
	if Evrensel.kayit_dosyasi.load_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"]) == OK:
		if Evrensel.kayit_dosyasi.has_section("ses_ayarlari"):
			var yeni_efekt_ayari = not Evrensel.kayit_dosyasi.get_value("ses_ayarlari","efekt")
			Evrensel.kayit_dosyasi.set_value("ses_ayarlari","efekt",yeni_efekt_ayari)
			Evrensel.efekt_sesi = yeni_efekt_ayari
			if yeni_efekt_ayari:
				get_tree().call_group("efektler","play")
			else:
				get_tree().call_group("efektler","stop")
			Evrensel.kayit_dosyasi.save_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"])
