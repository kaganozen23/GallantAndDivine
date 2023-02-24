extends Node

var id
var baslik
var aciklama
var zorluk_seviyesi
var gorev_tamamlama_sarti
var suresi
var grubu
const nitelik_sayisi = 7

func _init(gorev_dizisi):
	id = gorev_dizisi[0]
	baslik = gorev_dizisi[1]
	aciklama = gorev_dizisi[2]
	zorluk_seviyesi = gorev_dizisi[3].replace(" ","")
	gorev_tamamlama_sarti = gorev_dizisi[4]
	suresi = gorev_dizisi[5]
	grubu = gorev_dizisi[6]
