extends TextureRect

var gorev_buton
onready var konteyner = $ScrollContainer/VBoxContainer

func _ready():
	gorev_buton = $ScrollContainer/VBoxContainer/CenterContainer.duplicate()
	Evrensel.veriler.yielded = gorev_bilgilerini_al()
	# ana gorevleri al
	# tanri gorevlerini al
	# yazdir


func gorev_bilgilerini_al():
	Evrensel.yukleniyor_goster()
	if not Evrensel.veriler["ana_gorevler"]:
		Evrensel.karsiya_gonder("22")	#tum gorevleri al
		yield()
	Evrensel.karsiya_gonder("23,"+Evrensel.veriler["oyuncu_tanrisi_id"])	#oyuncu gorevlerini al
	yield()
	gorev_bilgilerini_yaz()
	Evrensel.yukleniyor_kaybet()

func gorev_bilgilerini_yaz():
	if not Evrensel.veriler["tanri_gorevleri"]:
		$GorevYokMetin.visible = true
	for tanri_gorevi in Evrensel.veriler["tanri_gorevleri"]:
		var gb = gorev_buton.duplicate()
		for ana_gorev in Evrensel.veriler["ana_gorevler"]:
			if tanri_gorevi.gorev_id == ana_gorev.id.replacen(" ",""):
				gb.get_node("GorevButon/GorevIsmi").text = ana_gorev.baslik
				gb.get_node("GorevButon/GorevAsama").max_value = int(ana_gorev.gorev_tamamlama_sarti.replacen(" ",""))
				gb.get_node("GorevButon/GorevAsama").value = int(tanri_gorevi.gorev_sarti_sayisi)
				gb.get_node("GorevButon/GorevAsama/GorevAsamaYazisi").text = String(tanri_gorevi.gorev_sarti_sayisi) + " / " + String(ana_gorev.gorev_tamamlama_sarti)
				gb.get_node("GorevButon/Saat/KalanSure").text = String(tanri_gorevi.suresi)
				gb.visible= true
				gb.get_node("GorevButon").connect("pressed",self,"_on_gorev_pressed",[gb,tanri_gorevi,ana_gorev])
				konteyner.add_child(gb)

func _on_gorev_pressed(gorev_butonu,tanri_gorevi,ana_gorev):
	var GorevPopup = load(Evrensel.veriler.gorev_popup).instance()
	GorevPopup.baslat(tanri_gorevi,ana_gorev)
	add_child(GorevPopup)
	GorevPopup.popup()
	
