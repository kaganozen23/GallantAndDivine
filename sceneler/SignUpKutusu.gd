extends TextureRect

onready var bilgi_yazisi = $VBoxContainer/DikeyBolucuLogolar/BilgiYazisi

func _ready():
	pass # Replace with function body.

func _on_GeriButonu_pressed():
	var giris = load(Evrensel.veriler["giris_sahnesi"]).instance()
	get_tree().get_root().call_deferred("add_child", giris)
	queue_free()


func _on_UyeOl_pressed():
	var regex_mail = RegEx.new()
	var regex_sifre = RegEx.new()
	regex_mail.compile("^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\\.[a-zA-Z0-9-]+)*$")
	var sonuc_mail = regex_mail.search($VBoxContainer/Email.text)
	if !sonuc_mail:	#mail doğrulamadan geçmezse
		bilgi_yazisi.text = "Please enter a valid e-mail!"
		return
	#yazdığı şifreler uyuşmuyorsa
	if $VBoxContainer/Sifre.text != $VBoxContainer/SifreTekrar.text:
		bilgi_yazisi.text = "Passwords Do Not Match!"
		$VBoxContainer/Sifre.text = ""
		$VBoxContainer/SifreTekrar.text = ""
		return
	else:
		regex_sifre.compile(".{8,}")
		var sonuc_sifre = regex_sifre.search($VBoxContainer/Sifre.text)
		if !sonuc_sifre:
			bilgi_yazisi.text = "Password shall contain at least 8 characters"
			return
	Evrensel.karsiya_gonder("993,%s,%s" % [$VBoxContainer/Email.text,$VBoxContainer/Sifre.text])
	Evrensel.yukleniyor_goster()
