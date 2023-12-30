extends VBoxContainer

@onready var Transition : Node = get_node("/root/SceneTransition")

var options : Resource = load("res://scenes/options.tscn")

#altF + shift + F => fold ; meta + shift + F => unfold

func _ready() -> void :
	$Start.become_selected(true)


func _on_start_activate(_name) -> void :
	pass # Replace with function body.



func _on_options_activate(_name) -> void :
	Transition.change_to_scene(options)



func _on_credits_activate(_name) -> void :
	pass # Replace with function body.



func _on_quit_activate(_name) -> void :
	get_tree().quit()
