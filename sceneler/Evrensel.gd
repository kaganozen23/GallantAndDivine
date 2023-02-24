extends Node

var Evren_Sinifi = load("res://sinif_scriptleri/evren.gd")	
var Ana_Tanri_Sinifi = load("res://sinif_scriptleri/ana_tanri.gd") #ana_tanri_tablosu
var Oyuncu_Sinifi = load("res://sinif_scriptleri/oyuncu.gd")
var Tanri_Sinifi = load("res://sinif_scriptleri/tanri.gd")
var loading = preload("res://sceneler/Yukleniyor.tscn")	#kum saati sahnesi
var Galaksi_Sinifi = load("res://sinif_scriptleri/galaksi.gd")
var Yildiz_Sinifi = load ("res://sinif_scriptleri/yildiz.gd")
var Ana_Yaratik_Sinifi = load("res://sinif_scriptleri/ana_yaratik.gd")
var Galaksi_Yaratiklari_Sinifi = load("res://sinif_scriptleri/galaksi_yaratiklari.gd")
var Ana_Gorev_Sinifi = load("res://sinif_scriptleri/ana_gorev.gd")
var Tanri_Gorevleri_Sinifi = load("res://sinif_scriptleri/tanri_gorevleri.gd")
var Ana_Esya_Sinifi = load("res://sinif_scriptleri/ana_esya.gd")
var Tanri_Esyalari_Sinifi = load ("res://sinif_scriptleri/tanri_esyalari.gd")
var Bildirim_Sinifi = load ("res://sinif_scriptleri/bildirim.gd")
var Ana_Panteon_Sinifi = load ("res://sinif_scriptleri/ana_panteon.gd")
var kayit_dosyasi = ConfigFile.new()
#var giris_muzigi = load ("res://sesler/FoxieEpic.OGG")
#var tanri_secim_muzigi = load("res://sesler/Heroic Demise (New).mp3")

var tiklama_calar = AudioStreamPlayer.new()
var efekt_calar = AudioStreamPlayer.new()
var muzik_calar = AudioStreamPlayer.new()
var efekt_sesi = true
var muzik_sesi = true

var veriler = {}
var tanri_popup_bilgileri = []

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_IN:	#oyun on plana geldi
		if "AnaKontrol" in get_tree().get_current_scene().name:
			sahne_degistir(get_tree().get_current_scene(),Evrensel.veriler["ana_oyun_sahnesi"])
#		if (get_tree().current_scene.name == "AnaKontrol"):
#			get_tree().change_scene(veriler["ana_oyun_sahnesi"])
	elif what == MainLoop.NOTIFICATION_APP_RESUMED:
		if "AnaKontrol" in get_tree().get_current_scene().name:
			sahne_degistir(get_tree().get_current_scene(),Evrensel.veriler["ana_oyun_sahnesi"])
	elif what == NOTIFICATION_WM_GO_BACK_REQUEST:	#geri tusuna basilirsa ne olacak? Android specific
		get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
		
func _ready():
	tiklama_calar.stream = load("res://sesler/tiklama.wav")
	tiklama_calar.add_to_group("efektler")
	efekt_calar.add_to_group("efektler")
	muzik_calar.add_to_group("muzikler")
	if not is_a_parent_of(tiklama_calar):
		add_child(tiklama_calar)
	if not is_a_parent_of(efekt_calar):
		add_child(efekt_calar)
	if not is_a_parent_of(muzik_calar):
		add_child(muzik_calar)
	veriler = {
	"tum_tanrilar":[],	#ana tanri sinifindan olusacak
	"tum_yaratiklar":[],	#ana yaratiklar sinifindan olusacak
	"galaksi_yaratiklari":[],	#galaksideki yaratiklari tutacak
	"tum_evrenler":[],	#evren sinifindan olusacak
	"oyuncu_tanrilari":[],	#oyuncunun aktif tanrilarini tutacak
	"oyuncu":null,			#oyuncu sinifindan olusacak
	"oyuncu_evreni_id":null,		#oyuncunun evren numarasini tutacak
	"oyuncu_tanrisi_id":null,	#oyuncunun tanri id'sini tutacak
	"oyuncu_tanrisi":[],	#oyuncu tanrisinin ismi, ozellikleri
	"rakip_tanri":null,	#titanomakhiada rakip gelen tanri bilgisini tutacak
	"rakip_tanri_tatula":false,	#titanomakhiada karsiya gelen tanrinin tatulasi var ise tutacak
	"registered":false,		#oyuncunun tanri_idsinin servera kaydoldugu
	"tanri_haklari": {"emir_hakki":0,"yaratik_savas_hakki":0,"tanrilarla_savas_hakki":0,},
	"tum_tanri_emirleri":[{"yildiz_id":'0',"emir_no":'0',}],	#tanrinin tum emirlerini tut
	"evren_galaksileri":[],
	"galaksi_yildizlari":[],
	"panteon_tanrilari":[],
	"ana_gorevler":[],
	"sielulintu":"-",	#sielulintu olan yildizdaki emir sayisini
	"tjatis":false,
	"trizul":false,
	"disk":false,
	"ana_esyalar":[],
	"ana_panteonlar":[],
	"tanri_esyalari":[],
	"tanri_gorevleri":[],
	"halkasiz_galaksi":"",
	"evren_zamani":null,
	"yielded":null,
	"silinecek_sahne":null,
	"secili_yildiz_cazibe":0,
	"secili_yildiz_emri":"None",
	"sahne_yukleyici":null,
	"websoket_url":"ws://45.9.190.218:7806",
	"client":null,
	"sertifika":null,
	"secim_cevabi":false,
	"bildirim_bayragi":false,
	"tekrar_baglanma_suresi":1,
	"oyuncu_oyunda_mi":false,
	"verilen_tum_emirler":[],		#manafin kuresinden gelen tum emirleri alacak
	"server_miti":"",
	"kayit_dosya_yolu":"user://kayit.gad",
	"kayit_dosya_sifresi":"Ka6666..",
	"giris_sahnesi":"res://sceneler/Giris.tscn",
	"server_secim_sahnesi":"res://sceneler/ServerSecim.tscn",
	"tanri_secim_sahnesi":"res://sceneler/TanriSecim.tscn",
	"popup_genel_sahnesi":"res://sceneler/PopupGenel.tscn",
	"popup_onay_sahnesi":"res://sceneler/PopupOnay.tscn",
	"ana_oyun_sahnesi":"res://sceneler/AnaKontrol.tscn",
	"baglanti_koptu_sahnesi":"res://sceneler/BaglantiKoptu.tscn",
	"popup_tekrar_dene_yada_cik":"res://sceneler/PopupTekrarDeneYadaCik.tscn",	
	"kayitol_sahnesi":"res://sceneler/SignUpKutusu.tscn",
	"galaksi_sahnesi":"res://sceneler/Galaksi.tscn",
	"gorev_sahnesi":"res://sceneler/Journey.tscn",
	"tanri_bilgileri_popup":"res://sceneler/TanriBilgileri.tscn",
	"ic_galaksi_sahnesi":"res://sceneler/IcGalaksi.tscn",
	"yildiz_bilgileri_sahnesi":"res://sceneler/YildizBilgileri.tscn",
	"yaratik_sahnesi":"res://sceneler/Yaratik.tscn",
	"esya_sahnesi":"res://sceneler/Esyalar.tscn",
	"emir_sonrasi_sahnesi":"res://sceneler/tali_sahneler/emir_sonrasi.tscn",
	"yaratik_savasi_sonrasi_popup":"res://sceneler/tali_sahneler/yaratik_savasi_sonrasi.tscn",
	"gorev_popup":"res://sceneler/tali_sahneler/GorevPopup.tscn",
	"bildirim_sahnesi":"res://sceneler/tali_sahneler/Bildirim.tscn",
	"titanomakhia_sahnesi":"res://sceneler/Titanomakhia.tscn",
	"titanomakhia_sonrasi_sahnesi":"res://sceneler/tali_sahneler/Titanomahia_sonrasi.tscn",
	"esya_popup_sahnesi":"res://sceneler/tali_sahneler/EsyaPopup.tscn",
	"esya_kontrol_scripti":"res://esya_kontrol.gd",
	"galaksi_tiklama_popup_sahnesi":"res://sceneler/tali_sahneler/galaksi_tiklayinca.tscn",
	"chat_sahnesi":"res://sceneler/Causerie.tscn",
	"panteon_sahnesi":"res://sceneler/Panteon.tscn",
	"dogrulama_sahnesi":"res://sceneler/tali_sahneler/Dogulama.tscn",
	"oyuncu_ismi_sahnesi":"res://sceneler/tali_sahneler/Oyuncu_Ismi_Alma.tscn",
	"server_miti_sahnesi":"res://sceneler/tali_sahneler/Mit.tscn",
	}
	if kayit_dosyasi.load_encrypted_pass(veriler["kayit_dosya_yolu"],veriler["kayit_dosya_sifresi"]) == OK:
		if not kayit_dosyasi.has_section("ses_ayarlari"):
			kayit_dosyasi.set_value("ses_ayarlari","muzik",true)
			kayit_dosyasi.set_value("ses_ayarlari","efekt",true)
		else:
			if kayit_dosyasi.get_value("ses_ayarlari","efekt") == false:
				efekt_sesi = false
			if kayit_dosyasi.get_value("ses_ayarlari","muzik") == false:
				muzik_sesi = false
		kayit_dosyasi.save_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"])		
#	kayit_dosyasi.load_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"])

	websoket_baglan()

func websoket_baglan():
	yukleniyor_goster()
	yield(get_tree().create_timer(.1), "timeout")
	if veriler["client"] == null:
		veriler["client"] = WebSocketClient.new()	
		veriler["client"].connect("connection_established", self, "_connected")
		veriler["client"].connect("connection_closed", self, "_closed")
		veriler["client"].connect("connection_error", self, "_closed")
		veriler["client"].connect("data_received", self, "_on_data")
	"""
	veriler["tekrar_baglanma_suresi"] += 1
	if veriler["tekrar_baglanma_suresi"] >= 30:
		veriler["tekrar_baglanma_suresi"] = 0
		baglanti_koptu_kaybet()
		yield(tekrar_dene_yada_cik_popup_goster(),"completed")
		if veriler["secim_cevabi"]:
			veriler["secim_cevabi"] = false
		else:
			get_tree().quit()
	"""
	veriler["client"].connect_to_url(veriler["websoket_url"])
	set_process(true)
#	yukleniyor_kaybet()

func _connected(proto = ""):
	yukleniyor_kaybet()
	baglanti_koptu_kaybet()
	if veriler["oyuncu_tanrisi_id"]:
		karsiya_gonder("999,%s" % veriler["oyuncu_tanrisi_id"])
	if "AnaKontrol" in get_tree().get_current_scene().name:
		sahne_degistir(get_tree().get_current_scene(),Evrensel.veriler["ana_oyun_sahnesi"])
		
func _closed(was_clean = false):
#	print("koptu")
	set_process(false)
	baglanti_koptu_goster()
	websoket_baglan()
	
func karsiya_gonder(data):
	if veriler["client"].get_peer(1).is_connected_to_host():
		veriler["client"].get_peer(1).put_packet( data.to_utf8() )
	else:
		_closed()
		veriler["client"].get_peer(1).put_packet( data.to_utf8() )
	
func _on_data():
	var data = veriler["client"].get_peer(1).get_packet().get_string_from_utf8()
	
	if data.begins_with("0,"):	#giriş kontrol
		data = data_duzelt(data)
		yukleniyor_kaybet()
		var oyuncu_parcali = data.split(",")
		if oyuncu_parcali.size() != 6:
			yukleniyor_kaybet()
			yanlis_giris_popup_goster()
			return

		if oyuncu_parcali[4] == "1":	#hesap aktif
			veriler["oyuncu"] = Oyuncu_Sinifi.new(oyuncu_parcali)
			sahne_degistir(get_tree().get_current_scene(),veriler["server_secim_sahnesi"])
		elif oyuncu_parcali[4] == "2":	#hesap beklemede
			var dogrulama_sahnesi = load(veriler.dogrulama_sahnesi).instance()
			get_tree().get_current_scene().add_child(dogrulama_sahnesi)

	elif data.begins_with("1,"):
		data = data_duzelt(data)
#		print(data)
	elif data.begins_with("2,"):	#tanrilarin listesi geldiyse
		data = data_duzelt(data)
		var tanrilar_parcali = data.split("],")
		veriler["tum_tanrilar"] = []
		for tanri in tanrilar_parcali:
			veriler["tum_tanrilar"].append(Ana_Tanri_Sinifi.new(tanri.split(",")))
	elif data.begins_with("3,"):	#tüm evrenlerin listesi geldiyse
		data = data_duzelt(data)
		var evrenler_parcali = data.split("],")
		veriler["tum_evrenler"] = []
		for evren in evrenler_parcali:
			veriler["tum_evrenler"].append(Evren_Sinifi.new(evren.split(",")))
	elif data.begins_with("4,"):	#oyuncunun tanrilari geldiyse
		data=data_duzelt(data)
		veriler["oyuncu_tanrilari"] = []
		if data.length() > 1:	#oyuncunun tanrilari varsa
			var tanrilar_parcali = data.split("],")
			for tanri in tanrilar_parcali:
				veriler["oyuncu_tanrilari"].append(Tanri_Sinifi.new(tanri.split(",")))		
	elif data.begins_with("5,"):	#oyuncunya tanri olusturulduysa
		data = String(data_duzelt(data))
		if (data):
			veriler["oyuncu_tanrisi_id"] = data		#tanrisinin idsini set et
			karsiya_gonder("13,%s" % veriler["oyuncu_tanrisi_id"] )	#haklarini yaz
			sahne_degistir(get_tree().get_current_scene(), veriler["ana_oyun_sahnesi"])

							
	elif data.begins_with("6,"):	#galaksileri al
		data = data_duzelt(data)
		var galaksiler_parcali = data.split("],")
		veriler["evren_galaksileri"] = []
		for galaksi in galaksiler_parcali:
			veriler["evren_galaksileri"].append(Galaksi_Sinifi.new(galaksi.split(",")))
	elif data.begins_with("7,"):	#zamani al
		data = data_duzelt(data)
		veriler["evren_zamani"] = int(data)
#		print(veriler["evren_zamani"])
	elif data.begins_with("8,"):	#oyuncu tanrisinin bilgilerini al
		data = data_duzelt(data)
		var oyuncu_tanrisi = data.split(",")
		veriler["oyuncu_tanrisi"] = Tanri_Sinifi.new(oyuncu_tanrisi)
	elif data.begins_with("9,"):		#galaksi yildiz bilgilerini al
		data = data_duzelt(data)
		var yildizlar_parcali = data.split("],")	
		veriler["galaksi_yildizlari"] = []
		for yildiz in yildizlar_parcali:
			veriler["galaksi_yildizlari"].append(Yildiz_Sinifi.new(yildiz.split(",")))	
	elif data.begins_with("10,"):		#ana yaratiklari al
		data = data_duzelt(data)
		var yaratiklar_parcali = data.split("],")	
		veriler["tum_yaratiklar"] = []
		for yaratik in yaratiklar_parcali:
			veriler["tum_yaratiklar"].append(Ana_Yaratik_Sinifi.new(yaratik.split(",")))	
	elif data.begins_with("11,"):		#galaksi yaratik kumelerini al
		data = data_duzelt(data)
		if (data != "]"):
			var yaratik_kumeleri_parcali = data.split("],")	
			veriler["galaksi_yaratiklari"] = []
			for yaratik_kumesi in yaratik_kumeleri_parcali:
				veriler["galaksi_yaratiklari"].append(Galaksi_Yaratiklari_Sinifi.new(yaratik_kumesi.split(",")))
	elif data.begins_with("12,"):		#tanri haklarini al
		data = data_duzelt(data)
		var tanri_haklari_parcali = data.split(",")	
		veriler["tanri_haklari"].emir_hakki = tanri_haklari_parcali[1]
		veriler["tanri_haklari"].yaratik_savas_hakki = tanri_haklari_parcali[2]
		veriler["tanri_haklari"].tanrilarla_savas_hakki = tanri_haklari_parcali[3]
	elif data.begins_with("14,"):		#secili yildiz cazibesini al
		data = data_duzelt(data)
		data = data.replacen("]","")
		if (data):
			veriler["secili_yildiz_cazibe"] = data
		else:
			veriler["secili_yildiz_cazibe"] = 0
	elif data.begins_with("15,"):		#secili yildiz emrini al
		data = data_duzelt(data)
		data = data.replacen("]","")
		if (data):
			veriler["secili_yildiz_emri"] = data.replacen(",","\n")
		else:
			veriler["secili_yildiz_emri"] = "None"
	elif data.begins_with("18,"):		#tanrinin tum emirlerini al
		veriler["tum_tanri_emirleri"].clear()
		data = data_duzelt(data)
		if data == "]":
			pass
		elif "]," in data:
			var tum_emirler_parcali = data.split("],")	
			for emir in tum_emirler_parcali:
				emir = emir.split(",")
				veriler["tum_tanri_emirleri"].append([emir[0],emir[1]])
		else:
			data = data.split(",")
			veriler["tum_tanri_emirleri"].append([data[0],data[1]]	)
			
	elif data.begins_with("22,"):	#tum gorevleri al
		data = data_duzelt_bosluklu(data)
		var ana_gorevler_parcali = data.split("],")	
		veriler["ana_gorevler"] = []
		for ana_gorev in ana_gorevler_parcali:
			veriler["ana_gorevler"].append(Ana_Gorev_Sinifi.new(ana_gorev.split(",")))	

	elif data.begins_with("23,"):	#tanri gorevlerini al
		data = data_duzelt(data)
		veriler["tanri_gorevleri"] = []
		if data == "]":
			pass
		elif "]," in data:
			var tanri_gorevleri_parcali = data.split("],")	
			for gorev in tanri_gorevleri_parcali:
				veriler["tanri_gorevleri"].append(Tanri_Gorevleri_Sinifi.new(gorev.split(",")))
		else:
			data = data.split(",")
			veriler["tanri_gorevleri"].append(Tanri_Gorevleri_Sinifi.new(data))

	elif data.begins_with("24,"):	#ana esyalari al
		data = data_duzelt_bosluklu(data)
		veriler["ana_esyalar"] = []
#		print(data)
		var ana_esyalar_parcali = data.split("],")	
		for esya in ana_esyalar_parcali:
			veriler["ana_esyalar"].append(Ana_Esya_Sinifi.new(esya.split(",")))

	elif data.begins_with("25,"):	#tanri esyalarini al
		data = data_duzelt(data)
		veriler["tanri_esyalari"].clear()
		if data == "]":	#esya yok
			pass
		elif "]," in data:	#birden cok esya
			var tanri_esyalari_parcali = data.split("],")	
			for esya in tanri_esyalari_parcali:
				veriler["tanri_esyalari"].append(Tanri_Esyalari_Sinifi.new(esya.split(",")))
		else:	#tek esya
			data = data.split(",")
			veriler["tanri_esyalari"].append(Tanri_Esyalari_Sinifi.new(data))

	elif data.begins_with("27,"):	#rastgele rakip tanri secme
		data = data_duzelt(data)
		data = data.replacen("]","")
		veriler["rakip_tanri"] = null
		if data == "None":	#tanri yok
			pass
		else:	#tanri var
			data = data.split(",")
			veriler["rakip_tanri"] = Tanri_Sinifi.new(data)
			
	elif data.begins_with("28,"):	#rakip tanri bilgilerini tekrar alma
		data = data_duzelt(data)
		data = data.replacen("]","")
		if data == "None":	#tanri yok
			pass
		else:	#tanri var
			data = data.split(",")
			veriler["rakip_tanri"] = Tanri_Sinifi.new(data)

	elif data.begins_with("31,"):	#manafin kuresi kullanimi	
		data = data_duzelt(data)
		yukleniyor_kaybet()
		if data == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Already in Use"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Your Manafs Sphere is already attached to specified star!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()		
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Manafs Sphere"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You attached your Manafs Sphere to %s. You can see all decrees over it now!" % data
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()		
			Evrensel.Bildirim_Sinifi.new([ Evrensel.veriler["oyuncu_tanrisi_id"], "11", ("You have used Manafs Sphere on %s. You can see all decrees over it now!" % data) ])
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")
			
#			print(get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(0).get_name())
#			get_node("Arkaplan/Yildizlar").call_deferred("emit_signal","pressed") #emit_signal("pressed")
#			yield(PopupGenel,"popup_hide")
#			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")			


			
	elif data.begins_with("32,"): 	#manafin kuresi verilen emirler listesi
		yukleniyor_kaybet()
		data = data_duzelt(data)
		self.veriler["verilen_tum_emirler"] = []
		data = data.split("],")
#		print(String(data))
		if String(data) == "[]]":
			pass
		else:
			for eleman in data:
				self.veriler["verilen_tum_emirler"].append(eleman)


	elif data.begins_with("33,"):	#mistletoe kullanimi
		yukleniyor_kaybet()
		data = data_duzelt(data)

		if data != "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Mistletoe"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "%s got rid of aliens thanks to you." % data
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()
#			yield(PopupGenel,"popup_hide")
#			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")
					
	elif data.begins_with("34,"):	#cerridwens cauldron kullanimi
		yukleniyor_kaybet()
		data = data_duzelt_bosluklu(data)
		var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
		PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Talent Growth"
		PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You have gained 1 more percent of your '%s' by using Cerridwens Cauldron" % data
		get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
		PopupGenel.popup_centered()
		yield(PopupGenel,"popup_hide")
		get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")
#		._ready()	
		#ust satir bulunulan sahnenin yenilenmesini sagliyor,,,

	elif data.begins_with("35,"):	#amulet of tatula kullanimi		
		data = data_duzelt(data)
		yukleniyor_kaybet()
		if data == "true":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Congratulations"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Your Amulet of Tatula is now protecting you from being defeated in Titanomahia!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()		
			Evrensel.Bildirim_Sinifi.new([ Evrensel.veriler["oyuncu_tanrisi_id"], "14", "You have used Amulet of Tatula. You wont be defeated in Titanomahia in this timeslice!" ])		
			yield(PopupGenel,"popup_hide")
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")			
		elif data == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Already in Use"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Your Amulet of Tatula is already protecting you!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()		

	elif data.begins_with("36,"):	#rakibin amulet of tatulasi var mi?
		data = data_duzelt(data)
		if data == "true":
			veriler["rakip_tanri_tatula"] = true
#			print("tatula set true")
		else:
			veriler["rakip_tanri_tatula"] = false
			
	elif data.begins_with("37,"):	#turtle egg kullanimi,, esya_kontrolde tanimlaniyor
		data = data_duzelt(data)
		data = data.replace(",","")
		yukleniyor_kaybet()
		if data != "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Turtle Egg"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You have increased your charm on %s by 1" % data
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")

			
	elif data.begins_with("38,"):	#esoteric asa 
		data = data_duzelt(data)
		yukleniyor_kaybet()
		if data == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Esoteric Staff"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You Have No Decree in Specified Galaxy"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()		
#			yield(PopupGenel,"popup_hide")					
#			sahne_degistir(get_tree().get_current_scene(), veriler["ana_oyun_sahnesi"])
		else:
			data = data.split(",")
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Esoteric Staff"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "All Stars in Galaxy %s is now being affected with %s" % [data[0],data[1]]
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()						
			yield(PopupGenel,"popup_hide")					
			sahne_degistir(get_tree().get_current_scene(), veriler["ana_oyun_sahnesi"])

	elif data.begins_with("39,"):	#rustemin aslan kani
		data = data_duzelt(data)
#		print(data)
#		yukleniyor_kaybet()
		if data == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Rustems Lion Blood"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "There are no opposite decrees on specified star at the moment."
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Rustems Lion Blood"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You have purged one opposite decree from the specified star."
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
			yield(PopupGenel,"popup_hide")	
			print(get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1)._ready())
			

	elif data.begins_with("40,"):	#labyrs of amazon
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()

		var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
		PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Labyrs of Amazon"
		PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Congratulations. You are granted with divine journey '%s' ." % data[0]
		get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
		PopupGenel.popup_centered()	
		yield(PopupGenel,"popup_hide")					
		get_tree().get_current_scene().get_node("Ana/DikeyBolucu/Alt/YatayBolucu/DikeyBolucuUSt/Journey").call_deferred("emit_signal","pressed") #emit_signal("pressed")

	elif data.begins_with("41,"):	#Amazons Moon Shield
		data = data_duzelt(data)
		yukleniyor_kaybet()
		var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
		PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Amazons Moon Shield"
		PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Congratulations. You have resurrected dead creatures from the grave!"
		get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
		PopupGenel.popup_centered()	
#		yield(PopupGenel,"popup_hide")					
#		sahne_degistir(get_tree().get_current_scene(), veriler["ana_oyun_sahnesi"])
		get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")
		
	elif data.begins_with("42,"):	#Raven Feather
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Raven Feather"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You have no divine journey to use Raven Feather!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Raven Feather"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Congratulations. You have compelled divine journey %s to be completed." % data[0]
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
			yield(PopupGenel,"popup_hide")					
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu/Alt/YatayBolucu/DikeyBolucuUSt/Journey").call_deferred("emit_signal","pressed") #emit_signal("pressed")
			
	elif data.begins_with("43,"):	#Skull Charmed Amulet
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Skull Charmed Amulet"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Not Enough amulets to turn into an Esoteric Staff!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
#			yield(PopupGenel,"popup_hide")					
#			sahne_degistir(get_tree().get_current_scene(), veriler["ana_oyun_sahnesi"])
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Skull Charmed Amulet"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You have turned your Skull Charmed Amulets into an Esoteric Staff!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
			yield(PopupGenel,"popup_hide")					
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")	
			
	elif data.begins_with("44,"):	#Yamantakas Whip
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Yamantakas Whip"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "An Error occured while using Yamantakas Whip!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Yamantakas Whip"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You have gained a unique divine journey '%s'" % data[0]
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
			yield(PopupGenel,"popup_hide")					
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu/Alt/YatayBolucu/DikeyBolucuUSt/Journey").call_deferred("emit_signal","pressed") #emit_signal("pressed")			

	elif data.begins_with("45,"):	#Schrimnirs Beef
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Schrimnirs Beef"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You are already affected with Schrimnirs Beef!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Schrimnirs Beef"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You will have your decree effects doubled but you wont gain any charm for this timeslice"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
			yield(PopupGenel,"popup_hide")					
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")

	elif data.begins_with("46,"):	#Schrimnirs Milk
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Schrimnirs Milk"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You are already affected with Schrimnirs Milk!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Schrimnirs Milk"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You will have your decree effects halved but you wwill gain double charm for this timeslice"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
			yield(PopupGenel,"popup_hide")					
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")
			
	elif data.begins_with("47,"):	#Arrow of Hou Yi
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Arrow of Hou Yi"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "An error occured while using Arrow of Hou Yi"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Arrow of Hou Yi"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Congratulations. You are granted with another decree chance for this timeslice."
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
			yield(PopupGenel,"popup_hide")					
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")

	elif data.begins_with("48,"):	#Ankh of Anuketh
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Ankh of Anuketh"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You have no decrees to use Ankh of Anuketh"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Ankh of Anuketh"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Congratulations. Your decrees on %s are applied instantly." % data[0]
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
			yield(PopupGenel,"popup_hide")					
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")
#			sahne_degistir(get_tree().get_current_scene(), veriler["ana_oyun_sahnesi"])

	elif data.begins_with("49,"):	#Tyrfing
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Tyrfing"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "There are no decrees to reverse at the moment for specified star."
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()
#			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Tyrfing"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Congratulations. %s decrees on Star%s are reversed." % [data[0],data[1]]
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
			yield(PopupGenel,"popup_hide")					
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")

	elif data.begins_with("50,"):	#Golden Hide
		data = data_duzelt(data)
		data = data.split(",")
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Golden Hide"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Unable to summon a pack of creatures from their graves."
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Golden Hide"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You have summoned a pack of creature from their graves into %s" % data[0]
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
			yield(PopupGenel,"popup_hide")					
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")

	elif data.begins_with("51,"):	#Lapis Lazuli
		data = data_duzelt(data)
		data = data.split(",")
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Lapis Lazuli"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "An error occured while using lapis lazuli"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Lapis Lazuli"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Galaxy %s, %s seems to be the most populated star at this time." % [data[0],data[1]]
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
			yield(PopupGenel,"popup_hide")					
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")

	elif data.begins_with("52,"):	#Orfeus Lyre
		data = data_duzelt(data)
		data = data.split(",")
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Orfeus Lyre"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "An error occured while using Orfeus Lyre"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Orfeus Lyre"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Galaxy %s, %s seems to be the most prosperous star at this time." % [data[0],data[1]]
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
			yield(PopupGenel,"popup_hide")					
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")

	elif data.begins_with("53,"):	#Ana Panteonlari al
		data = data_duzelt_bosluklu(data)
#		data = data.split(",")
#		print(data)	
		var panteonlar_parcali = data.split("],")
		veriler["ana_panteonlar"] = []
		for panteon in panteonlar_parcali:
			veriler["ana_panteonlar"].append(Ana_Panteon_Sinifi.new(panteon.split(", ")))

	elif data.begins_with("54,"):	#Panteon Kayit
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[0] == "true":
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu/Alt/YatayBolucu/DikeyBolucuUSt/Panteon").call_deferred("emit_signal", "pressed")

	elif data.begins_with("55,"):	#Panteon Online oyunculari al
		data = data_duzelt(data)
		data = data.split("],")
		veriler['panteon_tanrilari'] = []
		for d in data:
			veriler['panteon_tanrilari'].append(d)

	elif data.begins_with("56,"):	#tanri bilgileri popup gerekli bilgiler
		if data != "56,false":
			tanri_popup_bilgileri = []
			data = data.replace("]","")
			data = data_duzelt(data)
			tanri_popup_bilgileri = data.split(",")

	#57 zaman atlama basari bilgisinin kaydi icin rezerve

	elif data.begins_with("58,"):	#tanri bilgileri popup gerekli bilgiler
		if data != "58,false":
			veriler.server_miti = []
#			print(data)
			data = data.replace("]","")
			data = data_duzelt_bosluklu(data)
			veriler.server_miti = data.split(",")	

	elif data.begins_with("59,"):	#banshees silver comb kullanimi		
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Already in Use"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Banshees Silver Comb is already in use here!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Congratulations"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You have used Banshees Silver Comb on %s. Loops no more!" % data[0]
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()		
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")

	elif data.begins_with("60,"):	#chakana kullanimi		
		data = data_duzelt(data)
		yukleniyor_kaybet()
		if data == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Chakana"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Not Enough Chakanas to turn into Banshees Silver Comb!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
#			yield(PopupGenel,"popup_hide")					
#			sahne_degistir(get_tree().get_current_scene(), veriler["ana_oyun_sahnesi"])
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Chakana"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You have turned your Chakanas into a Banshees Silver Comb!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
			yield(PopupGenel,"popup_hide")					
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")			

	elif data.begins_with("61,"):	#ayahuaska kullanimi		
		data = data_duzelt(data)
		yukleniyor_kaybet()
		if data == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Ayahuaska"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Ayahuaska is already affecting you!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Ayahuaska"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You have your powers boosted for this time slice!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
			yield(PopupGenel,"popup_hide")					
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")			

	elif data.begins_with("62,"):	#Jingweis Stone kullanimi		
		data = data_duzelt(data)
		yukleniyor_kaybet()
		if data == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Jingweis Stone"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Unable to use Jingweis Stone!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Jingweis Stone"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You are granted another creature fight chance!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
			yield(PopupGenel,"popup_hide")					
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")	
#			sahne_degistir(get_tree().get_current_scene(), veriler["ana_oyun_sahnesi"])	

	elif data.begins_with("63,"):	#Xiling Silk kullanimi		
		data = data_duzelt(data)
		yukleniyor_kaybet()
		if data == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Xiling Silk"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Unable to use Xiling Silk!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Xiling Silk"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Your order among your overall rivals is: %s" % data
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
			yield(PopupGenel,"popup_hide")					
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")

	elif data.begins_with("64,"):	#Psykhes Oil Lamp kullanimi		
		data = data_duzelt(data)
		yukleniyor_kaybet()
		if data == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "P. Oil Lamp"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Unable to use Psykhes Oil Lamp!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "P. Oil Lamp"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You have used Psykhes Oil Lamp, you can see all decrees on all stars now. But you lost 2 percent of your powers as a result!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
			yield(PopupGenel,"popup_hide")					
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")
			
	elif data.begins_with("65,"):	#Huracans Mirror kullanimi		
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Huracans Mirror"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "An error occured while using Huracans Mirror"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
#			yield(PopupGenel,"popup_hide")					
#			sahne_degistir(get_tree().get_current_scene(), veriler["ana_oyun_sahnesi"])
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Huracans Mirror"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Galaxy %s, %s seems to be the most advanced star in science at this time." % [data[0],data[1]]
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
			yield(PopupGenel,"popup_hide")					
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")

	elif data.begins_with("66,"):	#Sielulintu kullanimi		
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Sielulintu"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Sielulintu is already attached to specified star!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
#			yield(PopupGenel,"popup_hide")					
#			sahne_degistir(get_tree().get_current_scene(), veriler["ana_oyun_sahnesi"])
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Sielulintu"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Sielulintu is now attached to %s" % data[0]
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
			yield(PopupGenel,"popup_hide")					
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")		

	elif data.begins_with("67,"):	#Arca kullanimi		
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Arca"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You need a stack of 10 Arca to turn into a random possession."
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
#			yield(PopupGenel,"popup_hide")					
#			sahne_degistir(get_tree().get_current_scene(), veriler["ana_oyun_sahnesi"])
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Arca"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You have used Arca. You gained 1 x %s" % data[0]
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
			yield(PopupGenel,"popup_hide")					
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")		

	elif data.begins_with("68,"):	#Tjatis Boomerang kullanimi		
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Tjatis Boomerang"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You are already affected with Tjatis Boomerang!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
#			yield(PopupGenel,"popup_hide")					
#			sahne_degistir(get_tree().get_current_scene(), veriler["ana_oyun_sahnesi"])
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Tjatis Boomerang"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You have used Tjatis Boomerang. You have your titanomakhia win chance boosted by 5 percent for this timeslice!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
			yield(PopupGenel,"popup_hide")	
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu/Alt/YatayBolucu/DikeyBolucuUSt/Titanomahia").emit_signal("pressed")				

	elif data.begins_with("69,"):	#Xirang Soil kullanimi		
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Xirang Soil"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Unable to use Xirang Soil!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
#			yield(PopupGenel,"popup_hide")					
#			sahne_degistir(get_tree().get_current_scene(), veriler["ana_oyun_sahnesi"])
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Xirang Soil"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You have used Xirang Soil. You %s doomsday time by %s seconds" % [("shortened" if data[0] == "true" else "extended"),data[1]]
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
			yield(PopupGenel,"popup_hide")	
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")

	elif data.begins_with("70,"):	#Inras Electric Spear kullanimi		
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Inras Electric Spear"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Unable to use Inras Electric Spear!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Inras Electric Spear"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You have used Inras Electric Spear on %s. Its faith was changed by %s." % [data[0],data[1]]
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
#			yield(PopupGenel,"popup_hide")	
#			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")

	elif data.begins_with("71,"):	#hanumans tail kullanimi
		data = data_duzelt(data)
		yukleniyor_kaybet()
		if data == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Hanumans Tail"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Hanumans Tail is already affecting you!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Hanumans Tail"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You have your powers boosted by 2 percent for this time slice!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
			yield(PopupGenel,"popup_hide")					
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")

	elif data.begins_with("72,"):	#Saures Carafe kullanimi		
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Saures Carafe"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Unable to use Saures Carafe!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Saures Carafe"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You have used Saures Carafe on %s. Its resources was changed by %s." % [data[0],data[1]]
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()			

	elif data.begins_with("73,"):	#Trizul kullanimi		
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Trizul"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You are already affected with Trizul!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Trizul"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You have used Trizul. You will leech 25 percent more from creatures!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()			
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")

	elif data.begins_with("74,"):	#Horus Holy Hearth kullanimi		
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "H.Holy Hearth"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Unable to use Horus Holy Hearth!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "H.Holy Hearth"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Galaxy %s, %s seems to be surviving doomsday at this time." % [data[0],data[1]]
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()			
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")

	elif data.begins_with("75,"):	#Izanagis Spear kullanimi		
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Izanagis Spear"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Unable to use Izanagis Spear!"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Izanagis Spear"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You have used Izanagis Spear on %s. Its population was changed by %s." % [data[0],data[1]]
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	

	elif data.begins_with("76,"):	#Diorite kullanimi		
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Diorite"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Unable to use Diorite"
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Diorite"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Galaxy %s, %s seems to be the most resourceful at this time." % [data[0],data[1]]
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()			
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")

	elif data.begins_with("77,"):	#Holy Book kullanimi		
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Holy Book"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Not Enough Holy Books to boost charm."
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Holy Book"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You have used Holy Book. Your charm upon all stars increased by 1."
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()			
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")

	elif data.begins_with("78,"):	#Zephyrus Disc kullanimi		
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[0] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Zephyrus Disc"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You are already affected with Zephyrus Disc."
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Zephyrus Disc"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "You have used Zephyrus Disc. You wont get defeated while attacking in Titanomahia."
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).add_child(PopupGenel)
			PopupGenel.popup_centered()			
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu").get_child(1).call_deferred("_ready")

	elif data.begins_with("93,"):	#Zephyrus Disc sorgu cevabi
#		veriler.sielulintu = 0
		data = data_duzelt(data)
#		print(data)
		if data == "false":
			veriler.disk = false
		else:
			veriler.disk = true

	elif data.begins_with("94,"):	#Trizul sorgu cevabi
#		veriler.sielulintu = 0
		data = data_duzelt(data)
		if data == "false":
			veriler.trizul = false
		else:
			veriler.trizul = true
			
		
	elif data.begins_with("95,"):	#Tjatis Boomerang sorgu cevabi
#		veriler.sielulintu = 0
		data = data_duzelt(data)
#		print(data)
		if data == "false":
			veriler.tjatis = false
		else:
			veriler.tjatis = int(data)

	elif data.begins_with("96,"):	#Sieululintu sorgu cevabi
#		veriler.sielulintu = 0
		data = data_duzelt(data)
#		print(data)
		if data == "false":
			veriler.sielulintu = "-"
		else:
			veriler.sielulintu = int(data)
	
			
	elif data.begins_with("97,"):	#banshees silver comb sorgu cevabi
		data = data_duzelt(data)
#		print(data)
		veriler.halkasiz_galaksi = data.replace("]","")

	elif data.begins_with("98,"):	#zaman brodkasti
		data = data_duzelt(data)
#		print(data)
		Evrensel.yukleniyor_kaybet()
		veriler["evren_zamani"] = int(data)
		if "AnaKontrol" in get_tree().get_current_scene().get_name():
			get_tree().call_group("popuplar", "queue_free")
			get_tree().get_current_scene().get_node("Ana/DikeyBolucu/Alt/YatayBolucu/DikeyBolucuUSt/Galaksi").emit_signal("pressed")
			zaman_atlama_popup_goster(data)
			if efekt_calar.playing:
				yield(efekt_calar,"finished")
				efekt_ver("res://sesler/zaman_atlama.ogg")
			else:
				efekt_ver("res://sesler/zaman_atlama.ogg")

	elif data.begins_with("991,"):	#kiyamet sonrasi
		data = data_duzelt(data)
		data = data.split(",")
		if data[1] == veriler["oyuncu_evreni_id"]:
			get_tree().call_group("popuplar", "queue_free")
			var sahne = load(veriler["server_secim_sahnesi"]).instance()
			get_tree().get_current_scene().queue_free()
			get_tree().get_root().add_child(sahne)
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Doomsday"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Doomsday has come to your universe! Check out for its myth. Feel free to play on a new universe..."
			get_tree().get_current_scene().add_child(PopupGenel)
			PopupGenel.popup_centered()			

					
	elif data.begins_with("992,"):	#oyuncu ismi olusturma
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[1] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Existing Name"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Name you entered is existing. Please try another!"
			get_tree().get_current_scene().add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			get_tree().get_current_scene().emit_signal("oyuncu_ismi")
			
	elif data.begins_with("993,"):	#signup
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
		if data[1] == "false":
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Unable to Register"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Mail address specified registered into GaD before. Please check your e-mail address!"
			get_tree().get_current_scene().add_child(PopupGenel)
			PopupGenel.popup_centered()	
		else:
			var giris_sahnesi = load(veriler["giris_sahnesi"]).instance()
			get_tree().get_current_scene().queue_free()
			get_tree().get_root().add_child(giris_sahnesi)
			var popup = load("res://sceneler/PopupGenel.tscn").instance()
			get_tree().get_current_scene().add_child(popup)
			popup.popup()
		
			
	elif data.begins_with("994,"):	#dogrulama kodu geri donusu
		data = data_duzelt(data)
		data = data.split(",")
		yukleniyor_kaybet()
#		Evrensel._ready()	#tum evrensel.verileri sifirla
		if (data[1] == "true"):	#tanri online oldugu halde tekrar girmeye calisiyor
			var email = get_tree().get_current_scene().get_node("LoginKutusu").get_node("VBoxContainer/Email").text
			var sifre = get_tree().get_current_scene().get_node("LoginKutusu").get_node("VBoxContainer/Sifre").text
			karsiya_gonder("0," + str(email) + "," + str(sifre))
			yukleniyor_goster()
		else:
			var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
			PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Auth Failed"
			PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Please Check your auth code and try again!"
			get_tree().get_current_scene().add_child(PopupGenel)
			PopupGenel.popup_centered()				
			
	elif data.begins_with("995,"):	#online kontrol
		data = data_duzelt(data)
		data = data.split(",")
#		Evrensel._ready()	#tum evrensel.verileri sifirla
		if (data[1] == "true"):	#online ise giris sahnesine at
			if "AnaKontrol" in get_tree().get_current_scene().get_name():
				Evrensel.sahne_degistir(get_tree().get_current_scene(),Evrensel.veriler["giris_sahnesi"])
		
			
	elif data.begins_with("996,"):	#panteon mesaji alindiysa
		data = data_duzelt_bosluklu(data)
		data.erase(0,1)
#		print(data)

#		data = data.split(",")		
		if self.kayit_dosyasi.load_encrypted_pass(self.veriler["kayit_dosya_yolu"],self.veriler["kayit_dosya_sifresi"]) == OK:
				self.kayit_dosyasi.set_value("panteon_chat%s" % Evrensel.veriler['oyuncu_tanrisi_id'],String(OS.get_system_time_msecs()),data)
				self.kayit_dosyasi.save_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"])
				
		
	elif data.begins_with("997,"):	#evrensel mesaj alindiysaa
		data = data_duzelt_bosluklu(data)
		data.erase(0,1)
		data = data.split(",")
		if self.kayit_dosyasi.load_encrypted_pass(self.veriler["kayit_dosya_yolu"],self.veriler["kayit_dosya_sifresi"]) == OK:
			if (veriler["oyuncu_tanrisi"].evren_id == data[0]):
				self.kayit_dosyasi.set_value("evrensel_chat%s" % veriler['oyuncu_tanrisi_id'],String(OS.get_system_time_msecs()),data[1])
				self.kayit_dosyasi.save_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"])
			
					
	elif data.begins_with("998,"):	#oyuncuya bildirim gelmesi
		data = data_duzelt_bosluklu(data)
		data.erase(0,1)
		if data == "]":	#bildirim yok
			pass
		elif "]," in data:	#birden cok bildirim
			var bildirim_parcali = data.split("],")	
			for bildirim in bildirim_parcali:
				Bildirim_Sinifi.new(bildirim.split(","))
		else:	#tek bildirim
			data = data.split(",")
			if veriler.oyuncu_tanrisi_id:
				Bildirim_Sinifi.new(data)

	elif data.begins_with("999,"):	#oyuncu kayit oldu
		data = data_duzelt(data)
		data.erase(0,1)
		veriler["registered"] = data
#	yukleniyor_kaybet()
	
	if (veriler["yielded"]):
		veriler["yielded"] = veriler["yielded"].resume() if veriler["yielded"].is_valid(true) else null
		"""
		if (veriler["yielded"].is_valid()):
			veriler.yielded.resume()			
		else:
			print("not resumed")
		"""

func zaman_atlama_popup_goster(data):
	var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
#	PopupGenel.rect_size = Vector2(576,250) buraya boyutlandirma gelecek
	PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Time Shift"
	PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Chronos Have Granted a New Opportunity-full Time Shift! It has been switched to time slice '%s'" % data
	get_tree().get_current_scene().add_child(PopupGenel)
	PopupGenel.popup_centered()
#	yield(PopupGenel,"tree_exited")
#	print("popup shown")
	karsiya_gonder("57,%s" % veriler["oyuncu_tanrisi_id"])

func tanri_toplam_gucu_hesapla():
	var tanri_gucu = int(Evrensel.veriler["oyuncu_tanrisi"].savas_yetenegi) +\
					int(Evrensel.veriler["oyuncu_tanrisi"].felaket_yetenegi) +\
					int(Evrensel.veriler["oyuncu_tanrisi"].ekonomi_yetenegi) +\
					int(Evrensel.veriler["oyuncu_tanrisi"].kaos_yetenegi) + \
					int(Evrensel.veriler["oyuncu_tanrisi"].ilahi_yetenegi) + \
					int(Evrensel.veriler["oyuncu_tanrisi"].ronesans_yetenegi)
	return tanri_gucu

func yanlis_giris_popup_goster():
	if get_tree().get_current_scene().has_node("PopupGenel"):
		get_tree().get_current_scene().get_node("PopupGenel").queue_free()
	var PopupGenel = load("res://sceneler/PopupGenel.tscn").instance()
	PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = "Oops!"
	PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Wrong Username/ Password Combination. Please Try again!"
	get_tree().get_current_scene().add_child(PopupGenel)
	PopupGenel.popup()	
	
func baglanti_koptu_goster():
	if not get_tree().get_current_scene().has_node("BaglantiKoptu"):
		var baglanti_koptu = load(veriler["baglanti_koptu_sahnesi"]).instance()
		get_tree().get_current_scene().add_child(baglanti_koptu)
	
func baglanti_koptu_kaybet():
	if get_tree().get_current_scene().has_node("BaglantiKoptu"):
		get_tree().get_current_scene().get_node("BaglantiKoptu").queue_free()

func tekrar_dene_yada_cik_popup_goster():
	baglanti_koptu_kaybet()
	var popup_tekrar_dene_yada_cik = load(veriler["popup_tekrar_dene_yada_cik"]).instance()
	get_tree().get_current_scene().call_deferred("add_child", popup_tekrar_dene_yada_cik)
	popup_tekrar_dene_yada_cik.popup_exclusive = true
	popup_tekrar_dene_yada_cik.popup()
	yield(popup_tekrar_dene_yada_cik,"tamam")

func tiklama_efekti(eleman):
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(eleman, "modulate", 
	  Color(1, 1, 1, 7), Color(1, 1, 1, 1), 0.3, 
	  Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	
func yukleniyor_goster():
	if not get_tree().get_current_scene().has_node("Yukleniyor"):
		get_tree().get_current_scene().call_deferred("add_child",loading.instance())		
		#add_child(loading.instance())

	

func yukleniyor_kaybet():
	if get_tree().get_current_scene().has_node("Yukleniyor"):
#		print("kaybettim")
		get_tree().get_current_scene().get_node("Yukleniyor").queue_free()



func data_duzelt_bosluklu(data):
	data.erase(0,3)
#	data = data.replacen(" ","")
	data = data.replacen("\"","")
	data = data.replacen("\'","")
	data = data.replacen("[","")
	data = data.replacen("]]","")	
	return data			
		
func data_duzelt(data):
	data.erase(0,3)
	data = data.replacen(" ","")
	data = data.replacen("\'","")
	data = data.replacen("[","")
	data = data.replacen("]]","")	
	return data
	
		
# Eğer talep_eden bildirilmezse o scene yaşamaya devam eder
func sahne_degistir(gidecek = null, gelecek = null):
	if gelecek != null:		#gelecek sahne varsa
		veriler["sahne_yukleyici"] = ResourceLoader.load_interactive(gelecek) # sahneyi multiprocess yükle
	if gidecek != null:		#gidecek sahne varsa
		veriler["silinecek_sahne"] = gidecek

func _process(delta):	#set_process(true) her daim
	if Input.is_mouse_button_pressed(1) and efekt_sesi:
		tiklama_calar.play()
	if veriler["client"] != null:
		veriler["client"].poll()
	oyuncu_oyunda_mi()
#	call_deferred("oyuncu_oyunda_mi")
	if veriler["sahne_yukleyici"] != null:	#sahne yükleyici sahneyi almışsa
		if veriler["sahne_yukleyici"].poll() == ERR_FILE_EOF:	#sahnenin yüklemesi tamamlanmışsa
			if get_tree().get_current_scene().has_node("Yukleniyor"):	#halen yükleme devam ediyorsa
				get_tree().get_current_scene().get_node("Yukleniyor").queue_free()	#yüklemeyi bitir
				var sahne = veriler["sahne_yukleyici"].get_resource().instance()
				get_tree().get_root().add_child(sahne)
				get_tree().current_scene = sahne
			veriler["sahne_yukleyici"] = null	#sahne yükleyiciyi null yap sürekli çoğalmasın
			if veriler["silinecek_sahne"] != null:
				veriler["silinecek_sahne"].queue_free()
		else:	#sahne yükleyici yüklemeyi tamamlamışsa
			if not get_tree().get_current_scene().has_node("Yukleniyor"):	#yükleniyor başlamamışsa
				get_tree().get_current_scene().add_child(loading.instance())	 #başlat
			
func oyuncu_oyunda_mi():
	if veriler["oyuncu_evreni_id"] != null and veriler["oyuncu_tanrisi_id"] != null:
		veriler["oyuncu_oyunda_mi"] = true
	else:
		veriler["oyuncu_oyunda_mi"] = false

func oyuncu_tanrisi_bilgilerini_guncelle():
	karsiya_gonder("8,%s" % veriler["oyuncu_tanrisi_id"])
	
func timer_yarat(caller=self,suresi=2,tek_atimlik=true):
	var timer1 = Timer.new()
	timer1.one_shot = tek_atimlik
	timer1.wait_time = suresi
	timer1.connect("timeout",caller,"_timer_doldu")
	caller.add_child(timer1)
	timer1.start()
	return timer1

func muzik_degistir(muzik):
	if muzik_calar.playing:
		var tween = Tween.new()
		if not is_a_parent_of(tween):
			add_child(tween)
		tween.interpolate_property(muzik_calar, "volume_db", 0, -80, 2, 1, Tween.EASE_IN, 0)
		tween.start()
		yield(tween,"tween_completed")
		muzik_calar.stop()
		muzik_calar.volume_db = 0		
		muzik_calar.stream = load(muzik)
		if muzik_sesi:
			muzik_calar.play()
	else:
		muzik_calar.stream = load(muzik)
		if muzik_sesi:
			muzik_calar.play()			
				
func efekt_ver(efekt):
	if not efekt_calar.playing:
		muzik_calar.volume_db = -5
		var e = load(efekt)
		efekt_calar.stream = e
		if efekt_sesi:
			efekt_calar.play()
		yield(efekt_calar,"finished")
		muzik_calar.volume_db = 0

"""
	if kayit_dosyasi.load_encrypted_pass(veriler["kayit_dosya_yolu"],veriler["kayit_dosya_sifresi"]) == OK:
		if kayit_dosyasi.has_section("ses_ayarlari"):
			if kayit_dosyasi.get_value("ses_ayarlari","muzik") == true:
				
	if kayit_dosyasi.load_encrypted_pass(veriler["kayit_dosya_yolu"],veriler["kayit_dosya_sifresi"]) == OK:
		if kayit_dosyasi.has_section("ses_ayarlari"):
			if kayit_dosyasi.get_value("ses_ayarlari","efekt") == true:
"""
