extends Node

var tanri_id
var bildirim_tipi
var bildirim
var bildirim_section
var bildirim_key = String(OS.get_system_time_msecs())

func _init(bildirim_dizisi):
	tanri_id = bildirim_dizisi[0]
	bildirim_tipi = bildirim_dizisi[1].replacen(" ","")
	bildirim = bildirim_dizisi[2]
	bildirim_section = "bildirim" + tanri_id
	kayit_dosyasina_yaz()
	bildirim_geldi_bilgilendirme()
	

func kayit_dosyasina_yaz():
	if Evrensel.kayit_dosyasi.load_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"]) == OK:
		Evrensel.kayit_dosyasi.set_value(bildirim_section,bildirim_key,String(bildirim_tipi) +","+bildirim + "\nTOR: " + String(Evrensel.veriler["evren_zamani"]))
		Evrensel.kayit_dosyasi.save_encrypted_pass(Evrensel.veriler["kayit_dosya_yolu"],Evrensel.veriler["kayit_dosya_sifresi"])

func bildirim_geldi_bilgilendirme():
	Evrensel.veriler["bildirim_bayragi"] = true
	Evrensel.efekt_ver("res://sesler/bildirim.ogg")
