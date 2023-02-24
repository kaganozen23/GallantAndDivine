extends Node

var id
var isim
var degeri
var suresi
var ozeti
var tipi
var ne_ise_yaradigi
var cerceve_texture
var kendi_texture
const nitelik_sayisi = 7

func _init(ana_esya_dizisi):
	var i = 0
	while i< ana_esya_dizisi.size():
		if ana_esya_dizisi[i].count(" ") > 0:	#ilk karakterde bosluk yok o nedenle sikinti cikardi boyle cozduk
			ana_esya_dizisi[i] = ana_esya_dizisi[i].right(1)
		i+=1
	id = ana_esya_dizisi[0]
	isim = ana_esya_dizisi[1]
	degeri = ana_esya_dizisi[2]
	suresi = ana_esya_dizisi[3]
	ozeti = ana_esya_dizisi[4]
	tipi = ana_esya_dizisi[5]
	ne_ise_yaradigi = ana_esya_dizisi[6]
	kendi_texture = load ("res://resimler/esyalar/%s.webp" % isim)
	cerceve_texture = load ("res://resimler/esyalar/cerceveler/%s.webp" % degeri)
