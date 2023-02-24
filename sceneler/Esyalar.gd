extends Control

onready var tab_konteyner = $TextureRect/ScrollContainer/TabContainer
onready var all_konteyner = $TextureRect/ScrollContainer/TabContainer/All
onready var self_konteyner = $TextureRect/ScrollContainer/TabContainer/Self
onready var stars_konteyner = $TextureRect/ScrollContainer/TabContainer/Stars
onready var journey_konteyner = $TextureRect/ScrollContainer/TabContainer/Journey
onready var creature_konteyner = $TextureRect/ScrollContainer/TabContainer/Creatures
onready var misc_konteyner = $TextureRect/ScrollContainer/TabContainer/Misc
onready var galaxy_konteyner = $TextureRect/ScrollContainer/TabContainer/Galaxy
var goruntulenecek_tab
var galaksi
var yildiz

func baslat(tablar = "all",sutun_sayisi=4,g = null, y = null):
	if tablar != "all":
		for tab in tab_konteyner.get_children():
			if tab.name != tablar:
				tab.queue_free()
		$MarginContainer/CikisButon.visible = true
	for tab in tab_konteyner.get_children():
		tab.columns = sutun_sayisi
	galaksi = g
	yildiz = y
	
func _ready():
	for child in $TextureRect/ScrollContainer/TabContainer.get_children():
		for mini in child.get_children():
			mini.visible = false
	Evrensel.veriler.yielded = bilgileri_al()

func bilgileri_al():
	Evrensel.yukleniyor_goster()
	if not Evrensel.veriler["ana_esyalar"]:
		Evrensel.karsiya_gonder("24")	#ana esyalari al
		yield()
	Evrensel.karsiya_gonder("25,%s" % Evrensel.veriler["oyuncu_tanrisi_id"])	#oyuncu esyalarini al
	yield()
	Evrensel.yukleniyor_kaybet()
	if not Evrensel.veriler["tanri_esyalari"]:
		$TextureRect/EsyaYokMetin.visible = true
		return
	else:
		for tanri_esya in Evrensel.veriler["tanri_esyalari"]:
			for ana_esya in Evrensel.veriler["ana_esyalar"]:
				if tanri_esya.esya_id == ana_esya.id:	
					var yeni_esya = tab_konteyner.get_child(0).get_child(0).duplicate()
					yeni_esya.get_node("EsyaCerceve/Esya").texture = ana_esya.kendi_texture
					yeni_esya.get_node("EsyaCerceve").texture_normal = ana_esya.cerceve_texture
					yeni_esya.get_node("EsyaCerceve/Miktari").text += String(tanri_esya.miktar)
					yeni_esya.get_node("EsyaCerceve/Saat/KalanSure").text = tanri_esya.kalan_suresi
					yeni_esya.visible = true
					if tab_konteyner.has_node("All"):
						all_konteyner.add_child(yeni_esya.duplicate())
						all_konteyner.get_child(all_konteyner.get_child_count()-1).get_node("EsyaCerceve").connect("pressed",self,"_esyaya_tiklama",[yeni_esya,ana_esya])
					match int(ana_esya.tipi):
						1:	#kendine
							if tab_konteyner.has_node("Self"):
								self_konteyner.add_child(yeni_esya.duplicate())
								self_konteyner.get_child(self_konteyner.get_child_count()-1).get_node("EsyaCerceve").connect("pressed",self,"_esyaya_tiklama",[yeni_esya,ana_esya])
						2:	#yildiza
							if tab_konteyner.has_node("Stars"):
								stars_konteyner.add_child(yeni_esya.duplicate())
								stars_konteyner.get_child(stars_konteyner.get_child_count()-1).get_node("EsyaCerceve").connect("pressed",self,"_esyaya_tiklama",[yeni_esya,ana_esya,null,yildiz])
						3:	#goreve
							if tab_konteyner.has_node("Journey"):
								journey_konteyner.add_child(yeni_esya.duplicate())
								journey_konteyner.get_child(journey_konteyner.get_child_count()-1).get_node("EsyaCerceve").connect("pressed",self,"_esyaya_tiklama",[yeni_esya,ana_esya])
						4:	#yaratiklara
							if tab_konteyner.has_node("Creatures"):
								creature_konteyner.add_child(yeni_esya.duplicate())
								creature_konteyner.get_child(creature_konteyner.get_child_count()-1).get_node("EsyaCerceve").connect("pressed",self,"_esyaya_tiklama",[yeni_esya,ana_esya])
						5:	#biriktirilen
							if tab_konteyner.has_node("Misc"):
								misc_konteyner.add_child(yeni_esya.duplicate())
								misc_konteyner.get_child(misc_konteyner.get_child_count()-1).get_node("EsyaCerceve").connect("pressed",self,"_esyaya_tiklama",[yeni_esya,ana_esya])
						6:	#galaksi
							if tab_konteyner.has_node("Galaxy"):
								galaxy_konteyner.add_child(yeni_esya.duplicate())
								galaxy_konteyner.get_child(galaxy_konteyner.get_child_count()-1).get_node("EsyaCerceve").connect("pressed",self,"_esyaya_tiklama",[yeni_esya,ana_esya,galaksi])

	
func _esyaya_tiklama(yeni_esya,tanri_esya,g=null,y=null):
	var esya_popup = load(Evrensel.veriler["esya_popup_sahnesi"]).instance()
	if g:
		esya_popup.baslat(yeni_esya,tanri_esya,g)
	elif y:
		esya_popup.baslat(yeni_esya,tanri_esya,null,y)
	else:
		esya_popup.baslat(yeni_esya,tanri_esya)
	add_child(esya_popup)
	esya_popup.popup_centered()		

func _on_TabContainer_tab_selected(tab):
	if $TextureRect/EsyaYokMetin.visible == true:
		return
	if $TextureRect/ScrollContainer/TabContainer.get_child(tab).get_child_count() == 0:
		var esya_yok = $TextureRect/EsyaYokMetin.duplicate()
		esya_yok.visible = true
		esya_yok.rect_size = Vector2 (250,205)
		$TextureRect/ScrollContainer/TabContainer.get_child(tab).add_child(esya_yok)

func _on_CikisButon_pressed():
	get_parent().queue_free()
	#popup'in cocugu olarak cagirildiysa popup'i kapatmasi icin
	#normalde bu buton goruntulenebilir degil zaten. Emniyetli

