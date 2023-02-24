extends Node

#bu script verilen esya ile ilgili tum islemlerle ilgilenir
#artik esya kullan emri verilmistir.
#o andan itibaren olacaklarla ilgilenir.

var curr_scene = null

func _init(cs):
	curr_scene = cs

func esya_kullan(esya=null,galaksi=null,yildiz=null):
	if (yildiz):
		for g in Evrensel.veriler["evren_galaksileri"]:
			if g.id == yildiz.galaksi_id:
				galaksi = g
	if esya:
		match esya.id:
			"1":	#manafs sphere
				if not yildiz:
					return
				Evrensel.karsiya_gonder("31,%s,%s" % [Evrensel.veriler["oyuncu_tanrisi_id"],yildiz.id])
				Evrensel.yukleniyor_goster()
#				ic_galaksiye_don(galaksi)
			"2":	#mistletoe
				if not int(yildiz.uzayli_yuzdesi) > 0:
					var PopupGenel = load(Evrensel.veriler["popup_genel_sahnesi"]).instance()
					PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = ("Unable to Use!").to_upper()
					PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Star %s hasn't been invaded by aliens yet!" % yildiz.adi
					curr_scene.add_child(PopupGenel)
					PopupGenel.popup_centered()
				else:
					Evrensel.karsiya_gonder("33,%s,%s,%s,%s,%s" % [yildiz.id,Evrensel.veriler["oyuncu"].nick,Evrensel.veriler["oyuncu_tanrisi"].isim,yildiz.adi,Evrensel.veriler["oyuncu_tanrisi"].id])
					Evrensel.Bildirim_Sinifi.new([ Evrensel.veriler["oyuncu_tanrisi_id"], "12", ("You have used Mistletoe on %s. Humankind won't forget your efforts!" % yildiz.adi) ])
#					Evrensel.yukleniyor_goster()
					ic_galaksiye_don(galaksi)
			"3":	#Cerridwens Cauldron
				Evrensel.karsiya_gonder("34,%s" % Evrensel.veriler["oyuncu_tanrisi"].id)
				Evrensel.yukleniyor_goster()
#				curr_scene.get_node("Ana/DikeyBolucu/Alt/YatayBolucu/DikeyBolucuUSt/Galaksi").emit_signal("pressed")
				#esya sahnesi popup olarak gelmemisse ana esya sahnesidir. Burada refresh edilecek
			"4":	#Amulet of Tatula
				Evrensel.karsiya_gonder("35,%s" % Evrensel.veriler["oyuncu_tanrisi"].id)
				Evrensel.yukleniyor_goster()
#				if curr_scene.get_node("Ana/DikeyBolucu").get_child(1).get_name() == "Ana":
#					curr_scene.get_node("Ana/DikeyBolucu/Alt/YatayBolucu/DikeyBolucuUSt/Galaksi").emit_signal("pressed")
			"5":	#Turtle Egg
				if (Evrensel.veriler["secili_yildiz_cazibe"] != null and int(Evrensel.veriler["secili_yildiz_cazibe"]) < 100):
					Evrensel.karsiya_gonder("37,%s,%s" % [Evrensel.veriler["oyuncu_tanrisi"].id,yildiz.id])
#					Evrensel.yukleniyor_goster()
					Evrensel.Bildirim_Sinifi.new([ Evrensel.veriler["oyuncu_tanrisi_id"], "15", ("You have used Turtle Egg on %s. Your charm upon the living is increased by 1!" % yildiz.adi) ])
#					ic_galaksiye_don(galaksi)
				elif (Evrensel.veriler["secili_yildiz_cazibe"] == null):
					Evrensel.karsiya_gonder("37,%s,%s" % [Evrensel.veriler["oyuncu_tanrisi"].id,yildiz.id])
#					Evrensel.yukleniyor_goster()
					Evrensel.Bildirim_Sinifi.new([ Evrensel.veriler["oyuncu_tanrisi_id"], "15", ("You have used Turtle Egg on %s. Your charm upon the living is increased by 1!" % yildiz.adi) ])
#					ic_galaksiye_don(galaksi)
				elif (int(Evrensel.veriler["secili_yildiz_cazibe"]) >= 100):
					var PopupGenel = load(Evrensel.veriler["popup_genel_sahnesi"]).instance()
					PopupGenel.get_node("Arkaplan/Baslik/Baslik").text = ("Unable to Use!").to_upper()
					PopupGenel.get_node("Arkaplan/Metin/Metin").text = "Your charm on %s is already at maximum!" % yildiz.adi
					curr_scene.add_child(PopupGenel)
					PopupGenel.popup_centered()					
			"6":	#Esoteric Staff
				Evrensel.karsiya_gonder("38,%s,%s,%s,%s,%s" % [Evrensel.veriler["oyuncu_tanrisi"].id,galaksi.id,Evrensel.veriler["oyuncu"].nick,Evrensel.veriler["oyuncu_tanrisi"].isim,galaksi.isim])
				Evrensel.yukleniyor_goster()
			"7":	#Rustems Lion Blood
				Evrensel.karsiya_gonder("39,%s,%s" % [Evrensel.veriler["oyuncu_tanrisi"].id,yildiz.id])
#				Evrensel.yukleniyor_goster()
#				ic_galaksiye_don(galaksi)
			"8":	#Labyrs of Amazon
				Evrensel.karsiya_gonder("40,%s" % Evrensel.veriler["oyuncu_tanrisi"].id)
				Evrensel.yukleniyor_goster()
			"9":	#Amazons Moon Shield
				Evrensel.karsiya_gonder("41,%s,%s,%s" % [Evrensel.veriler["oyuncu_tanrisi"].id,Evrensel.veriler["oyuncu"].nick,Evrensel.veriler["oyuncu_tanrisi"].isim])
				Evrensel.yukleniyor_goster()
			"10":	#Raven Feather
				Evrensel.karsiya_gonder("42,%s" % Evrensel.veriler["oyuncu_tanrisi"].id)
				Evrensel.yukleniyor_goster()
			"11":	#Skull Charmed Amulet
				Evrensel.karsiya_gonder("43,%s" % Evrensel.veriler["oyuncu_tanrisi"].id)
				Evrensel.yukleniyor_goster()
			"12":	#Yamantakas Whip
				Evrensel.karsiya_gonder("44,%s" % Evrensel.veriler["oyuncu_tanrisi"].id)
				Evrensel.yukleniyor_goster()
			"13":	#Schrimnirs Beef
				Evrensel.karsiya_gonder("45,%s" % Evrensel.veriler["oyuncu_tanrisi"].id)
				Evrensel.yukleniyor_goster()
			"14":	#Schrimnirs Milk
				Evrensel.karsiya_gonder("46,%s" % Evrensel.veriler["oyuncu_tanrisi"].id)
				Evrensel.yukleniyor_goster()
			"15":	#Arrow of Hou Yi
				Evrensel.karsiya_gonder("47,%s" % Evrensel.veriler["oyuncu_tanrisi"].id)
				Evrensel.yukleniyor_goster()
			"16":	#Ankh of Anuketh
				Evrensel.karsiya_gonder("48,%s,%s" % [Evrensel.veriler["oyuncu_tanrisi"].id,yildiz.id])
				Evrensel.yukleniyor_goster()
			"17":	#Tryfing
				Evrensel.karsiya_gonder("49,%s,%s,%s,%s" % [Evrensel.veriler["oyuncu_tanrisi"].id,yildiz.id,Evrensel.veriler["oyuncu"].nick,Evrensel.veriler["oyuncu_tanrisi"].isim] )
				Evrensel.yukleniyor_goster()
			"18":	#Golden Hide
				Evrensel.karsiya_gonder("50,%s,%s,%s" % [Evrensel.veriler["oyuncu_tanrisi"].id,galaksi.id,galaksi.isim])
				Evrensel.yukleniyor_goster()
			"19":	#Lapis Lazuli
				Evrensel.karsiya_gonder("51,%s" % Evrensel.veriler["oyuncu_tanrisi"].id)
				Evrensel.yukleniyor_goster()
			"20":	#Orfeus Lyre
				Evrensel.karsiya_gonder("52,%s" % Evrensel.veriler["oyuncu_tanrisi"].id)
				Evrensel.yukleniyor_goster()
			"21":	#Banshees Silver Comb
				Evrensel.karsiya_gonder("59,%s,%s,%s,%s" % [Evrensel.veriler["oyuncu_tanrisi"].id,galaksi.id,Evrensel.veriler["oyuncu"].nick,Evrensel.veriler["oyuncu_tanrisi"].isim])
				Evrensel.yukleniyor_goster()
			"22":	#Chakana
				Evrensel.karsiya_gonder("60,%s" % Evrensel.veriler["oyuncu_tanrisi"].id)
				Evrensel.yukleniyor_goster()
			"23":	#Ayahuaska
				Evrensel.karsiya_gonder("61,%s" % Evrensel.veriler["oyuncu_tanrisi"].id)
				Evrensel.yukleniyor_goster()
			"24":	#Jingweis Stone
				Evrensel.karsiya_gonder("62,%s" % Evrensel.veriler["oyuncu_tanrisi"].id)
				Evrensel.yukleniyor_goster()
			"25":	#Xiling Silk
				Evrensel.karsiya_gonder("63,%s,%s" % [Evrensel.veriler["oyuncu_tanrisi"].id,Evrensel.veriler["oyuncu_evreni_id"]])
				Evrensel.yukleniyor_goster()
			"26":	#Psykhes Oil Lamp
				Evrensel.karsiya_gonder("64,%s,%s" % [Evrensel.veriler["oyuncu_tanrisi"].id,Evrensel.veriler["oyuncu_evreni_id"]])
				Evrensel.yukleniyor_goster()
			"27":	#Huracans Mirror
				Evrensel.karsiya_gonder("65,%s" % Evrensel.veriler["oyuncu_tanrisi"].id)
				Evrensel.yukleniyor_goster()
			"28":	#Sielulintu
				Evrensel.karsiya_gonder("66,%s,%s" % [Evrensel.veriler["oyuncu_tanrisi"].id,yildiz.id])
				Evrensel.yukleniyor_goster()
			"29":	#Arca
				Evrensel.karsiya_gonder("67,%s" % Evrensel.veriler["oyuncu_tanrisi"].id)
				Evrensel.yukleniyor_goster()
			"30":	#Tjatis Boomerang
				Evrensel.karsiya_gonder("68,%s" % Evrensel.veriler["oyuncu_tanrisi"].id)
				Evrensel.yukleniyor_goster()
			"31":	#Xirang Soil
				Evrensel.karsiya_gonder("69,%s,%s,%s,%s" % [Evrensel.veriler["oyuncu_tanrisi"].id,Evrensel.veriler["oyuncu_evreni_id"],Evrensel.veriler["oyuncu"].nick,Evrensel.veriler["oyuncu_tanrisi"].isim])
				Evrensel.yukleniyor_goster()
			"32":	#Indras Electric Spear
				Evrensel.karsiya_gonder("70,%s,%s" % [Evrensel.veriler["oyuncu_tanrisi"].id,yildiz.id])
				ic_galaksiye_don(galaksi)
			"33":	#Hanumans Tail
				Evrensel.karsiya_gonder("71,%s" % Evrensel.veriler["oyuncu_tanrisi"].id)
				Evrensel.yukleniyor_goster()
			"34":	#Saures Carafe
				Evrensel.karsiya_gonder("72,%s,%s" % [Evrensel.veriler["oyuncu_tanrisi"].id,yildiz.id])
				ic_galaksiye_don(galaksi)
			"35":	#Trizul
				Evrensel.karsiya_gonder("73,%s" % Evrensel.veriler["oyuncu_tanrisi"].id)
				Evrensel.yukleniyor_goster()
#				ic_galaksiye_don(galaksi)
			"36":	#Horus Holy Hearth
				Evrensel.karsiya_gonder("74,%s" % Evrensel.veriler["oyuncu_tanrisi"].id)
				Evrensel.yukleniyor_goster()
			"37":	#Izanagis Spear
				Evrensel.karsiya_gonder("75,%s,%s" % [Evrensel.veriler["oyuncu_tanrisi"].id,yildiz.id])
				ic_galaksiye_don(galaksi)
			"38":	#diorite
				Evrensel.karsiya_gonder("76,%s" % Evrensel.veriler["oyuncu_tanrisi"].id)
				Evrensel.yukleniyor_goster()
			"39":	#Holy Book
				Evrensel.karsiya_gonder("77,%s" % Evrensel.veriler["oyuncu_tanrisi"].id)
				Evrensel.yukleniyor_goster()
			"40":	#Zephyrus Disc
				Evrensel.karsiya_gonder("78,%s" % Evrensel.veriler["oyuncu_tanrisi"].id)
				Evrensel.yukleniyor_goster()
			_:
				print("esyaid hata_esya_kontol script")

	
func ic_galaksiye_don(galaksi):
	var IcGalaksi = load(Evrensel.veriler["ic_galaksi_sahnesi"]).instance()
	IcGalaksi.baslat(galaksi)	#verileri yeni sahnenin baslat fonk. yolla
	curr_scene.get_node("Ana/DikeyBolucu").get_child(1).queue_free()
	curr_scene.get_node("Ana/DikeyBolucu").add_child(IcGalaksi)
	curr_scene.get_node("Ana/DikeyBolucu").move_child(IcGalaksi,1)	
	
func _ready():
	pass # Replace with function body.

