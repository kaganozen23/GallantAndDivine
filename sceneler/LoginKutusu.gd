extends TextureRect

func _ready():
	Evrensel.muzik_degistir("res://sesler/FoxieEpic.OGG")
	if Evrensel.kayit_dosyasi.load_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"]) == OK:
		if Evrensel.kayit_dosyasi.has_section("kullanici_bilgileri"):
			if Evrensel.kayit_dosyasi.get_value("kullanici_bilgileri","kolay_giris"):
				$VBoxContainer/Email.text = Evrensel.kayit_dosyasi.get_value("kullanici_bilgileri","kullanici_adi")			
				$VBoxContainer/Sifre.text = Evrensel.kayit_dosyasi.get_value("kullanici_bilgileri","sifre")
				$VBoxContainer/Remember/RememberCheckBox.pressed = true

func _on_Giris_pressed():
	Evrensel.yukleniyor_goster()
	if $VBoxContainer/Remember/RememberCheckBox.pressed == true:
		Evrensel.kayit_dosyasi.set_value("kullanici_bilgileri","kullanici_adi",$VBoxContainer/Email.text)
		Evrensel.kayit_dosyasi.set_value("kullanici_bilgileri","sifre",$VBoxContainer/Sifre.text)
		Evrensel.kayit_dosyasi.set_value("kullanici_bilgileri","kolay_giris",true)
		Evrensel.kayit_dosyasi.save_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"])
	else:
		if Evrensel.kayit_dosyasi.has_section("kullanici_bilgileri"):
			Evrensel.kayit_dosyasi.erase_section("kullanici_bilgileri")
			Evrensel.kayit_dosyasi.save_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"])
	Evrensel.karsiya_gonder("0," + str($VBoxContainer/Email.text) + "," + str($VBoxContainer/Sifre.text))


func _on_Uyelik_pressed():
	var kayit = load(Evrensel.veriler["kayitol_sahnesi"]).instance()
	get_tree().get_current_scene().call_deferred("add_child", kayit)
	queue_free()
