extends Control
#warnings-disable
onready var tanri_savasi_hakki = $Arkaplan/VBoxContainer/TextureRect/Label/Kalan
onready var kendi_tanrisi_ismi = $Arkaplan/VBoxContainer/HBoxContainer/ColorRect/VBoxContainer2/TanriIsmi
onready var kendi_oyuncu_ismi = $Arkaplan/VBoxContainer/HBoxContainer/ColorRect/VBoxContainer2/OyuncuIsmi
onready var kendi_toplam_gucu = $Arkaplan/VBoxContainer/HBoxContainer/ColorRect/VBoxContainer2/ToplamGuc
onready var kendi_resmi = $Arkaplan/VBoxContainer/HBoxContainer/ColorRect/VBoxContainer2/CenterContainer/TanriResmi
onready var rakip_tanrisi_ismi = $Arkaplan/VBoxContainer/HBoxContainer/ColorRect2/VBoxContainer/RakipTanriIsmi
onready var rakip_oyuncu_ismi = $Arkaplan/VBoxContainer/HBoxContainer/ColorRect2/VBoxContainer/RakipOyuncuIsmi
onready var rakip_toplam_gucu = $Arkaplan/VBoxContainer/HBoxContainer/ColorRect2/VBoxContainer/ToplamGuc2
onready var rakip_resmi = $Arkaplan/VBoxContainer/HBoxContainer/ColorRect2/VBoxContainer/CenterContainer/RakipTanriResmi
signal onay
var kazanma_sansi = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	Evrensel.veriler.yielded = bilgileri_topla()
	
		
func bilgileri_topla():
	Evrensel.yukleniyor_goster()
	Evrensel.karsiya_gonder("8,%s" % Evrensel.veriler["oyuncu_tanrisi_id"])	#oyuncu_tanrisinin bilgilerini al
	Evrensel.karsiya_gonder("12," + Evrensel.veriler["oyuncu_tanrisi_id"] ) #tanri haklarini sorgula
	Evrensel.karsiya_gonder("27," + Evrensel.veriler["oyuncu_tanrisi_id"])	#rastgele tanri al
	Evrensel.karsiya_gonder("95," + Evrensel.veriler["oyuncu_tanrisi_id"])	#tjatis boomerang sorgu
	Evrensel.karsiya_gonder("93," + Evrensel.veriler["oyuncu_tanrisi_id"])	#Zephyrus Disc sorgu
	yield()
	yield()
	yield()
	yield()
	yield()
	kendi_bilgilerini_yaz()
	rakip_bilgilerini_yaz()
	if Evrensel.veriler.rakip_tanri:
		Evrensel.karsiya_gonder("36,%s" % Evrensel.veriler["rakip_tanri"].id)	#amulet of tatula kontrol
		yield()
	Evrensel.yukleniyor_kaybet()	


func kendi_bilgilerini_yaz():
	kendi_tanrisi_ismi.text = "God " + Evrensel.veriler.oyuncu_tanrisi["isim"]
	kendi_oyuncu_ismi.text = "By " + Evrensel.veriler.oyuncu["nick"]
	kendi_toplam_gucu.text = "With a total power of " + tanri_toplam_guc_hesapla(Evrensel.veriler.oyuncu_tanrisi)
	kendi_resmi.texture = Evrensel.veriler.oyuncu_tanrisi["tanri_texture_buyuk"]
	tanri_savasi_hakki.text = String(Evrensel.veriler.tanri_haklari["tanrilarla_savas_hakki"])
	barlari_duzenle()

func tanri_toplam_guc_hesapla(tanri):
	return String( int(tanri["savas_yetenegi"]) + int(tanri["felaket_yetenegi"]) + int(tanri["ekonomi_yetenegi"]) + int(tanri["ilahi_yetenegi"]) + int(tanri["kaos_yetenegi"]) + int(tanri["ronesans_yetenegi"]) )

func rakip_bilgilerini_yaz():
	if Evrensel.veriler.rakip_tanri:
		if int(Evrensel.veriler.tanri_haklari["tanrilarla_savas_hakki"]) > 0:
			$Arkaplan/VBoxContainer/HBoxContainer2/Saldir.disabled = false
		rakip_tanrisi_ismi.text = "God " + Evrensel.veriler.rakip_tanri["isim"]
		rakip_oyuncu_ismi.text = "By " + Evrensel.veriler.rakip_tanri["rakip_oyuncu_isim"]
		rakip_toplam_gucu.text = "With a total power of " + tanri_toplam_guc_hesapla(Evrensel.veriler.rakip_tanri)
		rakip_resmi.texture = Evrensel.veriler.rakip_tanri["tanri_texture_buyuk"]		
	else:
		$Arkaplan/VBoxContainer/HBoxContainer2/Saldir.disabled = true
		rakip_tanrisi_ismi.text = ""
		rakip_toplam_gucu.text = ""
		rakip_resmi.texture = null
		rakip_oyuncu_ismi.text = "No God ever dares facing you. Re-roll!"


func _on_Yenile_pressed():
	_ready()
	
func barlari_duzenle():
	$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Kendi/Barlar/WarfareBar.value = int(Evrensel.veriler["oyuncu_tanrisi"].savas_yetenegi)
	$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Kendi/Barlar/CalamityBar.value = int(Evrensel.veriler["oyuncu_tanrisi"].felaket_yetenegi)
	$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Kendi/Barlar/ChaosBar.value = int(Evrensel.veriler["oyuncu_tanrisi"].kaos_yetenegi)
	$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Kendi/Barlar/FortuneBar.value = int(Evrensel.veriler["oyuncu_tanrisi"].ekonomi_yetenegi)
	$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Kendi/Barlar/DivineBar.value = int(Evrensel.veriler["oyuncu_tanrisi"].ilahi_yetenegi)
	$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Kendi/Barlar/RenaissanceBar.value = int(Evrensel.veriler["oyuncu_tanrisi"].ronesans_yetenegi)
	$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Kendi/Barlar/WarfareBar/WarfareText.text = Evrensel.veriler["oyuncu_tanrisi"].savas_yetenegi
	$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Kendi/Barlar/CalamityBar/CalamityText.text = Evrensel.veriler["oyuncu_tanrisi"].felaket_yetenegi
	$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Kendi/Barlar/ChaosBar/ChaosText.text = Evrensel.veriler["oyuncu_tanrisi"].kaos_yetenegi
	$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Kendi/Barlar/FortuneBar/FortuneText.text = Evrensel.veriler["oyuncu_tanrisi"].ekonomi_yetenegi
	$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Kendi/Barlar/DivineBar/DivineText.text = Evrensel.veriler["oyuncu_tanrisi"].ilahi_yetenegi
	$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Kendi/Barlar/RenaissanceBar/RenaissanceText.text = Evrensel.veriler["oyuncu_tanrisi"].ronesans_yetenegi	
	if Evrensel.veriler.rakip_tanri:
		$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Rakip/Barlar/WarfareBar.value = int(Evrensel.veriler["rakip_tanri"].savas_yetenegi)
		$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Rakip/Barlar/CalamityBar.value = int(Evrensel.veriler["rakip_tanri"].felaket_yetenegi)
		$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Rakip/Barlar/ChaosBar.value = int(Evrensel.veriler["rakip_tanri"].kaos_yetenegi)
		$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Rakip/Barlar/FortuneBar.value = int(Evrensel.veriler["rakip_tanri"].ekonomi_yetenegi)
		$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Rakip/Barlar/DivineBar.value = int(Evrensel.veriler["rakip_tanri"].ilahi_yetenegi)
		$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Rakip/Barlar/RenaissanceBar.value = int(Evrensel.veriler["rakip_tanri"].ronesans_yetenegi)
		$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Rakip/Barlar/WarfareBar/WarfareText.text = Evrensel.veriler["rakip_tanri"].savas_yetenegi
		$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Rakip/Barlar/CalamityBar/CalamityText.text = Evrensel.veriler["rakip_tanri"].felaket_yetenegi
		$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Rakip/Barlar/ChaosBar/ChaosText.text = Evrensel.veriler["rakip_tanri"].kaos_yetenegi
		$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Rakip/Barlar/FortuneBar/FortuneText.text = Evrensel.veriler["rakip_tanri"].ekonomi_yetenegi
		$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Rakip/Barlar/DivineBar/DivineText.text = Evrensel.veriler["rakip_tanri"].ilahi_yetenegi
		$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Rakip/Barlar/RenaissanceBar/RenaissanceText.text = Evrensel.veriler["rakip_tanri"].ronesans_yetenegi	
	else:
		$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Rakip/Barlar/WarfareBar.value = 0
		$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Rakip/Barlar/CalamityBar.value = 0
		$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Rakip/Barlar/ChaosBar.value = 0
		$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Rakip/Barlar/FortuneBar.value = 0
		$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Rakip/Barlar/DivineBar.value = 0
		$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Rakip/Barlar/RenaissanceBar.value = 0
		$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Rakip/Barlar/WarfareBar/WarfareText.text = ""
		$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Rakip/Barlar/CalamityBar/CalamityText.text = ""
		$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Rakip/Barlar/ChaosBar/ChaosText.text = ""
		$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Rakip/Barlar/FortuneBar/FortuneText.text = ""
		$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Rakip/Barlar/DivineBar/DivineText.text = ""
		$Arkaplan/VBoxContainer/ColorRect/HBoxContainer/Rakip/Barlar/RenaissanceBar/RenaissanceText.text = ""
		

func _on_Saldir_pressed():
	kazanma_sansi = float(tanri_toplam_guc_hesapla(Evrensel.veriler.oyuncu_tanrisi))  / ( float(tanri_toplam_guc_hesapla(Evrensel.veriler.oyuncu_tanrisi)) + float(tanri_toplam_guc_hesapla(Evrensel.veriler.rakip_tanri)) )
	kazanma_sansi = kazanma_sansi*100
	if Evrensel.veriler.tjatis:
		kazanma_sansi += 5
	if Evrensel.veriler.disk:
		kazanma_sansi = 100
	var metin = "Are you sure that you want to challange " + rakip_tanrisi_ismi.text + " " + rakip_oyuncu_ismi.text + " " + rakip_toplam_gucu.text + "?"
	metin += "\n Win probability: %" + String("%.2f" % kazanma_sansi)
	secim_popup_goster(metin)
	
func secim_popup_goster(metin):
	var PopupOnay = load("res://sceneler/PopupOnay.tscn").instance()
	PopupOnay.get_node("Arkaplan/Metin/Metin").text = metin
	PopupOnay.get_node("Arkaplan/Metin/Metin").align = 1	#center
	add_child(PopupOnay)
	PopupOnay.popup_centered()
#	local_yield = yield(PopupOnay,"tamam")


func _on_Ana_onay():	#popuptan onay geldiginde olacaklar
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rastgele_sayi = rng.randf_range(0.0, 100.0)
	if Evrensel.veriler["rakip_tanri_tatula"]:	#rakipte tatula nazarligi varsa
		rastgele_sayi = 100
	if rastgele_sayi <= kazanma_sansi:
		var kazanan = Evrensel.veriler["oyuncu_tanrisi"]
		var kaybeden = Evrensel.veriler["rakip_tanri"]
		Evrensel.veriler.yielded = savas_sonu_hesapla_yaz(kazanan,kaybeden)
	else:
		var kazanan = Evrensel.veriler["rakip_tanri"]
		var kaybeden = Evrensel.veriler["oyuncu_tanrisi"]
		Evrensel.veriler.yielded = savas_sonu_hesapla_yaz(kazanan,kaybeden)

	
func savas_sonu_hesapla_yaz(kazanan,kaybeden):
	Evrensel.yukleniyor_goster()
	#kendi tanri bilgilerini tekrar al
	Evrensel.karsiya_gonder("12," + Evrensel.veriler["oyuncu_tanrisi_id"] )
	#rakip tanri bilgilerini tekrar al
	Evrensel.karsiya_gonder("28," + Evrensel.veriler["rakip_tanri"].id )
	yield()
	yield()
	Evrensel.yukleniyor_kaybet()
	
	if kazanan.id == Evrensel.veriler["oyuncu_tanrisi_id"]:
		kazanan = Evrensel.veriler["oyuncu_tanrisi"] 
		kaybeden = Evrensel.veriler["rakip_tanri"]
	else:
		kazanan = Evrensel.veriler["rakip_tanri"]
		kaybeden = Evrensel.veriler["oyuncu_tanrisi"] 
		
	var savas_yetenek = int(kaybeden["savas_yetenegi"]) /100
	var felaket_yetenek = int(kaybeden["felaket_yetenegi"]) / 100
	var ekonomi_yetenek = int(kaybeden["ekonomi_yetenegi"]) / 100
	var ilahi_yetenek = int(kaybeden["ilahi_yetenegi"]) / 100
	var kaos_yetenek = int(kaybeden["kaos_yetenegi"]) / 100
	var ronesans_yetenek = int(kaybeden["ronesans_yetenegi"]) / 100
	
	#kazanan tanriya guclerini yaz
	Evrensel.karsiya_gonder("29,%d,%d,%d,%d,%d,%d,%s" % [savas_yetenek,felaket_yetenek,ekonomi_yetenek,ilahi_yetenek,kaos_yetenek,ronesans_yetenek,kazanan.id])
	#kaybeden tanriya guclerini yaz
	Evrensel.karsiya_gonder("29,%d,%d,%d,%d,%d,%d,%s" % [-savas_yetenek,-felaket_yetenek,-ekonomi_yetenek,-ilahi_yetenek,-kaos_yetenek,-ronesans_yetenek,kaybeden.id])
	#kendi tanrimizin hakkini azaltalim
	Evrensel.karsiya_gonder("17,tanrilarla_savas_hakki,"+Evrensel.veriler["oyuncu_tanrisi_id"])	
	#bildirim olusturalim
	var Bildirim_Sinifi = load ("res://sinif_scriptleri/bildirim.gd")
	
	if kazanan.id == Evrensel.veriler["oyuncu_tanrisi_id"]:	#kazanan bensem
		#kendimize kazandi dogrudan bildirimi
		Bildirim_Sinifi.new([Evrensel.veriler["oyuncu_tanrisi_id"],"9", ("You won Titanomahia versus %s %s. You took over 1 percent of opponents powers." % [rakip_tanrisi_ismi.text,rakip_oyuncu_ismi.text]) ])
		#rakibe kaybetti bildirimi uzaktan
		Evrensel.karsiya_gonder("30,"+kaybeden.id+","+Evrensel.veriler.oyuncu_tanrisi["isim"]+","+Evrensel.veriler.oyuncu["nick"]+","+"10")
		#kazandi sahnesi
		savas_sonu_sahnesi(true,Evrensel.veriler.oyuncu_tanrisi,Evrensel.veriler.rakip_tanri,[savas_yetenek,felaket_yetenek,ekonomi_yetenek,ilahi_yetenek,kaos_yetenek,ronesans_yetenek])
	else:	#kazanan rakipse
		#kendimize kaybetti dogrudan bildirimi
		Bildirim_Sinifi.new([Evrensel.veriler["oyuncu_tanrisi_id"],"10", ("You lost Titanomahia versus %s %s. You handed over 1 percent of your powers. Opposing gods Amulet of Tatula: %s" % [rakip_tanrisi_ismi.text,rakip_oyuncu_ismi.text,Evrensel.veriler["rakip_tanri_tatula"]]) ])
		#rakibe kazandi bildirimi uzaktan
		Evrensel.karsiya_gonder("30,"+kazanan.id+","+Evrensel.veriler.oyuncu_tanrisi["isim"]+","+Evrensel.veriler.oyuncu["nick"]+","+"9")
		#kaybetti sahnesi
		savas_sonu_sahnesi(false,Evrensel.veriler.oyuncu_tanrisi,Evrensel.veriler.rakip_tanri,[savas_yetenek,felaket_yetenek,ekonomi_yetenek,ilahi_yetenek,kaos_yetenek,ronesans_yetenek])		
	
		
func savas_sonu_sahnesi(kazandi,ben,rakip_tanri,gucler_dizisi):
	Evrensel.veriler["rakip_tanri_tatula"] = false
	var sonuc_sahnesi = load(Evrensel.veriler["titanomakhia_sonrasi_sahnesi"]).instance()
	sonuc_sahnesi.baslat(kazandi,ben,rakip_tanri,gucler_dizisi)
	add_child(sonuc_sahnesi)	
	Evrensel.karsiya_gonder("12," + Evrensel.veriler["oyuncu_tanrisi_id"] )


func _on_EsyaKullan_pressed():
	var esya_sahnesi = load(Evrensel.veriler["esya_sahnesi"]).instance()
	var anlik_popup = Popup.new()
	anlik_popup.rect_size = Vector2(550,750)
	anlik_popup.add_child(esya_sahnesi)
	add_child(anlik_popup)
	esya_sahnesi.baslat("Self",3)
	anlik_popup.popup_centered()


func _on_Bilgi_pressed():
	var popup = load(Evrensel.veriler["tanri_bilgileri_popup"]).instance()
	add_child(popup)
	popup.popup()


