extends Control


var sirali_metinler = []

var acilis_metni = "Gallant and Divine shouldn't come alive without contributions of those\n\n"
var opengameart = "Artists From opengameart.com:\n\nAlexandr Zhelanov:Game Musics\n" \
					+ "dog-eared:Background Images\n" + "Angelee:Box Images\n" \
					+ "p0ss:Background Images\n" + "kindland:Background Images\n" \
					+ "Felis Chaus:Background Images\n" + "kebinite:Possession Frames\n" \
					+ "StumpyStrust: UI Buttons\n" + "Matthew Pablo:Game Musics\n" \
					+ "qubodup:Monster Growls" 
					
var pixabay = "Artists From pixabay.com:\n\nSilviaP_Design:Creature Images\n" \
				+ "pendleburyannette:Creature Images\n" + "V_M:Pantheon Images\n" \
				+ "Parker_West:Creature Images\n"
				
var dilda_canakci = "A great, ambitious and stubborn visual arts student:\n\nDilda Canakci:God Drawings"

var karicigim = "The best hearted, a tiny creation of God's beauty, my dear wife:\n\nKubra Ozen: Being always with me!"

var cikis_metni = "A thousand thanks to all of you..."					

onready var rich_label = $RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	sirali_metinler.append(acilis_metni)
	sirali_metinler.append(opengameart)
	sirali_metinler.append(pixabay)
	sirali_metinler.append(dilda_canakci)
	sirali_metinler.append(karicigim)
	sirali_metinler.append(cikis_metni)
	rich_label.text = sirali_metinler.pop_front()
	$metin_degistirici.interpolate_property(rich_label, "percent_visible", 0 , 1, len(rich_label.text)/15,  Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$metin_degistirici.start()


func _on_metin_degistirici_tween_all_completed():
	yield(get_tree().create_timer(0.5), "timeout")
	var siradaki_metin = sirali_metinler.pop_front()
	if siradaki_metin:
		rich_label.text = siradaki_metin
		rich_label.percent_visible = 0
		$metin_degistirici.interpolate_property(rich_label, "percent_visible", 0 , 1, len(rich_label.text)/15,  Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$metin_degistirici.start()
	else:
		yield(get_tree().create_timer(0.5), "timeout")
		queue_free()


func _on_TextureButton_pressed():
	queue_free()
