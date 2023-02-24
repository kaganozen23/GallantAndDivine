extends Control

var GalaksiBilgileri
var yeni_yaratik
var resimler = []
var local_yield = null
var yaratik_sesleri = []
var yaratik_seslendirici = AudioStreamPlayer.new()
signal onay

func baslat(Galaksi):
	GalaksiBilgileri = Galaksi

func _process(delta):
	if not yaratik_seslendirici.playing:
		randomize()
		yaratik_sesleri.shuffle()
		yaratik_seslendirici.stream = load(yaratik_sesleri[0])
		yaratik_seslendirici.play()
	
func _ready():
	if not self.is_a_parent_of(yaratik_seslendirici):
		add_child(yaratik_seslendirici)
	yaratik_sesleri = ["res://sesler/yaratik_sesleri/yaratik_sesi1.wav",
	"res://sesler/yaratik_sesleri/yaratik_sesi2.wav",
	"res://sesler/yaratik_sesleri/yaratik_sesi3.wav",
	"res://sesler/yaratik_sesleri/yaratik_sesi4.wav",
	"res://sesler/yaratik_sesleri/yaratik_sesi5.wav",
	"res://sesler/yaratik_sesleri/yaratik_sesi6.wav",
	"res://sesler/yaratik_sesleri/yaratik_sesi7.wav",
	"res://sesler/yaratik_sesleri/yaratik_sesi8.wav",
	"res://sesler/yaratik_sesleri/yaratik_sesi9.wav",
	"res://sesler/yaratik_sesleri/yaratik_sesi10.wav"]

	resimler = ["res://resimler/yaratiklar/basilisk.webp",
				"res://resimler/yaratiklar/centaur.webp",
				"res://resimler/yaratiklar/echidna.webp",
				"res://resimler/yaratiklar/fairy.webp",
				"res://resimler/yaratiklar/goblin2.webp",
				"res://resimler/yaratiklar/griffon.webp",
				"res://resimler/yaratiklar/hydra.webp",
				"res://resimler/yaratiklar/kappa.webp",
				"res://resimler/yaratiklar/Manananggal.webp",
				"res://resimler/yaratiklar/medusa.webp",
				"res://resimler/yaratiklar/satyr.webp",
				"res://resimler/yaratiklar/siren.webp",
				"res://resimler/yaratiklar/slyph.webp",
				"res://resimler/yaratiklar/wendigo.webp"]
	Evrensel.veriler["tum_yaratiklar"] = []
	Evrensel.veriler["galaksi_yaratiklari"] = []
	$Arkaplan/GalaksiIsmi.text = GalaksiBilgileri.isim
	yeni_yaratik = $Arkaplan/ScrollContainer/YildizlarGrid/YildizCerceve.duplicate()
	yeni_yaratik.modulate = Color(1,1,1,0)
	for child in $Arkaplan/ScrollContainer/YildizlarGrid.get_children():
		child.queue_free()
#	$Arkaplan/ScrollContainer/YildizlarGrid/YildizCerceve.queue_free()
	Evrensel.veriler.yielded = yaratik_bilgilerini_al()

func yaratik_bilgilerini_al():
	Evrensel.yukleniyor_goster()
	if not Evrensel.veriler["tum_yaratiklar"]:
		Evrensel.veriler["client"].get_peer(1).put_packet( ("10".to_utf8() ) )	#tum yaratiklari al
		yield()
	Evrensel.karsiya_gonder("12," + Evrensel.veriler["oyuncu_tanrisi_id"] ) #tanri haklarini sorgula
	Evrensel.veriler["client"].get_peer(1).put_packet( ("11," + str(GalaksiBilgileri.id)).to_utf8()  )	#evren yaratiklarini al
	Evrensel.karsiya_gonder("94,%s" % Evrensel.veriler["oyuncu_tanrisi_id"])	#trizul sorgu cevabi
	yield()
	yield()
	yield()
	yaratik_bilgilerini_isle()
	Evrensel.yukleniyor_kaybet()
		
func _on_Yildizlar_pressed():
	$Arkaplan/Yaratiklar.pressed = false
	$Arkaplan/Yildizlar.pressed = true
	if ($Arkaplan/ScrollContainer/YildizlarGrid.get_child_count() > 0):
		yaratiklari_kaybet()
	else:
		_on_tween2_completed()
	
func yaratiklari_kaybet():
	var tween2 = Tween.new()
	add_child(tween2)
	tween2.connect("tween_all_completed",self,"_on_tween2_completed")
	for y in $Arkaplan/ScrollContainer/YildizlarGrid.get_children():
#		y.get_node("Yildiz").disconnect("pressed",self,"_on_yildiz_pressed")
		tween2.interpolate_property(y, "modulate", 
		Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.3, 
		Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween2.start()

func _on_tween2_completed():
	var IcGalaksi = load(Evrensel.veriler["ic_galaksi_sahnesi"]).instance()
	IcGalaksi.baslat(GalaksiBilgileri)	#verileri yeni sahnenin baslat fonk. yolla
	get_parent().add_child(IcGalaksi)
	get_parent().move_child(IcGalaksi,1)
	queue_free()
	
func _on_Yaratiklar_pressed():
	$Arkaplan/Yildizlar.pressed = false
	$Arkaplan/Yaratiklar.pressed = true
	var Yaratik = load(Evrensel.veriler["yaratik_sahnesi"]).instance()
	Yaratik.baslat(GalaksiBilgileri)	#verileri yeni sahnenin baslat fonk. yolla
	get_parent().add_child(Yaratik)
	get_parent().move_child(Yaratik,1)
	queue_free()
		
func yaratik_bilgilerini_isle():
	$Arkaplan/TextureRect/label/SavasHakki.text = Evrensel.veriler["tanri_haklari"].yaratik_savas_hakki
	randomize()
	resimler.shuffle()
	var tween3 = Tween.new()
	add_child(tween3)
	for yaratik_kumesi in Evrensel.veriler["galaksi_yaratiklari"]:
		var yaratik = yeni_yaratik.duplicate()
		yaratik.get_node("Yildiz").texture_normal = load(resimler.pop_front())
		$Arkaplan/ScrollContainer/YildizlarGrid.add_child(yaratik)
		tween3.interpolate_property(yaratik, "modulate", 
		Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.3, 
		Tween.TRANS_QUAD, Tween.EASE_OUT)
		yaratik.get_node("Yildiz").connect("pressed",self,"_on_yaratik_pressed",[yaratik_kumesi])
	tween3.start()


func _on_yaratik_pressed(yaratik_kumesi):
	var tum_yaratiklar = Evrensel.veriler["tum_yaratiklar"]
	var metin = "This Creature Pack Consist of the following;\n"
	var toplam_guc = 0
	for yaratik in yaratik_kumesi.yaratiklari:
		for ana_yaratik in tum_yaratiklar:
			if yaratik.yaratik_tipi == ana_yaratik.id:
				metin += String(yaratik.yaratik_miktari) + " x " + ana_yaratik.isim + "\n"
				toplam_guc += int(yaratik.yaratik_miktari) * int(ana_yaratik.gucu)
	metin += "With a total power of %d\n" % toplam_guc
	if int($Arkaplan/TextureRect/label/SavasHakki.text) > 0:
		metin += "Are you sure you want to banish these monsters?"
	local_yield = yield(secim_popup_goster(metin),"completed")
	if(Evrensel.veriler["secim_cevabi"]):	#emri verdiyse
		Evrensel.veriler["secim_cevabi"] = false
		yaratiklarla_savas(toplam_guc,yaratik_kumesi,tum_yaratiklar)
		
	
func secim_popup_goster(metin):
	var PopupOnay = load("res://sceneler/PopupOnay.tscn").instance()
	if int($Arkaplan/TextureRect/label/SavasHakki.text) <= 0:
		PopupOnay.get_node("Arkaplan/Baslik/Baslik").text = "Information"
		PopupOnay.get_node("Arkaplan/Metin/EvetButonu").hide()
		PopupOnay.get_node("Arkaplan/Metin/HayirButonu").hide()
	PopupOnay.get_node("Arkaplan/Metin/Metin").text = metin
	PopupOnay.get_node("Arkaplan/Metin/Metin").align = 1	#center
#	get_tree().get_current_scene().add_child(PopupOnay)
	add_child(PopupOnay)
	PopupOnay.popup_centered()
	local_yield = yield(PopupOnay,"tamam")
				

func yaratiklarla_savas(toplam_guc,yaratik_kumesi,tum_yaratiklar):
	var popupyaratik = load (Evrensel.veriler["yaratik_savasi_sonrasi_popup"]).instance()
	get_tree().get_current_scene().add_child(popupyaratik)
	popupyaratik.popup_centered()
	local_yield = yield(popupyaratik,"tamam")
	var verilecek_yetenek = Evrensel.veriler.secim_cevabi
	Evrensel.veriler.secim_cevabi = false
	var tanri_gucu = Evrensel.tanri_toplam_gucu_hesapla()
	if Evrensel.veriler.trizul:
		tanri_gucu = tanri_gucu + int(tanri_gucu/4)
	var tanriya_verilecek_guc = 0
	var metin = " At timeslice %d you have basnished following;\n" % Evrensel.veriler["evren_zamani"]
#	Evrensel.yukleniyor_goster()
	if tanri_gucu >= toplam_guc:
		for yaratik in yaratik_kumesi.yaratiklari:
			for ana_yaratik in tum_yaratiklar:
				if yaratik.yaratik_tipi == ana_yaratik.id:
					if int(yaratik.yaratik_miktari) != 0:
						metin += String(yaratik.yaratik_miktari) + " x " + ana_yaratik.isim + "\n"
						tanriya_verilecek_guc += int(yaratik.yaratik_miktari)
		metin += "and wiped them out of the universe!\n"
		metin += "You have gained a total power of %d in return" % tanriya_verilecek_guc
		Evrensel.karsiya_gonder("19,"+String(yaratik_kumesi.id) +","+Evrensel.veriler["oyuncu_tanrisi_id"])
	else:
		var kume_yaratiklari_toplam_gucu = 0
		for yaratik in yaratik_kumesi.yaratiklari:
			for ana_yaratik in tum_yaratiklar:
				if yaratik.yaratik_tipi == ana_yaratik.id:
					kume_yaratiklari_toplam_gucu += int(ana_yaratik.gucu)
		
		var oldurulecek_ortalama_yaratik_sayisi = int(tanri_gucu / kume_yaratiklari_toplam_gucu)
		var oldurme_sayilari = []
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		for yaratik in yaratik_kumesi.yaratiklari:
			oldurme_sayilari.append(rng.randi_range(oldurulecek_ortalama_yaratik_sayisi/2,oldurulecek_ortalama_yaratik_sayisi*2))
		var i=0
		while i < len (yaratik_kumesi.yaratiklari):
			if oldurme_sayilari[i] > int(yaratik_kumesi.yaratiklari[i].yaratik_miktari):
				oldurme_sayilari[i] = int(yaratik_kumesi.yaratiklari[i].yaratik_miktari)	#asmayacagindan emin olmak
			i += 1
	
		var j=0
		for yaratik in yaratik_kumesi.yaratiklari:
			for ana_yaratik in tum_yaratiklar:
				if yaratik.yaratik_tipi == ana_yaratik.id:
					metin += String(oldurme_sayilari[j]) + " x " + ana_yaratik.isim + "\n"
					yaratik.yaratik_miktari	= String( int(yaratik.yaratik_miktari)-oldurme_sayilari[j])	
					tanriya_verilecek_guc += oldurme_sayilari[j]
					j+=1
		metin += "You have gained a total power of %d in return" % tanriya_verilecek_guc
		var insert_text = ""
		for yaratik in yaratik_kumesi.yaratiklari:
			if int(yaratik.yaratik_miktari) != 0:
				insert_text += String(yaratik.yaratik_tipi) + "," + String(yaratik.yaratik_miktari) + ","
		insert_text.erase(insert_text.length()-1,1)
#		print(insert_text)
		Evrensel.karsiya_gonder("20,"+ insert_text + "," + String(yaratik_kumesi.id) + "," + Evrensel.veriler["oyuncu_tanrisi_id"])
	#tanriya gucu ilave et
	Evrensel.karsiya_gonder("21,"+verilecek_yetenek+","+String(tanriya_verilecek_guc)+","+Evrensel.veriler["oyuncu_tanrisi_id"])
	#tanrinin yaratik savas hakkini azalt
	Evrensel.karsiya_gonder("17,yaratik_savas_hakki,"+Evrensel.veriler["oyuncu_tanrisi_id"])
	#tanri bilgilerini guncelle
	Evrensel.karsiya_gonder("8,%s" % Evrensel.veriler["oyuncu_tanrisi_id"]) 	#oyuncu tanri bilgilerini al
#	dosya_kaydi_yap(metin)
	Evrensel.Bildirim_Sinifi.new([ Evrensel.veriler["oyuncu_tanrisi_id"], "30", metin.replace("\n","; ") ])		
	var sonuc_sahnesi = load(Evrensel.veriler["emir_sonrasi_sahnesi"]).instance()
	sonuc_sahnesi.get_node("Timer").wait_time = 5
	sonuc_sahnesi.baslat(load(resimler[0]),metin)
	add_child(sonuc_sahnesi)
	Evrensel.timer_yarat(self,5,true)
	

func _timer_doldu():	#evrensel timerin triggeri
	sahneyi_yeniden_yukle()


func sahneyi_yeniden_yukle():
	var Yaratik = load(Evrensel.veriler["yaratik_sahnesi"]).instance()
	Yaratik.baslat(GalaksiBilgileri)	#verileri yeni sahnenin baslat fonk. yolla
	get_parent().add_child(Yaratik)
	get_parent().move_child(Yaratik,1)
	queue_free()		

func dosya_kaydi_yap(metin):
		if Evrensel.kayit_dosyasi.load_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"]) == OK:
			
			Evrensel.kayit_dosyasi.set_value("savas","yaratik",Evrensel.kayit_dosyasi.get_value("savas","yaratik"," ")+"\n\n"+metin)
		Evrensel.kayit_dosyasi.save_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"])
	

func _on_TextureButton_pressed():
	var galaksi = load(Evrensel.veriler["galaksi_sahnesi"]).instance()
	get_parent().get_child(1).queue_free()
	get_parent().add_child(galaksi)
	get_parent().move_child(galaksi,1)
	queue_free()


#history fonksiyonu, butonu cikarilarak iptal edildi
"""
func _on_History_pressed():
	if $Arkaplan/TextureRect/TextureRect2.visible == false:
#		$Arkaplan/TextureRect/TextureRect2.show()
		$Arkaplan/TextureRect/TextureRect2.visible = true
	elif $Arkaplan/TextureRect/TextureRect2.visible == true:
		print("hide")
		$Arkaplan/TextureRect/TextureRect2.hide()
		$Arkaplan/TextureRect/TextureRect2.visible = false
		
	$Arkaplan/TextureRect/TextureRect2.show()
	if Evrensel.kayit_dosyasi.has_section("savas"):
		if Evrensel.kayit_dosyasi.has_section_key("savas","yaratik"):
			$Arkaplan/TextureRect/TextureRect2/ColorRect/MarginContainer/ScrollContainer/VBoxContainer/GecmisLabel.text =	Evrensel.kayit_dosyasi.get_value("savas","yaratik")	
"""				

func _on_Clear_pressed():
	if Evrensel.kayit_dosyasi.has_section("savas"):
		if Evrensel.kayit_dosyasi.has_section_key("savas","yaratik"):
			Evrensel.kayit_dosyasi.erase_section_key("savas","yaratik")
			Evrensel.kayit_dosyasi.save_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"])
	$Arkaplan/TextureRect/TextureRect2/ColorRect/MarginContainer/ScrollContainer/VBoxContainer/GecmisLabel.text = ""


func _on_UsePossession_pressed():
	var esya_sahnesi = load(Evrensel.veriler["esya_sahnesi"]).instance()
	var anlik_popup = Popup.new()
	anlik_popup.rect_size = Vector2(550,750)
	anlik_popup.add_child(esya_sahnesi)
	add_child(anlik_popup)
	esya_sahnesi.baslat("Creatures",3)
	anlik_popup.popup_centered()
