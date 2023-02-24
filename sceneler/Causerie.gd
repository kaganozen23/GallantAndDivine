extends TextureRect

onready var metin_kutusu = $Ana_Konteyner/GonderKutusu/TextEdit
onready var mesaj_kutusu = $Ana_Konteyner/MesajlarKutusu/ScrollContainer/Mesajlar
var section_keys : PoolStringArray
var section_key_count = 0
const max_mesaj = 100

func _on_TextEdit_gui_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			if OS.has_virtual_keyboard():
				OS.hide_virtual_keyboard()
			$Ana_Konteyner/GonderKutusu/Mum1.emit_signal("pressed")
	elif event is InputEventMouseButton:
		if event.pressed:
			if metin_kutusu.text == "Type your text here!":
				metin_kutusu.text = ""			
		




func _on_Mum1_pressed():
	$Ana_Konteyner/GonderKutusu/Mum1.disabled = true
	$Ana_Konteyner/GonderKutusu/Mum1/Particles2D.emitting = false
	var hazir_mesaj = ""
	if metin_kutusu.text != "Type your text here!":
		hazir_mesaj = (Evrensel.veriler["oyuncu_tanrisi"].evren_id + "," + \
		Evrensel.veriler["oyuncu"].nick + "(" +Evrensel.veriler["oyuncu_tanrisi"].isim + ")" +\
		" -> " + metin_kutusu.text).replace("\n","").replace("\r","")
		Evrensel.karsiya_gonder("997," + hazir_mesaj)
	metin_kutusu.release_focus()
	metin_kutusu.text = "Type your text here!"
	Evrensel.timer_yarat(self).start()	

func _timer_doldu():
	$Ana_Konteyner/GonderKutusu/Mum1.disabled = false
	$Ana_Konteyner/GonderKutusu/Mum1/Particles2D.emitting = true
	
	
func _process(delta):
	if Evrensel.kayit_dosyasi.has_section("evrensel_chat%s" % Evrensel.veriler['oyuncu_tanrisi_id']):
		section_keys = Evrensel.kayit_dosyasi.get_section_keys("evrensel_chat%s" % Evrensel.veriler['oyuncu_tanrisi_id'])
	var anlik_mesaj_sayisi = section_keys.size()
	if anlik_mesaj_sayisi != section_key_count:
		section_keys.invert()	
		mesaj_kutusu.text = ""		
		for key in section_keys:
			mesaj_kutusu.text += Evrensel.kayit_dosyasi.get_value("evrensel_chat%s" % Evrensel.veriler['oyuncu_tanrisi_id'],key) + "\n"
		if anlik_mesaj_sayisi > max_mesaj:
			for i in (anlik_mesaj_sayisi- max_mesaj):
				Evrensel.kayit_dosyasi.erase_section_key("evrensel_chat%s" % Evrensel.veriler['oyuncu_tanrisi_id'],section_keys[anlik_mesaj_sayisi-i])
			Evrensel.kayit_dosyasi.save_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"])
		section_key_count = anlik_mesaj_sayisi
		

func _on_TextEdit_focus_exited():
#	metin_kutusu.text = "Type your text here!"
	pass

func _ready():
	if Evrensel.kayit_dosyasi.load_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"]) != OK:
		mesaj_kutusu.text = String(Evrensel.kayit_dosyasi.load_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"]))
		set_process(false)


func _on_Panteon_pressed():
	var panteon = load(Evrensel.veriler["panteon_sahnesi"]).instance()
	get_parent().add_child(panteon)
	get_parent().move_child(panteon,1)
	queue_free()
	


func _on_TextEdit_text_changed():
	$Ana_Konteyner/GonderKutusu/TextEdit/Label.text = str($Ana_Konteyner/GonderKutusu/TextEdit.text.length()) + "/250"
	if ($Ana_Konteyner/GonderKutusu/TextEdit.text.length() > 250):
		$Ana_Konteyner/GonderKutusu/TextEdit.text = $Ana_Konteyner/GonderKutusu/TextEdit.text.left(250)
		$Ana_Konteyner/GonderKutusu/TextEdit/Label.text = "250/250"
		metin_kutusu.release_focus()
