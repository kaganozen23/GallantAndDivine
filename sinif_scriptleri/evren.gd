extends Node

var id
var adi
var zamani
var tanri_kapasitesi
var hikayesi
var acik_mi
var baslangic_zamani
var tufan_zamani
const nitelik_sayisi = 8

func _init(evren_dizisi):
	id = evren_dizisi[0]
	adi = evren_dizisi[1]
	zamani = evren_dizisi[2]
	tanri_kapasitesi = evren_dizisi[3]
	hikayesi = evren_dizisi[4]
	acik_mi = evren_dizisi[5]
	baslangic_zamani = evren_dizisi[6]
	tufan_zamani = evren_dizisi[7]
