extends CanvasLayer

var scene_pack : Resource



func change_to_scene(pack : Resource) -> void :
	if $Animation.is_connected("animation_finished", fade_in) :
		return
	get_tree().paused = true
	$Animation.play("dissolve")
	$Animation.animation_finished.connect(fade_in)
	scene_pack = pack



func fade_in(_anim) -> void :
	if scene_pack :
		get_tree().change_scene_to_packed(scene_pack)
		scene_pack = null
	$Animation.play_backwards("dissolve")
	$Animation.animation_finished.disconnect(fade_in)
	get_tree().paused = false
