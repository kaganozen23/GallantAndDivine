extends Node

var id
var oyuncu_id
var evren_id
var birlik_id
var chat_odasi_id= null
var tanri_tipi
var savas_yetenegi
var felaket_yetenegi
var ekonomi_yetenegi
var kaos_yetenegi
var ilahi_yetenegi
var ronesans_yetenegi
var piramit_asamasi
var mevcut_emir_hakki = 1
var mevcut_yaratik_savasi_hakki = 1
var mevcut_tanri_savasi_hakki =1
var isim = null
var tanri_texture_buyuk = null
var tanri_texture_kucuk = null
var rakip_oyuncu_isim = null	#titanomakhia tanrisi da bu siniftan tureyecek

const nitelik_sayisi = 17

func _init(tanri_dizisi):
	id = tanri_dizisi[0]
	oyuncu_id= tanri_dizisi[1]
	evren_id = tanri_dizisi[2]
	birlik_id = tanri_dizisi[3]
	chat_odasi_id = tanri_dizisi[4]
	tanri_tipi = tanri_dizisi[5]
	savas_yetenegi = tanri_dizisi[6]
	felaket_yetenegi = tanri_dizisi[7]
	ekonomi_yetenegi = tanri_dizisi[8]
	kaos_yetenegi = tanri_dizisi[9]
	ilahi_yetenegi = tanri_dizisi[10]
	ronesans_yetenegi = tanri_dizisi[11]
	piramit_asamasi = tanri_dizisi[12]
	mevcut_emir_hakki = tanri_dizisi[13]
	mevcut_yaratik_savasi_hakki = tanri_dizisi[14]
	mevcut_tanri_savasi_hakki = tanri_dizisi[15]
	if (tanri_dizisi.size() > 16):
		isim = tanri_dizisi[16]
		tanri_texture_buyuk	= load ("res://resimler/tanrilar/buyuk/%s_290_470.webp" % isim)
		tanri_texture_kucuk = load("res://resimler/tanrilar/portre/%s_portre_130_130.webp" % isim)
	if (tanri_dizisi.size() > 17):
		rakip_oyuncu_isim = tanri_dizisi[17]
	

