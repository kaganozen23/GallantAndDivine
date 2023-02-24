extends Node

var id
var galaksi_id
var yaratiklari = []
const nitelik_sayisi = 3

func _init(yaratik_dizisi):
	id = yaratik_dizisi[0]
	galaksi_id = yaratik_dizisi[1]
	var i = 2
	while i < len(yaratik_dizisi):
		var gecici = {"yaratik_tipi":yaratik_dizisi[i],"yaratik_miktari":yaratik_dizisi[i+1]}
		yaratiklari.append(gecici)
		i += 2
