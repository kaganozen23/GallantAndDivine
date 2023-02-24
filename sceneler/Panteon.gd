extends TextureRect

signal onay
onready var secilen_panteon_id = null
var delta_holder = 0
var yeni_satir
onready var tanri_listesi = $AnaPanteon/Barlar/Ortabar/TextureRect/VBoxContainer2/VBoxContainer/ColorRect/ScrollContainer/TanriListesi
var section_keys : PoolStringArray
var section_key_count = 0
const max_mesaj = 100
onready var metin_kutusu = $AnaPanteon/Barlar/Ortabar/VBoxContainer/Causerie/Ana_Konteyner/GonderKutusu/TextEdit
onready var mesaj_kutusu = $AnaPanteon/Barlar/Ortabar/VBoxContainer/Causerie/Ana_Konteyner/MesajlarKutusu/ScrollContainer/Mesajlar

func _process(delta):
	delta_holder += delta
	if (delta_holder > 10):
		Evrensel.veriler.yielded = panteon_kontrol(false)
		delta_holder = 0

	if Evrensel.kayit_dosyasi.has_section("panteon_chat%s" % Evrensel.veriler['oyuncu_tanrisi_id']):
		section_keys = Evrensel.kayit_dosyasi.get_section_keys("panteon_chat%s" % Evrensel.veriler['oyuncu_tanrisi_id'])
	var anlik_mesaj_sayisi = section_keys.size()
	if anlik_mesaj_sayisi != section_key_count:
		section_keys.invert()	
		mesaj_kutusu.text = ""		
		for key in section_keys:
			mesaj_kutusu.text += Evrensel.kayit_dosyasi.get_value("panteon_chat%s" % Evrensel.veriler['oyuncu_tanrisi_id'],key) #+ "\n"
		if anlik_mesaj_sayisi > max_mesaj:
			for i in (anlik_mesaj_sayisi- max_mesaj):
				Evrensel.kayit_dosyasi.erase_section_key("panteon_chat%s" % Evrensel.veriler['oyuncu_tanrisi_id'],section_keys[anlik_mesaj_sayisi-i])
			Evrensel.kayit_dosyasi.save_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"])
		section_key_count = anlik_mesaj_sayisi
	

# Called when the node enters the scene tree for the first time.
func _ready():
	if Evrensel.kayit_dosyasi.load_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"]) != OK:
		mesaj_kutusu.text = String(Evrensel.kayit_dosyasi.load_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"]))
		set_process(false)
	set_process(false)
	yeni_satir = tanri_listesi.get_node("Tanri").duplicate()
	Evrensel.veriler.yielded = panteon_kontrol()

func panteon_kontrol(ilk_calisma=true):
	if ilk_calisma:
		Evrensel.yukleniyor_goster()
		Evrensel.karsiya_gonder("8,%s" % Evrensel.veriler["oyuncu_tanrisi_id"])	#tanri bilgilerini guncelle
		Evrensel.karsiya_gonder("53")
		yield()
		yield()
	if (Evrensel.veriler.oyuncu_tanrisi["birlik_id"] == "None"):
		if (Evrensel.tanri_toplam_gucu_hesapla() < 12000):	#burasi panteonu olmasi icin gerekli toplam gucu belirme yeri
			$YetersizGuc.visible = true
			$YetersizGuc.get_node("Merkezleyici/YetersizGucMetni").text += str (12000-Evrensel.tanri_toplam_gucu_hesapla())
		else:	#15000'i asmis ama panteonu yok.
			Evrensel.karsiya_gonder("1")	#ana tanrilarin listesini al
			yield()
			for ana_tanri in Evrensel.veriler["tum_tanrilar"]:
				if Evrensel.veriler.oyuncu_tanrisi["tanri_tipi"] == ana_tanri["id"]:
					Evrensel.karsiya_gonder("53")	#tum panteonlari al
					yield()
					PanteonSecimSekillendir(ana_tanri["iyi_mi"])
	else:	#tanrinin panteonu var
		set_process(true)
		$AnaPanteon.visible = true	
		Evrensel.karsiya_gonder("55,%s" % Evrensel.veriler['oyuncu_tanrisi_id'])
		yield()
		oyunculari_yazdir()
		panteonu_yazdir()
	Evrensel.yukleniyor_kaybet()
		
func oyunculari_yazdir():
	for ch in tanri_listesi.get_children():
		ch.queue_free()
	if (Evrensel.veriler['panteon_tanrilari']):
		var offline_texture = load("res://resimler/offline.webp")
		var online_texture = load("res://resimler/online.webp")
		for tanri in Evrensel.veriler['panteon_tanrilari']:
			tanri = tanri.split(",")
			yeni_satir = yeni_satir.duplicate()
			yeni_satir.visible = true
			yeni_satir.get_node("TanriIsmi").text = tanri[1] + "(" + tanri[2] + ")"
			if tanri[0] == "0":	#offline
				yeni_satir.get_node("Online").texture = offline_texture
				tanri_listesi.add_child(yeni_satir)
			else:
				yeni_satir.get_node("Online").texture = online_texture
				tanri_listesi.add_child(yeni_satir)
				tanri_listesi.move_child(tanri_listesi.get_child(tanri_listesi.get_child_count()-1),1)
				
func panteonu_yazdir():
	if (Evrensel.veriler['ana_panteonlar'] and Evrensel.veriler['oyuncu_tanrisi']):
		for ana_panteon in Evrensel.veriler['ana_panteonlar']:
			if ana_panteon.id == Evrensel.veriler['oyuncu_tanrisi'].birlik_id:
				$AnaPanteon/Barlar/ColorRect/Ustbar/PanteonResmi.texture = load ("res://resimler/panteonlar/%s.webp" % ana_panteon.isim.to_lower().replace(" ","_"))
				$AnaPanteon/Barlar/ColorRect/Ustbar/VBoxContainer/PanteonIsmi.text = ana_panteon.isim
				$AnaPanteon/Barlar/ColorRect/Ustbar/VBoxContainer/PanteonBonusu.text = ana_panteon.bonusu

					
func PanteonSecimSekillendir(iyilik):
#	for panteon in Evrensel.veriler.ana_panteonlar:
	if iyilik == "True":
		for panteon in Evrensel.veriler.ana_panteonlar:
			if panteon.iyi_mi == "True":
				match panteon.tipi:
					"Roman":
						$PanteonSecim.get_node("UstPanteonlar/RomanTexture").texture_normal = load ("res://resimler/panteonlar/%s.webp" % panteon.isim.to_lower().replace(" ","_"))
						$PanteonSecim.get_node("UstPanteonlar/RomanTexture/Metni").text = panteon.isim
						$PanteonSecim.get_node("UstPanteonlar/RomanTexture").connect("pressed",self,"_on_panteon_pressed",[panteon])
					"Sumerian":
						$PanteonSecim.get_node("UstPanteonlar/SumerianTexture").texture_normal = load ("res://resimler/panteonlar/%s.webp" % panteon.isim.to_lower().replace(" ","_"))
						$PanteonSecim.get_node("UstPanteonlar/SumerianTexture/Metni").text = panteon.isim
						$PanteonSecim.get_node("UstPanteonlar/SumerianTexture").connect("pressed",self,"_on_panteon_pressed",[panteon])
					"Egyptian":
						$PanteonSecim.get_node("OrtaPanteon/CenterContainer/EgyptianTexture").texture_normal = load ("res://resimler/panteonlar/%s.webp" % panteon.isim.to_lower().replace(" ","_"))
						$PanteonSecim.get_node("OrtaPanteon/CenterContainer/EgyptianTexture/Metni").text = panteon.isim
						$PanteonSecim.get_node("OrtaPanteon/CenterContainer/EgyptianTexture").connect("pressed",self,"_on_panteon_pressed",[panteon])
					"Greek":
						$PanteonSecim.get_node("AltPanteonlar/GreekTexture").texture_normal = load ("res://resimler/panteonlar/%s.webp" % panteon.isim.to_lower().replace(" ","_"))
						$PanteonSecim.get_node("AltPanteonlar/GreekTexture/Metni").text = panteon.isim
						$PanteonSecim.get_node("AltPanteonlar/GreekTexture").connect("pressed",self,"_on_panteon_pressed",[panteon])
					"Scandinavian":
						$PanteonSecim.get_node("AltPanteonlar/ScandinavianTexture").texture_normal = load ("res://resimler/panteonlar/%s.webp" % panteon.isim.to_lower().replace(" ","_"))
						$PanteonSecim.get_node("AltPanteonlar/ScandinavianTexture/Metni").text = panteon.isim
						$PanteonSecim.get_node("AltPanteonlar/ScandinavianTexture").connect("pressed",self,"_on_panteon_pressed",[panteon])
	if iyilik == "False":
		for panteon in Evrensel.veriler.ana_panteonlar:
			if panteon.iyi_mi == "False":
				match panteon.tipi:
					"Roman":
						$PanteonSecim.get_node("UstPanteonlar/RomanTexture").texture_normal = load ("res://resimler/panteonlar/%s.webp" % panteon.isim.to_lower().replace(" ","_"))
						$PanteonSecim.get_node("UstPanteonlar/RomanTexture/Metni").text = panteon.isim
						$PanteonSecim.get_node("UstPanteonlar/RomanTexture").connect("pressed",self,"_on_panteon_pressed",[panteon])
					"Sumerian":
						$PanteonSecim.get_node("UstPanteonlar/SumerianTexture").texture_normal = load ("res://resimler/panteonlar/%s.webp" % panteon.isim.to_lower().replace(" ","_"))
						$PanteonSecim.get_node("UstPanteonlar/SumerianTexture/Metni").text = panteon.isim
						$PanteonSecim.get_node("UstPanteonlar/SumerianTexture").connect("pressed",self,"_on_panteon_pressed",[panteon])
					"Egyptian":
						$PanteonSecim.get_node("OrtaPanteon/CenterContainer/EgyptianTexture").texture_normal = load ("res://resimler/panteonlar/%s.webp" % panteon.isim.to_lower().replace(" ","_"))
						$PanteonSecim.get_node("OrtaPanteon/CenterContainer/EgyptianTexture/Metni").text = panteon.isim
						$PanteonSecim.get_node("OrtaPanteon/CenterContainer/EgyptianTexture").connect("pressed",self,"_on_panteon_pressed",[panteon])
					"Greek":
						$PanteonSecim.get_node("AltPanteonlar/GreekTexture").texture_normal = load ("res://resimler/panteonlar/%s.webp" % panteon.isim.to_lower().replace(" ","_"))
						$PanteonSecim.get_node("AltPanteonlar/GreekTexture/Metni").text = panteon.isim
						$PanteonSecim.get_node("AltPanteonlar/GreekTexture").connect("pressed",self,"_on_panteon_pressed",[panteon])
					"Scandinavian":
						$PanteonSecim.get_node("AltPanteonlar/ScandinavianTexture").texture_normal = load ("res://resimler/panteonlar/%s.webp" % panteon.isim.to_lower().replace(" ","_"))
						$PanteonSecim.get_node("AltPanteonlar/ScandinavianTexture/Metni").text = panteon.isim
						$PanteonSecim.get_node("AltPanteonlar/ScandinavianTexture").connect("pressed",self,"_on_panteon_pressed",[panteon])
						
	$PanteonSecim.visible = true

func _on_panteon_pressed(panteon):
	secilen_panteon_id = panteon.id
	var PopupOnay = load("res://sceneler/PopupOnay.tscn").instance()
	PopupOnay.get_node("Arkaplan/Metin/Metin").text = \
	"You are about to choose '%s' as your pantheon. \nBonus: %s.\nAre you sure?" % [panteon.isim,panteon.bonusu]
	add_child(PopupOnay)
	PopupOnay.popup_centered()

func _on_Panteon_onay():
	Evrensel.karsiya_gonder("54,%s,%s" % [secilen_panteon_id,Evrensel.veriler.oyuncu_tanrisi_id])	#panteon kayit
	Evrensel.yukleniyor_goster()




func _on_TextEdit_gui_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			if OS.has_virtual_keyboard():
				OS.hide_virtual_keyboard()
			if not $AnaPanteon/Barlar/Ortabar/VBoxContainer/Causerie/Ana_Konteyner/GonderKutusu/Mum1.disabled:
				$AnaPanteon/Barlar/Ortabar/VBoxContainer/Causerie/Ana_Konteyner/GonderKutusu/Mum1.emit_signal("pressed")
	elif event is InputEventMouseButton:
		if event.pressed:
			if metin_kutusu.text == "Type here!":
				metin_kutusu.text = ""			


func _on_TextEdit_focus_exited():
#	metin_kutusu.text = "Type here!"
	pass


func _on_Mum1_pressed():
	$AnaPanteon/Barlar/Ortabar/VBoxContainer/Causerie/Ana_Konteyner/GonderKutusu/Mum1.disabled = true
	$AnaPanteon/Barlar/Ortabar/VBoxContainer/Causerie/Ana_Konteyner/GonderKutusu/Mum1/Particles2D.emitting = false
	var hazir_mesaj = ""
	if metin_kutusu.text != "Type here!" or metin_kutusu.text =="":
		hazir_mesaj = (Evrensel.veriler["oyuncu_tanrisi"].evren_id + "," + \
		Evrensel.veriler["oyuncu"].nick + "(" +Evrensel.veriler["oyuncu_tanrisi"].isim + ")" + "," +\
		Evrensel.veriler["oyuncu_tanrisi"].birlik_id + "," + " -> " + metin_kutusu.text).replace("\n","").replace("\r","") + "\n"
		Evrensel.karsiya_gonder("996," + hazir_mesaj)
	metin_kutusu.release_focus()
	metin_kutusu.text = "Type here!"
	Evrensel.timer_yarat(self).start()
	
func _timer_doldu():
	$AnaPanteon/Barlar/Ortabar/VBoxContainer/Causerie/Ana_Konteyner/GonderKutusu/Mum1.disabled = false
	$AnaPanteon/Barlar/Ortabar/VBoxContainer/Causerie/Ana_Konteyner/GonderKutusu/Mum1/Particles2D.emitting = true


func _on_TextEdit_text_changed():
	metin_kutusu.get_node("Label").text = str(metin_kutusu.text.length()) + "/250"
	if (metin_kutusu.text.length() > 250):
		metin_kutusu.text = metin_kutusu.text.left(250)
		metin_kutusu.get_node("Label").text = "250/250"
		metin_kutusu.release_focus()
