extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var delta_sayac = 0
var kazandi = false

func baslat(k,ben,rakip_tanri,gucler_dizisi):
	kazandi = k
	$TextureRect/TanriBen.texture = ben.tanri_texture_buyuk
	$TextureRect/TanriRakip.texture = rakip_tanri.tanri_texture_buyuk
	if kazandi:
		$ColorRect/Label.text = "Congratulations! You have defeated God %s, gained 1 percent of opponents powers. Which are;\n " % rakip_tanri.isim\
								+ "warfare power: %s, calamity power: %s, fortune power: %s, divine power: %s, chaos power: %s, " % [gucler_dizisi[0],gucler_dizisi[1],gucler_dizisi[2],gucler_dizisi[3],gucler_dizisi[4]]\
								+ "renaissance power %s" % gucler_dizisi[5]
	else:
		$ColorRect/Label.text = "Bad Luck! You have been defeated by God %s, lost 1 percent of your powers. Which are;\n " % rakip_tanri.isim\
								+ "warfare power: %s, calamity power: %s, fortune power: %s, divine power: %s, chaos power: %s, " % [gucler_dizisi[0],gucler_dizisi[1],gucler_dizisi[2],gucler_dizisi[3],gucler_dizisi[4]]\
								+ "renaissance power %s" % gucler_dizisi[5]

func _ready():
	$TextureRect/TanriBen/IlkSaldiri.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	delta_sayac += delta
	if delta_sayac > 5 and delta_sayac < 10:
		$TextureRect/Simsek.emitting = false
		$TextureRect/TanriBen/IlkSaldiri.emitting = false
		$TextureRect/TanriRakip/IkinciSaldiri.emitting = true
	if delta_sayac > 10 and delta_sayac<15:
		$TextureRect/TanriRakip/IkinciSaldiri.emitting = false
		$ColorRect.visible = true
		if kazandi:
			Evrensel.efekt_ver("res://sesler/savas_kazanma.ogg")
			$TextureRect/baslik.text = "VICTORIOUS!"
			$TextureRect/TanriRakip.hide()
#			$TextureRect/TanriBen.margin_bottom = 0.5
#			$TextureRect/TanriBen.margin_top = 0.5
#			$TextureRect/TanriBen.margin_left = 0.5
#			$TextureRect/TanriBen.margin_right = 0.5
			var tween2 = Tween.new()
			add_child(tween2)
			tween2.connect("tween_all_completed",self,"_on_tween2_completed")
			tween2.interpolate_property($TextureRect/TanriBen, "rect_scale", 
			Vector2(1, 1), Vector2(1.8, 1.8), 7, 
			Tween.TRANS_QUAD, Tween.EASE_OUT)
			tween2.start()
		else:
			Evrensel.efekt_ver("res://sesler/savas_kaybetme.ogg")
			$TextureRect/baslik.text = "DEFEATED!"
			$TextureRect/TanriBen.hide()
#			$TextureRect/TanriRakip.margin_bottom = 0.5
#			$TextureRect/TanriRakip.margin_top = 0.5
			$TextureRect/TanriRakip.rect_position = $TextureRect/TanriBen.rect_position
			$TextureRect/TanriRakip.flip_h = true
#			$TextureRect/TanriRakip.margin_right = 0.5
			var tween2 = Tween.new()
			add_child(tween2)
			tween2.connect("tween_all_completed",self,"_on_tween2_completed")
			tween2.interpolate_property($TextureRect/TanriRakip, "rect_scale", 
			Vector2(1, 1), Vector2(1.8, 1.8), 7, 
			Tween.TRANS_QUAD, Tween.EASE_OUT)
			tween2.start()	
		set_process(false)

		
func _on_tween2_completed():
	$TextureRect/EmmeSonrasi.emitting = true
	var t = Timer.new()
	add_child(t)
	t.wait_time = 1.8
	t.connect("timeout",self,"_bitir")
	t.start()

func _bitir():
	get_tree().get_current_scene().get_node("Ana/DikeyBolucu/Alt/YatayBolucu/DikeyBolucuUSt/Titanomahia").emit_signal("pressed")
