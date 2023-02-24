extends ColorRect

var delta_tutucu = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$KumSaati.grab_focus()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$KumSaati.set_rotation($KumSaati.get_rotation()+delta)
	delta_tutucu += delta
	if delta_tutucu > 10:	#timeout
		Evrensel._ready()	#tum evrensel.verileri sifirla
		get_tree().get_current_scene().queue_free()
		var giris_sahnesi = load(Evrensel.veriler["giris_sahnesi"]).instance()
		get_tree().get_root().add_child(giris_sahnesi)
		queue_free()
