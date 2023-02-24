extends Popup

onready var tanri_resmi = $Arkaplan/Container/VBoxContainer/TanriBuyukResim
onready var oyuncu_ismi = $Arkaplan/Container/VBoxContainer/OyuncuIsmi
onready var tanri_ismi= $Arkaplan/Container/VBoxContainer/TanriIsmi
onready var panteon_ismi = $Arkaplan/Container/VBoxContainer/PanteonIsmi
onready var savas_gucu = $Arkaplan/Container/Barlar/WarfareBar
onready var felaket_gucu = $Arkaplan/Container/Barlar/CalamityBar
onready var kaos_gucu = $Arkaplan/Container/Barlar/ChaosBar
onready var ekonomi_gucu = $Arkaplan/Container/Barlar/FortuneBar
onready var ilahi_gucu = $Arkaplan/Container/Barlar/DivineBar
onready var ronesans_gucu = $Arkaplan/Container/Barlar/RenaissanceBar
onready var amulet_of_tatula = $Arkaplan/Container/VBoxContainer2/ColorRect/Bufflar/HBoxContainer/AmuletofTatula
onready var schrimnirs_beef = $Arkaplan/Container/VBoxContainer2/ColorRect/Bufflar/HBoxContainer2/SchrimnirsBeef
onready var schrimnirs_milk = $Arkaplan/Container/VBoxContainer2/ColorRect/Bufflar/HBoxContainer3/SchrimnirsMilk
onready var ayahuaska = $Arkaplan/Container/VBoxContainer2/ColorRect/Bufflar/HBoxContainer4/Ayahuaska
onready var tjatis_boomerang = $Arkaplan/Container/VBoxContainer2/ColorRect/Bufflar/HBoxContainer5/TjatisBoomerang
onready var hanumans_tail = $Arkaplan/Container/VBoxContainer2/ColorRect/Bufflar/HBoxContainer6/HanumansTail
onready var trizul = $Arkaplan/Container/VBoxContainer2/ColorRect/Bufflar/HBoxContainer7/Trizul
onready var zephyrus_disc = $Arkaplan/Container/VBoxContainer2/ColorRect/Bufflar/HBoxContainer8/ZephyrusDisc
onready var on_texture = load("res://resimler/online.webp")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Arkaplan.visible = false
	add_to_group("popuplar")
	Evrensel.veriler.yielded = bilgileri_al()


func bilgileri_al():
	if not Evrensel.veriler["tum_tanrilar"]:
		Evrensel.karsiya_gonder("1")	#ana tanrilari al
		yield()
	Evrensel.karsiya_gonder("56,%s" % Evrensel.veriler["oyuncu_tanrisi_id"])	#tanri bilgilerini al	
	yield()
	bilgileri_isle()
	$Arkaplan.visible = true

func bilgileri_isle():
	if Evrensel.veriler.tum_tanrilar and Evrensel.tanri_popup_bilgileri:
		tanri_resmi.texture = load("res://resimler/tanrilar/buyuk/%s_290_470.webp" % Evrensel.tanri_popup_bilgileri[1])
		oyuncu_ismi.text = Evrensel.tanri_popup_bilgileri[0]
		tanri_ismi.text = "Virtuos God: " if Evrensel.tanri_popup_bilgileri[17] == "True" else "Evil God: "
		tanri_ismi.text+=Evrensel.tanri_popup_bilgileri[1]
		panteon_ismi.text = "Panteon: " + Evrensel.tanri_popup_bilgileri[2] if Evrensel.tanri_popup_bilgileri[2] != "None" else ""
		savas_gucu.value = int(Evrensel.tanri_popup_bilgileri[3])
		savas_gucu.get_child(0).text = Evrensel.tanri_popup_bilgileri[3]
		felaket_gucu.value = int(Evrensel.tanri_popup_bilgileri[4])
		felaket_gucu.get_child(0).text = Evrensel.tanri_popup_bilgileri[4]
		kaos_gucu.value = int(Evrensel.tanri_popup_bilgileri[5])
		kaos_gucu.get_child(0).text = Evrensel.tanri_popup_bilgileri[5]
		ekonomi_gucu.value = int(Evrensel.tanri_popup_bilgileri[6])
		ekonomi_gucu.get_child(0).text = Evrensel.tanri_popup_bilgileri[6]
		ilahi_gucu.value = int(Evrensel.tanri_popup_bilgileri[7])
		ilahi_gucu.get_child(0).text = Evrensel.tanri_popup_bilgileri[7]
		ronesans_gucu.value = int(Evrensel.tanri_popup_bilgileri[8])
		ronesans_gucu.get_child(0).text = Evrensel.tanri_popup_bilgileri[8]
		$Arkaplan/Container/VBoxContainer2/ToplamGuc.text += \
		str(ronesans_gucu.value+ilahi_gucu.value+ekonomi_gucu.value+kaos_gucu.value+felaket_gucu.value+savas_gucu.value)
		amulet_of_tatula.texture = on_texture if Evrensel.tanri_popup_bilgileri[9] != "None" else amulet_of_tatula.texture
		schrimnirs_beef.texture = on_texture if Evrensel.tanri_popup_bilgileri[10] != "None" else schrimnirs_beef.texture
		schrimnirs_milk.texture = on_texture if Evrensel.tanri_popup_bilgileri[11] != "None" else schrimnirs_milk.texture
		ayahuaska.texture = on_texture if Evrensel.tanri_popup_bilgileri[12] != "None" else ayahuaska.texture
		tjatis_boomerang.texture = on_texture if Evrensel.tanri_popup_bilgileri[13] != "None" else tjatis_boomerang.texture
		hanumans_tail.texture = on_texture if Evrensel.tanri_popup_bilgileri[14] != "None" else hanumans_tail.texture
		trizul.texture = on_texture if Evrensel.tanri_popup_bilgileri[15] != "None" else trizul.texture 
		zephyrus_disc.texture = on_texture if Evrensel.tanri_popup_bilgileri[16] != "None" else zephyrus_disc.texture
		
func _on_TanriBilgileri_popup_hide():
	queue_free()

