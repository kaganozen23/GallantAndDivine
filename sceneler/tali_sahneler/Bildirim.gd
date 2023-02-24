extends Control

onready var bildirim_kutusu = $Arkaplan/ScrollContainer/DikeyKonteyner/BildirimKutusu
onready var bildirim_kutusu_babasi = $Arkaplan/ScrollContainer/DikeyKonteyner
var section_keys = null
var bildirim_baslik = {"1":"Lost Possession!",
					"2":"Gained Possesion!",
					"3":"Lost Divine Journey!",
					"4":"Given Divine Journey",
					"5":"Human Race Wiped Out!",
					"6":"Alien Invasion Started!",
					"7":"A New Universe Was Born",
					"8":"Decree Result Report",
					"9":"Titanomahia Won Report",
					"10":"Titanomahia Lost Report",
					"11":"Manafs Sphere",
					"12":"Mistletoe",
					"13":"Cerridwens Cauldron",
					"14":"Amulet of Tatula",
					"15":"Turtle Egg",
					"16":"Esoteric Staff",
					"17":"Purged Decree",
					"18":"Purged Decree",
					"19":"Resurrected Creatures",
					"20":"Completed Divine Journey",
					"21":"Skull Charmed Amulet",
					"22":"Yamantakas Whip",
					"23":"Altered Fate",
					"24":"Tyrfing",
					"25":"Golden Hide",
					"26":"Lapis Lazuli",
					"27":"Orfeus Lyre",
					"28":"Completed Divine Journey!",
					"29":"Pantheon Gift!",
					"30":"Creature Fight",
					"31":"Banshees Silver Comb",
					"32":"Ayahuaska",
					"33":"Xiling Silk",
					"34":"Psykhes Oil Lamp",
					"35":"Hurcans Mirror",
					"36":"Sielulintu",
					"37":"Tjatis Boomerang",
					"38":"Xirang Soil",
					"39":"Indras Electric Spear",
					"40":"Hanumans Tail",
					"41":"Saures Carafe",
					"42":"Trizul",
					"43":"Horus Holy Hearth",
					"44":"Izanagis Spear",
					"45":"Diorite",
					"46":"Holy Book",
					"47":"Zephyrus Disc",}

func _ready():
	if Evrensel.kayit_dosyasi.load_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"]) == OK:
		if Evrensel.kayit_dosyasi.has_section("bildirim"+Evrensel.veriler["oyuncu_tanrisi_id"]):
			section_keys = Evrensel.kayit_dosyasi.get_section_keys("bildirim"+Evrensel.veriler["oyuncu_tanrisi_id"])
			var artik_anahtarlar = section_keys.size()-250
			if (artik_anahtarlar > 0):	#250den fazla bildirim birikmesi engellenecek.
				for key in section_keys:
					Evrensel.kayit_dosyasi.erase_section_key("bildirim"+Evrensel.veriler["oyuncu_tanrisi_id"],key)
					artik_anahtarlar = artik_anahtarlar-1
					if(artik_anahtarlar <=0):
						break
				section_keys = Evrensel.kayit_dosyasi.get_section_keys("bildirim"+Evrensel.veriler["oyuncu_tanrisi_id"])			
			section_keys.invert()
			for key in section_keys:
				var data = Evrensel.kayit_dosyasi.get_value("bildirim"+Evrensel.veriler["oyuncu_tanrisi_id"],key)
				data = data.split(",")
				var yeni_bildirim_kutusu = bildirim_kutusu.duplicate()
				yeni_bildirim_kutusu.visible = true
				yeni_bildirim_kutusu.get_node("IcDikeyKonteyner/Kutumetin").text = bildirim_baslik[String(data[0])].to_upper() + "\n"
				yeni_bildirim_kutusu.get_node("IcDikeyKonteyner/Kutumetin").text += String(data[1])
				match data[0]:
					"8":
						yeni_bildirim_kutusu.rect_min_size.y = 550
					"30":
						yeni_bildirim_kutusu.rect_min_size.y = 300
					"9" or "10":
						yeni_bildirim_kutusu.rect_min_size.y = 300
						
#				yeni_bildirim_kutusu.rect_min_size.y = int(yeni_bildirim_kutusu.get_node("IcDikeyKonteyner/Kutumetin").get_font("font").get_string_size(yeni_bildirim_kutusu.get_node("IcDikeyKonteyner/Kutumetin").text).x/6)
#				print(yeni_bildirim_kutusu.get_node("IcDikeyKonteyner/Kutumetin").get_font("font").get_string_size(yeni_bildirim_kutusu.get_node("IcDikeyKonteyner/Kutumetin").text))
				bildirim_kutusu_babasi.add_child(yeni_bildirim_kutusu)

func _on_Clear_pressed():
	for child in $Arkaplan/ScrollContainer/DikeyKonteyner.get_children():
		if child.get_index() != 0:
			child.queue_free()
	if Evrensel.kayit_dosyasi.has_section("bildirim"+Evrensel.veriler["oyuncu_tanrisi_id"]):
		Evrensel.kayit_dosyasi.erase_section("bildirim"+Evrensel.veriler["oyuncu_tanrisi_id"])
		Evrensel.kayit_dosyasi.save_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"])


func _on_Refresh_pressed():
#	get_parent().get_node("Ust/YatayBolucuUst/IkinciBolum/ButonBar/Bildirim").texture_normal = load ("res://resimler/bildirim.webp")
	var bildirim_sahnesi = load(Evrensel.veriler["bildirim_sahnesi"]).instance()
	get_parent().add_child(bildirim_sahnesi)
	get_parent().move_child(bildirim_sahnesi,1)	
	queue_free()
