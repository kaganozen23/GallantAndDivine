extends Control


var metin ="" 
			 
			
onready var rich_label = $RichTextLabel

func baslat(evren_id):
	Evrensel.muzik_degistir("res://sesler/Myth.ogg")
	Evrensel.veriler.yielded = mit_bilgilerini_al_yaz(evren_id)
	
func mit_bilgilerini_al_yaz(evren_id):
	Evrensel.yukleniyor_goster()
	Evrensel.karsiya_gonder("58,%s" % evren_id)
	yield()
	Evrensel.yukleniyor_kaybet()
	if Evrensel.veriler["server_miti"]:
		if(len(Evrensel.veriler["server_miti"])==18):
			metin= "Many Gods Shaped This Universe' Myth: \n\n" +\
			"The most commanding: %s\n" % Evrensel.veriler["server_miti"][1]+\
			"Titanomahia conqueror: %s\n" % Evrensel.veriler["server_miti"][2]+\
			"The banisher: %s\n" % Evrensel.veriler["server_miti"][3]+\
			"Time Chaser: %s\n" % Evrensel.veriler["server_miti"][4]+\
			"Vanquisher of Aliens: %s\n" %Evrensel.veriler["server_miti"][5] +\
			"Undefeatable: %s\n" % Evrensel.veriler["server_miti"][6]+\
			"Possessor of Possessions: %s\n" % Evrensel.veriler["server_miti"][7] +\
			"Thrifty Possessor: %s\n" % Evrensel.veriler["server_miti"][8]+\
			"Divine Pathfinder: %s\n" %Evrensel.veriler["server_miti"][9] +\
			"Powers Beyond Universe: %s\n" % Evrensel.veriler["server_miti"][10] +\
			"Roman Apostle: %s\n" % Evrensel.veriler["server_miti"][11] +\
			"Sumerian Apostle: %s\n" % Evrensel.veriler["server_miti"][12] +\
			"Egyptian Apostle: %s\n" % Evrensel.veriler["server_miti"][13] +\
			"Greek Apostle: %s\n" % Evrensel.veriler["server_miti"][14] +\
			"Scandinavian Apostle: %s\n" % Evrensel.veriler["server_miti"][15] +\
			"The Ascendant: %s\n\n" % Evrensel.veriler["server_miti"][16] +\
			"After all, %s stars survived apocalypse" % Evrensel.veriler["server_miti"][17]+\
			 " and eventually %s Gods achieved victory!" % ("Virtuous" if int(Evrensel.veriler["server_miti"][17])>0 else "Evil")
			rich_label.text = metin
			$metin_degistirici.interpolate_property(rich_label, "percent_visible", 0 , 1, len(rich_label.text)/15,  Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$metin_degistirici.start()
	

func _on_metin_degistirici_tween_all_completed():
	yield(get_tree().create_timer(1.5), "timeout")
	queue_free()

func _on_TextureButton_pressed():
	queue_free()
