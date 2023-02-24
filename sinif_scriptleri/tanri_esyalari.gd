extends Node

var tanri_id
var esya_id
var miktar
var kalan_suresi
const nitelik_sayisi = 4

func _init(esya_dizisi):
	tanri_id = esya_dizisi[0]
	esya_id = esya_dizisi[1]
	miktar = esya_dizisi[2]
	kalan_suresi = esya_dizisi[3]
