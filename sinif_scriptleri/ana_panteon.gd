extends Node

var id
var isim
var bonusu
var tipi
var iyi_mi
const nitelik_sayisi = 5

func _init(panteon_dizisi):
	id = panteon_dizisi[0].replace(" ","")
	isim = panteon_dizisi[1]
	bonusu = panteon_dizisi[2]
	tipi = panteon_dizisi[3].replace(" ","")
	iyi_mi = panteon_dizisi[4].replace(" ","")
