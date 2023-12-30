extends HBoxContainer

@onready var Gamestate : Node = get_node("/root/GameState")
@onready var Transition = get_node("/root/SceneTransition")

const INCREMENT : int = 5

var main_menu : Resource = load("res://scenes/start_screen.tscn")



func _ready():
	$MasterIncrease/Button.custom_minimum_size.x = 0.0
	$MasterDecrease/Button.custom_minimum_size.x = 0.0
	$MasterDecrease.become_selected(true)
	set_label(Gamestate.master_sound)
	$'../Sfx'.set_label(Gamestate.sfx)
	$'../Music'.set_label(Gamestate.music)

 

func set_label(sound : int) -> void :   
	$MasterLevel.text = str(sound)
	Gamestate.update_volume()



func _on_main_menu_activate(_name) -> void :
	Gamestate.save_state()
	Transition.change_to_scene(main_menu)
	


func _on_master_decrease_activate(_name) -> void :
	Gamestate.master_sound = max(0, Gamestate.master_sound - INCREMENT)
	set_label(Gamestate.master_sound)



func _on_master_increase_activate(_name) -> void :
	Gamestate.master_sound = min(100, Gamestate.master_sound + INCREMENT)
	set_label(Gamestate.master_sound)



func _on_sfx_decrease_activate(_name) -> void :
	Gamestate.sfx = max(0, Gamestate.sfx - INCREMENT)
	$'../Sfx'.set_label(Gamestate.sfx)



func _on_sfx_increase_activate(_name) -> void :
	Gamestate.sfx = min(100, Gamestate.sfx + INCREMENT)
	$'../Sfx'.set_label(Gamestate.sfx)



func _on_music_decrease_activate(_name) -> void :
	Gamestate.music = max(0, Gamestate.music - INCREMENT)
	$'../Music'.set_label(Gamestate.music)



func _on_music_increase_activate(_name) -> void :
	Gamestate.music = min(100, Gamestate.music + INCREMENT)
	$'../Music'.set_label(Gamestate.music)
