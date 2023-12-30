extends HBoxContainer



func _ready():
	$MusicIncrease/Button.custom_minimum_size.x = 0.0
	$MusicDecrease/Button.custom_minimum_size.x = 0.0



func set_label(sound : int) -> void :
	$MusicLevel.text = str(sound)
	get_node("/root/GameState").update_volume()
