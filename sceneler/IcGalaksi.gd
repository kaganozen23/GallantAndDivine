extends Control

var GalaksiBilgileri
var yeni_yildiz

func baslat(Galaksi):
	GalaksiBilgileri = Galaksi

func _ready():
	Evrensel.veriler["galaksi_yildizlari"] = []
	yeni_yildiz = $Arkaplan/ScrollContainer/YildizlarGrid/Halka.duplicate()
	$Arkaplan/GalaksiIsmi.text = GalaksiBilgileri.isim
	$Arkaplan/ScrollContainer/YildizlarGrid/Halka.queue_free()
	Evrensel.veriler.yielded = yildiz_bilgilerini_al()
#	yeni_yaratik.get_node("Ismi").queue_free()
	

func yildiz_bilgilerini_al():
	Evrensel.yukleniyor_goster()
	Evrensel.karsiya_gonder("9" + ',' + str(GalaksiBilgileri.id))	#galaksideki yildizlari al
	Evrensel.karsiya_gonder("18,"+Evrensel.veriler["oyuncu_tanrisi_id"])
	Evrensel.karsiya_gonder("97,%s" % str(GalaksiBilgileri.id))	#banshees silver comb bilgisini al
	yield()
	yield()
	yield()
	yildizlari_olustur()
	Evrensel.yukleniyor_kaybet()
		
func yildizlari_olustur():
	for yildiz in Evrensel.veriler["galaksi_yildizlari"]:
		var yildiz_texture = load ("res://resimler/yildizlar/yildiz%s.webp" % str(int(yildiz.adi) % 16) )
		var eklenecek_yildiz = yeni_yildiz.duplicate()
		eklenecek_yildiz.modulate = Color(1,1,1,0)
		var tween= Tween.new()
		add_child(tween)
		eklenecek_yildiz.get_node("Yildiz/Ismi").text = yildiz.adi
		eklenecek_yildiz.get_node("Yildiz").texture_normal = yildiz_texture
		$Arkaplan/ScrollContainer/YildizlarGrid.add_child(eklenecek_yildiz)
		for emir in Evrensel.veriler["tum_tanri_emirleri"]:
			if emir[0] == yildiz.id:
				var emir_resmi = null
				match emir[1]:
					'1':
						emir_resmi = load ("res://resimler/emir_resimleri/Calamity.webp")
					'2':
						emir_resmi = load ("res://resimler/emir_resimleri/War.webp")
					'3':
						emir_resmi = load("res://resimler/emir_resimleri/Epidemic.webp")
					'4':
						emir_resmi = load("res://resimler/emir_resimleri/Crisis.webp")
					'5':
						emir_resmi = load("res://resimler/emir_resimleri/Sorcery.webp")
					'6':
						emir_resmi = load ("res://resimler/emir_resimleri/Proliferate.webp")
					'7':
						emir_resmi = load ("res://resimler/emir_resimleri/Agriculture.webp")
					'8':
						emir_resmi = load ("res://resimler/emir_resimleri/Order.webp")
					'9':
						emir_resmi = load ("res://resimler/emir_resimleri/Renaissance.webp")
					'10':
						emir_resmi = load ("res://resimler/emir_resimleri/Invocation.webp")
				if emir_resmi:
					eklenecek_yildiz.get_node("Yildiz/EmirResmi").texture = emir_resmi
		tween.interpolate_property(eklenecek_yildiz, "modulate", 
		Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.3, 
		Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()
		halka_duzenle(eklenecek_yildiz,yildiz.uzayli_yuzdesi,yildiz.iyilik_yuzdesi)
		eklenecek_yildiz.get_node("Yildiz").connect("pressed",self,"_on_yildiz_pressed",[eklenecek_yildiz.get_node("Yildiz")])


func halka_duzenle(eklenecek_yildiz,uzayli_yuzdesi,iyilik_yuzdesi):
	eklenecek_yildiz.self_modulate = Color (1,1,1,0)
	var tween2= Tween.new()
	add_child(tween2)
	uzayli_yuzdesi = int(uzayli_yuzdesi)
	iyilik_yuzdesi = int(iyilik_yuzdesi)
	if int(uzayli_yuzdesi) > 0:
		tween2.interpolate_property(eklenecek_yildiz, "self_modulate", 
		Color(1, 1, 1, 0), Color(0, 0, 0, 1), 0.3, 
		Tween.TRANS_QUAD, Tween.EASE_OUT)
	else:
		if Evrensel.veriler.halkasiz_galaksi != "None":
			print(Evrensel.veriler.halkasiz_galaksi)
			eklenecek_yildiz.self_modulate = Color (1,1,1,0)
		elif iyilik_yuzdesi > 50:
#			eklenecek_yildiz.self_modulate = Color(1,iyilik_yuzdesi,1)
			tween2.interpolate_property(eklenecek_yildiz, "self_modulate", 
			Color(1, 1, 1, 0), Color(0,float(iyilik_yuzdesi)/100,0,1), 0.3, 
			Tween.TRANS_QUAD, Tween.EASE_OUT)
		elif iyilik_yuzdesi < 50:
			tween2.interpolate_property(eklenecek_yildiz, "self_modulate", 
			Color(1, 1, 1, 0), Color(float(100-iyilik_yuzdesi)/100,0,0,1), 0.3, 
			Tween.TRANS_QUAD, Tween.EASE_OUT)
	#		eklenecek_yildiz.self_modulate = Color(iyilik_yuzdesi,1,1)
		else:
			eklenecek_yildiz.self_modulate = Color (1,1,1,1)
	tween2.start()
	
func _on_yildiz_pressed(yildiz):
	var tween = Tween.new()
	add_child(tween)
	tween.connect("tween_all_completed",self,"_on_tween_completed",[yildiz])
	for y in $Arkaplan/ScrollContainer/YildizlarGrid.get_children():
		y.get_node("Yildiz").disconnect("pressed",self,"_on_yildiz_pressed")
		if y.get_node("Yildiz/Ismi").text != yildiz.get_node("Ismi").text:
#			y.get_parent().queue_free()
			tween.interpolate_property(y, "modulate", 
			Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.3, 
			Tween.TRANS_QUAD, Tween.EASE_OUT)
			tween.start()
			
func _on_tween_completed(yildiz):
	var yildizbilgileri = load (Evrensel.veriler["yildiz_bilgileri_sahnesi"]).instance()
	var SecilmisYildiz
	for y in Evrensel.veriler["galaksi_yildizlari"]:
		if y.adi == yildiz.get_node("Ismi").text:
			SecilmisYildiz = y
	yildizbilgileri.baslat(GalaksiBilgileri,yildiz,SecilmisYildiz)
	get_parent().add_child(yildizbilgileri)
	get_parent().move_child(yildizbilgileri,1)
	queue_free()

func _on_TextureButton_pressed():
	Evrensel.veriler["galaksi_yildizlari"] = []
	var galaksi = load(Evrensel.veriler["galaksi_sahnesi"]).instance()
	get_parent().get_child(1).queue_free()
	get_parent().add_child(galaksi)
	get_parent().move_child(galaksi,1)
	queue_free()


func _on_Yildizlar_pressed():
	$Arkaplan/Yaratiklar.pressed = false
	$Arkaplan/Yildizlar.pressed = true
	var IcGalaksi = load(Evrensel.veriler["ic_galaksi_sahnesi"]).instance()
	IcGalaksi.baslat(GalaksiBilgileri)	#verileri yeni sahnenin baslat fonk. yolla
	get_parent().add_child(IcGalaksi)
	get_parent().move_child(IcGalaksi,1)
	queue_free()
		

func _on_Yaratiklar_pressed():
	$Arkaplan/Yildizlar.pressed = false
	$Arkaplan/Yaratiklar.pressed = true
	yildizlari_kaybet()


func yildizlari_kaybet():
	var tween2 = Tween.new()
	add_child(tween2)
	tween2.connect("tween_all_completed",self,"_on_tween2_completed")
	for y in $Arkaplan/ScrollContainer/YildizlarGrid.get_children():
		y.get_node("Yildiz").disconnect("pressed",self,"_on_yildiz_pressed")
		tween2.interpolate_property(y, "modulate", 
		Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.3, 
		Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween2.start()

func _on_tween2_completed():
	var Yaratik = load(Evrensel.veriler["yaratik_sahnesi"]).instance()
	Yaratik.baslat(GalaksiBilgileri)	#verileri yeni sahnenin baslat fonk. yolla
	get_parent().add_child(Yaratik)
	get_parent().move_child(Yaratik,1)
	queue_free()
