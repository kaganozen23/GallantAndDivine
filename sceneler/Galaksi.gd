extends TextureRect

signal dive_in(galaksi)
signal use_possession(galaksi)

func _ready():
	Evrensel.veriler.yielded = evren_galaksilerini_al()

	
func evren_galaksilerini_al():
	Evrensel.yukleniyor_goster()
	Evrensel.karsiya_gonder("6" + ',' + str(Evrensel.veriler["oyuncu_evreni_id"]))
	Evrensel.karsiya_gonder("8,%s" % Evrensel.veriler["oyuncu_tanrisi_id"])
#	print(Evrensel.veriler["oyuncu_tanrisi_id"])
	if Evrensel.veriler["oyuncu"] and Evrensel.veriler["oyuncu_evreni_id"] and Evrensel.veriler["oyuncu_tanrisi_id"]:
		Evrensel.karsiya_gonder("7")	#zamani al
#		Evrensel.karsiya_gonder("8,%s" % Evrensel.veriler["oyuncu_tanrisi_id"]) 	#oyuncu tanri bilgilerini al
#		ustteki almaislemini galaksiye yaptirdim
		Evrensel.karsiya_gonder("999,%s" % Evrensel.veriler["oyuncu_tanrisi_id"])	#oyuncu idsini kayit icin
		Evrensel.karsiya_gonder("998,%s" % Evrensel.veriler["oyuncu_tanrisi_id"])	#bildirimleri al
		yield()
		yield()
		yield()
#		yield()
	else:
		Evrensel.sahne_degistir(self,Evrensel.veriler["giris_sahnesi"])	
	yield()
	yield()
	if Evrensel.veriler["evren_galaksileri"]:
		$Nebula1/Nebula1Isim.text = Evrensel.veriler["evren_galaksileri"][0].isim
		$Nebula2/Nebula2Isim.text = Evrensel.veriler["evren_galaksileri"][1].isim
		$Nebula3/Nebula3Isim.text = Evrensel.veriler["evren_galaksileri"][2].isim
		$Nebula4/Nebula4Isim.text = Evrensel.veriler["evren_galaksileri"][3].isim
		$Nebula5/Nebula5Isim.text = Evrensel.veriler["evren_galaksileri"][4].isim
	Evrensel.yukleniyor_kaybet()


func tiklama_popup_goster(galaksi,pozisyon):
	var popup = load(Evrensel.veriler["galaksi_tiklama_popup_sahnesi"]).instance()
	popup.baslat(galaksi)
	add_child(popup)
	popup.rect_position = pozisyon
	popup.popup()

func _on_Nebula1_pressed():
	tiklama_popup_goster(Evrensel.veriler["evren_galaksileri"][0],get_global_mouse_position())

func _on_Nebula2_pressed():
	tiklama_popup_goster(Evrensel.veriler["evren_galaksileri"][1],get_global_mouse_position())


func _on_Nebula3_pressed():
	tiklama_popup_goster(Evrensel.veriler["evren_galaksileri"][2],get_global_mouse_position())


func _on_Nebula4_pressed():
	tiklama_popup_goster(Evrensel.veriler["evren_galaksileri"][3],get_global_mouse_position())


func _on_Nebula5_pressed():
	tiklama_popup_goster(Evrensel.veriler["evren_galaksileri"][4],get_global_mouse_position())
	
func IcGalaksiGoster(Galaksi):
	var IcGalaksi = load(Evrensel.veriler["ic_galaksi_sahnesi"]).instance()
	IcGalaksi.baslat(Galaksi)	#verileri yeni sahnenin baslat fonk. yolla
	get_parent().add_child(IcGalaksi)
	get_parent().move_child(IcGalaksi,1)
	queue_free()

func _on_Galaksi_dive_in(galaksi):
	IcGalaksiGoster(galaksi)


func _on_Galaksi_use_possession(galaksi):
	var esya_sahnesi = load(Evrensel.veriler["esya_sahnesi"]).instance()
	var anlik_popup = Popup.new()
	anlik_popup.rect_size = Vector2(550,750)
	anlik_popup.add_child(esya_sahnesi)
	add_child(anlik_popup)
	esya_sahnesi.baslat("Galaxy",3,galaksi)
	anlik_popup.popup_centered()
