extends VBoxContainer

var main_menu = load("res://scenes/start_screen.tscn")

@onready var Transition : Node = get_node("/root/SceneTransition")



func _on_resume_activate(_name) -> void :
	get_tree().get_first_node_in_group("pause_menu").hide()
	get_tree().paused = false



func _on_quit_activate(_name) -> void :
	Transition.change_to_scene(main_menu)
