extends Node

var tanri_id
var gorev_id
var gorev_sarti_sayisi
var suresi
const nitelik_sayisi = 4

func _init(tanri_gorevleri_dizisi):
	tanri_id = tanri_gorevleri_dizisi[0]
	gorev_id = tanri_gorevleri_dizisi[1]
	gorev_sarti_sayisi = tanri_gorevleri_dizisi[2]
	suresi = tanri_gorevleri_dizisi[3]
