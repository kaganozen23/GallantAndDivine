extends Node

var id
var isim
var koken
var hikayesi
var iyi_mi
var savas_yetenegi
var felaket_yetenegi
var ekonomi_yetenegi
var kaos_yetenegi
var ilahi_yetenegi
var ronesans_yetenegi
const nitelik_sayisi = 11

func _init(tanri_dizisi):
	id = tanri_dizisi[0]
	isim = tanri_dizisi[1]
	koken = tanri_dizisi[2]
	hikayesi = tanri_dizisi[3]
	iyi_mi = tanri_dizisi[4]
	savas_yetenegi = tanri_dizisi[5]
	felaket_yetenegi = tanri_dizisi[6]
	ekonomi_yetenegi = tanri_dizisi[7]
	kaos_yetenegi = tanri_dizisi[8]
	ilahi_yetenegi = tanri_dizisi[9]
	ronesans_yetenegi = tanri_dizisi[10]
