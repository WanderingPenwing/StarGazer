extends HBoxContainer



func _ready():
	$SfxIncrease/Button.custom_minimum_size.x = 0.0
	$SfxDecrease/Button.custom_minimum_size.x = 0.0



func set_label(sound : int) -> void :
	$SfxLevel.text = str(sound)
	get_node("/root/GameState").update_volume()
