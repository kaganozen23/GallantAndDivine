extends Control

var GalaksiBilgileri
var yildiz
var SecilmisYildiz
var yildiz_parent 
onready var felaket_emri = $Arkaplan/HboxContainer/EmirPanosu/VScrollBar/VBoxContainer/FelaketEmri
onready var savas_emri = $Arkaplan/HboxContainer/EmirPanosu/VScrollBar/VBoxContainer/SavasEmri
onready var hastalik_emri = $Arkaplan/HboxContainer/EmirPanosu/VScrollBar/VBoxContainer/HastalikEmri
onready var kriz_emri = $Arkaplan/HboxContainer/EmirPanosu/VScrollBar/VBoxContainer/KrizEmri
onready var buyuculuk_emri = $Arkaplan/HboxContainer/EmirPanosu/VScrollBar/VBoxContainer/BuyuculukEmri
onready var ureme_emri = $Arkaplan/HboxContainer/EmirPanosu/VScrollBar/VBoxContainer/UremeEmri
onready var tarim_emri = $Arkaplan/HboxContainer/EmirPanosu/VScrollBar/VBoxContainer/TarimEmri
onready var dirlik_emri = $Arkaplan/HboxContainer/EmirPanosu/VScrollBar/VBoxContainer/DirlikEmri
onready var ronesans_emri = $Arkaplan/HboxContainer/EmirPanosu/VScrollBar/VBoxContainer/RonesansEmri
onready var dua_emri = $Arkaplan/HboxContainer/EmirPanosu/VScrollBar/VBoxContainer/DuaEmri
onready var esya_kullan = $Arkaplan/HboxContainer/EmirPanosu/VScrollBar/VBoxContainer/EsyaKullan
signal onay

func baslat(g,y,s):
	GalaksiBilgileri = g
	yildiz = y.duplicate()
	yildiz_parent = y.get_parent().duplicate()
	SecilmisYildiz = s

func _process(delta):
	if (int(Evrensel.veriler.tanri_haklari.emir_hakki) <= 0 or $Arkaplan/HboxContainer/BilgiPanosu/VBoxContainer/Uzaylilik/TextureProgress2.value>0 or SecilmisYildiz.nufus == "0"):
		for buton in $Arkaplan/HboxContainer/EmirPanosu/VScrollBar/VBoxContainer.get_children():
			if not buton.disabled:
				if buton.get_child(0).name != "EsyaKullan":
					buton.disabled = true
	else:
		for buton in $Arkaplan/HboxContainer/EmirPanosu/VScrollBar/VBoxContainer.get_children():
			buton.disabled = false
		

func _ready():
	$Arkaplan/GalaksiIsmi.text = GalaksiBilgileri.isim
	$Arkaplan/YildizIsmi.text = yildiz.get_node("Ismi").text
	$Arkaplan/HboxContainer/BilgiPanosu/VBoxContainer/Populasyon.text = "Population:\n" + SecilmisYildiz.nufus
	$Arkaplan/HboxContainer/BilgiPanosu/VBoxContainer/Refah.text = "Welfare:\n" + SecilmisYildiz.refah_puani
	$Arkaplan/HboxContainer/BilgiPanosu/VBoxContainer/Bilim.text = "Science:\n" + SecilmisYildiz.bilim_puani
	$Arkaplan/HboxContainer/BilgiPanosu/VBoxContainer/Inanc.text = "Faith:\n" + SecilmisYildiz.inanc_puani
	$Arkaplan/HboxContainer/BilgiPanosu/VBoxContainer/Kaynak.text = "Resource:\n" + SecilmisYildiz.kaynak_puani
	$Arkaplan/HboxContainer/BilgiPanosu/VBoxContainer/Iyilik/TextureProgress3.value = int(SecilmisYildiz.iyilik_yuzdesi)
	$Arkaplan/HboxContainer/BilgiPanosu/VBoxContainer/Iyilik/TextureProgress3/IyilikText.text = "%s / 100" % int(SecilmisYildiz.iyilik_yuzdesi)
	$Arkaplan/HboxContainer/BilgiPanosu/VBoxContainer/Uzaylilik/TextureProgress2.value = int(SecilmisYildiz.uzayli_yuzdesi)
	$Arkaplan/HboxContainer/BilgiPanosu/VBoxContainer/Uzaylilik/TextureProgress2/UzaylikikText.text = "%s / 100" % int(SecilmisYildiz.uzayli_yuzdesi)
	var gosterilecek_yildiz = yildiz_parent
	gosterilecek_yildiz.rect_min_size = Vector2(80,80)
	gosterilecek_yildiz.get_node("Yildiz/Ismi").hide()
	gosterilecek_yildiz.get_node("Yildiz/EmirResmi").hide()
	if $Arkaplan/HboxContainer/BilgiPanosu/CenterContainer.get_child_count() == 0:
		$Arkaplan/HboxContainer/BilgiPanosu/CenterContainer.add_child(gosterilecek_yildiz)
	Evrensel.veriler.yielded = bilgileri_topla()
	felaket_emri.connect("pressed",self,"_on_emir_pressed",[felaket_emri,1]) if not felaket_emri.is_connected("pressed",self,"_on_emir_pressed") else null
	savas_emri.connect("pressed",self,"_on_emir_pressed",[savas_emri,2]) if not savas_emri.is_connected("pressed",self,"_on_emir_pressed") else null
	hastalik_emri.connect("pressed",self,"_on_emir_pressed",[hastalik_emri,3]) if not hastalik_emri.is_connected("pressed",self,"_on_emir_pressed") else null
	kriz_emri.connect("pressed",self,"_on_emir_pressed",[kriz_emri,4]) if not kriz_emri.is_connected("pressed",self,"_on_emir_pressed") else null
	buyuculuk_emri.connect("pressed",self,"_on_emir_pressed",[buyuculuk_emri,5]) if not buyuculuk_emri.is_connected("pressed",self,"_on_emir_pressed") else null
	ureme_emri.connect("pressed",self,"_on_emir_pressed",[ureme_emri,6]) if not ureme_emri.is_connected("pressed",self,"_on_emir_pressed") else null
	tarim_emri.connect("pressed",self,"_on_emir_pressed",[tarim_emri,7]) if not tarim_emri.is_connected("pressed",self,"_on_emir_pressed") else null
	dirlik_emri.connect("pressed",self,"_on_emir_pressed",[dirlik_emri,8]) if not dirlik_emri.is_connected("pressed",self,"_on_emir_pressed") else null
	ronesans_emri.connect("pressed",self,"_on_emir_pressed",[ronesans_emri,9]) if not ronesans_emri.is_connected("pressed",self,"_on_emir_pressed") else null
	dua_emri.connect("pressed",self,"_on_emir_pressed",[dua_emri,10]) if not dua_emri.is_connected("pressed",self,"_on_emir_pressed") else null
	if Evrensel.kayit_dosyasi.load_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"]) == OK:
		if Evrensel.kayit_dosyasi.has_section(SecilmisYildiz.adi):
			if Evrensel.kayit_dosyasi.get_value(SecilmisYildiz.adi,"gecmis"):
				$Arkaplan/DurumKutusu/HBoxContainer/ColorRect3/VBoxContainer2/MarginContainer/ScrollContainer/Gecmis.text = Evrensel.kayit_dosyasi.get_value(SecilmisYildiz.adi,"gecmis")			
	
func _on_emir_pressed(buton,emir_no):
	yield(secim_popup_goster(buton.get_child(0).text),"completed")
	if(Evrensel.veriler["secim_cevabi"]):	#emri verdiyse
		Evrensel.veriler["secim_cevabi"] = false
		Evrensel.efekt_ver("res://sesler/emir_verme.ogg")
#		print("emri verdi")
#		Evrensel.yukleniyor_goster()
		Evrensel.karsiya_gonder("16,"+Evrensel.veriler["oyuncu_tanrisi_id"] +"," + SecilmisYildiz.id + "," + String(emir_no))	#emri isle
		Evrensel.karsiya_gonder("17,emir_hakki," +Evrensel.veriler["oyuncu_tanrisi_id"])	#emir hakkini azalt
		Evrensel.veriler.tanri_haklari.emir_hakki = String(int(Evrensel.veriler.tanri_haklari.emir_hakki) - 1)	#emir hakkini al
		$Arkaplan/DurumKutusu/HBoxContainer/ColorRect3/VBoxContainer2/MarginContainer/ScrollContainer/Gecmis.text += buton.get_child(0).text + " on " + SecilmisYildiz.adi + " at timeslice " + String(Evrensel.veriler.evren_zamani) + "\n"
		Evrensel.kayit_dosyasi.set_value(SecilmisYildiz.adi,"gecmis",$Arkaplan/DurumKutusu/HBoxContainer/ColorRect3/VBoxContainer2/MarginContainer/ScrollContainer/Gecmis.text)
		Evrensel.kayit_dosyasi.save_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"])
		var emir_sonrasi_sahnesi = load(Evrensel.veriler["emir_sonrasi_sahnesi"]).instance()
		emir_sonrasi_sahnesi.baslat(buton.get_child(1).texture,"Your %s \nhas commenced!" % buton.get_child(0).text)
		emir_sonrasi_sahnesi.connect("tree_exited",self,"_on_emir_sonrasi")
		add_child(emir_sonrasi_sahnesi)
		
func _on_emir_sonrasi():
		var IcGalaksi = load(Evrensel.veriler["ic_galaksi_sahnesi"]).instance()
		IcGalaksi.baslat(GalaksiBilgileri)	#verileri yeni sahnenin baslat fonk. yolla
		if find_parent("*"):
			get_parent().add_child(IcGalaksi)
			get_parent().move_child(IcGalaksi,1)
			queue_free()	
	
func bilgileri_topla():	
	Evrensel.yukleniyor_goster()
	Evrensel.karsiya_gonder("12," + Evrensel.veriler["oyuncu_tanrisi_id"] ) #tanri haklarini sorgula
	Evrensel.karsiya_gonder("14," + Evrensel.veriler["oyuncu_tanrisi_id"] +"," + SecilmisYildiz.id) #cazibe sorgula
	Evrensel.karsiya_gonder("15," + Evrensel.veriler["oyuncu_tanrisi_id"] +"," + SecilmisYildiz.id)	#mevcut emir var mi
	Evrensel.karsiya_gonder("32," + Evrensel.veriler["oyuncu_tanrisi_id"] +"," + SecilmisYildiz.id) #manafin kuresi kullanilmis mi
	Evrensel.karsiya_gonder("96," + Evrensel.veriler["oyuncu_tanrisi_id"] +"," + SecilmisYildiz.id) #sielulintu kullanilmis mi
	yield()
	yield()
	yield()
	yield()
	yield()
	bilgileri_yaz()
	Evrensel.yukleniyor_kaybet()
	
func bilgileri_yaz():
	$Arkaplan/DurumKutusu/HBoxContainer/ColorRect/VBoxContainer/EmirSayisi.text = String(Evrensel.veriler.tanri_haklari.emir_hakki)
	$Arkaplan/HboxContainer/BilgiPanosu/VBoxContainer/Cazibe/TextureProgress.value = int(Evrensel.veriler["secili_yildiz_cazibe"])	
	$Arkaplan/HboxContainer/BilgiPanosu/VBoxContainer/Cazibe/TextureProgress/CazibeText.text = String(Evrensel.veriler["secili_yildiz_cazibe"]) + " / 100"
	$Arkaplan/DurumKutusu/HBoxContainer/ColorRect/VBoxContainer/ScrollContainer/EmirIsmi.text = Evrensel.veriler.secili_yildiz_emri
	if Evrensel.veriler["verilen_tum_emirler"]:
		for eleman in Evrensel.veriler["verilen_tum_emirler"]:
			$Arkaplan/DurumKutusu/HBoxContainer/ColorRect2/VBoxContainer2/ScrollContainer/ManafinKuresi.text += String(eleman).replacen(",","|") + "\n"
		Evrensel.veriler["verilen_tum_emirler"] = []
	$Arkaplan/DurumKutusu/HBoxContainer/ColorRect/VBoxContainer/Label6.text = String(Evrensel.veriler.sielulintu)
	Evrensel.veriler.sielulintu = "-"


func _on_GeriButon_pressed():
	var IcGalaksi = load(Evrensel.veriler["ic_galaksi_sahnesi"]).instance()
	IcGalaksi.baslat(GalaksiBilgileri)
	get_parent().add_child(IcGalaksi)
	get_parent().move_child(IcGalaksi,1)
	queue_free()


func _on_GecmisTemizle_pressed():
	if Evrensel.kayit_dosyasi.has_section(SecilmisYildiz.adi):
			Evrensel.kayit_dosyasi.erase_section(SecilmisYildiz.adi)
			Evrensel.kayit_dosyasi.save_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"])
	$Arkaplan/DurumKutusu/HBoxContainer/ColorRect3/VBoxContainer2/MarginContainer/ScrollContainer/Gecmis.text =""
	
func secim_popup_goster(emir_text):
	var PopupOnay = load("res://sceneler/PopupOnay.tscn").instance()
	PopupOnay.get_node("Arkaplan/Metin/Metin").text = \
	"Are you sure that you want to %s on %s?" % [emir_text,SecilmisYildiz.adi]
	get_tree().get_current_scene().add_child(PopupOnay)
	PopupOnay.popup_centered()
	yield(PopupOnay,"tamam")
	


func _on_EsyaKullan_pressed():
	var esya_sahnesi = load(Evrensel.veriler["esya_sahnesi"]).instance()
	var anlik_popup = Popup.new()
	anlik_popup.rect_size = Vector2(550,750)
	anlik_popup.add_child(esya_sahnesi)
	add_child(anlik_popup)
	esya_sahnesi.baslat("Stars",3,null,SecilmisYildiz)
	anlik_popup.popup_centered()

