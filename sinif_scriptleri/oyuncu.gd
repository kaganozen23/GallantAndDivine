extends Node

var id
var nick
var email
var sifre
var durum
const nitelik_sayisi = 5

func _init(oyuncu_dizisi):
	id = oyuncu_dizisi[0]
	nick = oyuncu_dizisi[1]
	email = oyuncu_dizisi[2]
	sifre = oyuncu_dizisi[3]
	durum = oyuncu_dizisi[4]

