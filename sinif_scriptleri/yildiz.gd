extends Node

var id
var galaksi_id
var nufus
var refah_puani
var bilim_puani
var inanc_puani
var kaynak_puani
var adi
var iyilik_yuzdesi
var uzayli_yuzdesi
var tanri_cazibesi
const nitelik_sayisi = 10

func _init(yildiz_dizisi):
	id = yildiz_dizisi[0]
	galaksi_id = yildiz_dizisi[1]
	nufus = yildiz_dizisi[2]
	refah_puani = yildiz_dizisi[3]
	bilim_puani = yildiz_dizisi[4]
	inanc_puani = yildiz_dizisi[5]
	kaynak_puani = yildiz_dizisi[6]
	adi = yildiz_dizisi[7]
	iyilik_yuzdesi = yildiz_dizisi[8]
	uzayli_yuzdesi = yildiz_dizisi[9]
	if (len(yildiz_dizisi)>10):
		tanri_cazibesi = yildiz_dizisi[10]
