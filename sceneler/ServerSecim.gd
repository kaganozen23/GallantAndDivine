extends TextureRect

var kayitli_tanrilar = {}	#evren_id:tanri_id eşleşmesini tutacak dict
signal oyuncu_ismi
onready var oyuncu_ismi_sahnesi = load(Evrensel.veriler["oyuncu_ismi_sahnesi"]).instance()

func _ready():
	get_tree().current_scene = self
	$ServerSecimKutusu/ScrollContainer/VBoxContainer/Server.visible = false
#	Evrensel.veriler.yielded = evrenleri_doldur()
	if Evrensel.veriler["oyuncu"].nick == "None":
		add_child(oyuncu_ismi_sahnesi)
	else:
		emit_signal("oyuncu_ismi")

	
func evrenleri_doldur():
	Evrensel.yukleniyor_goster()
	Evrensel.karsiya_gonder("3")	#tüm evrenleri al
	yield()
	Evrensel.karsiya_gonder("4,%s" % Evrensel.veriler["oyuncu"].id) 	#oyuncu id'sini kayitli tanrilari al
	yield()
	Evrensel.yukleniyor_kaybet()
	for evren in Evrensel.veriler["tum_evrenler"]:
		var evren_kapali_texture = preload("res://resimler/server_kapali.webp")
		var new_node = $ServerSecimKutusu/ScrollContainer/VBoxContainer/Server.duplicate()
		new_node.get_node("HBoxContainer/VBoxContainer/adi").text = evren.adi
		new_node.get_node("HBoxContainer/VBoxContainer/hikayesi").text = evren.hikayesi
		new_node.get_node("HBoxContainer/tanrisi").text = "(-)"
		if Evrensel.veriler["oyuncu_tanrilari"].size() > 0:
			for tanri in Evrensel.veriler["oyuncu_tanrilari"]:	#oyuncu_tanrilari alinmisti,
				if tanri.evren_id == evren.id:	#o evren id'sine sahip oyuncu tanrisi varsa
					kayitli_tanrilar[evren.id] = tanri.id
					new_node.get_node("HBoxContainer/tanrisi").text = "(+)"
					break
		new_node.name = evren.id
		new_node.visible=true
		new_node.connect("pressed",self,"_on_Server_pressed",[new_node,evren])
		if evren.acik_mi == "False":
			new_node.get_node("HBoxContainer/CenterContainer/ServerDurumu").texture = evren_kapali_texture	
		$ServerSecimKutusu/ScrollContainer/VBoxContainer.call_deferred("add_child",new_node)
	$ServerSecimKutusu/ScrollContainer/VBoxContainer/Server.queue_free()
#	Evrensel.veriler["yielded"] = null
	
func _on_GeriButon_pressed():
	Evrensel.sahne_degistir(get_tree().get_current_scene(),Evrensel.veriler["giris_sahnesi"])


func _on_Server_pressed(buton,evren):
	if evren.acik_mi == "False":
		var server_miti = load(Evrensel.veriler["server_miti_sahnesi"]).instance()
		server_miti.baslat(buton.name)
		call_deferred("add_child",server_miti)
		return
	if kayitli_tanrilar:
		if buton.name in kayitli_tanrilar:
			Evrensel.karsiya_gonder("995,%s" % kayitli_tanrilar[buton.name])
	Evrensel.tiklama_efekti(buton)
	Evrensel.veriler["oyuncu_evreni_id"] = buton.name
	match buton.get_node("HBoxContainer/tanrisi").text:
		"(+)":
			Evrensel.veriler["oyuncu_tanrisi_id"] = kayitli_tanrilar[buton.name]
			Evrensel.sahne_degistir(get_tree().get_current_scene(),Evrensel.veriler["ana_oyun_sahnesi"])
		"(-)":
			Evrensel.sahne_degistir(get_tree().get_current_scene(),Evrensel.veriler["tanri_secim_sahnesi"])




func _on_Arkaplan_oyuncu_ismi():
	if is_a_parent_of(oyuncu_ismi_sahnesi):
		oyuncu_ismi_sahnesi.queue_free()
	Evrensel.veriler["yielded"] = evrenleri_doldur()
