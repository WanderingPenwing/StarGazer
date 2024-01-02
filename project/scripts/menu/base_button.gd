extends CenterContainer

@onready var SoundManager : Node = get_node("/root/SoundsManager")
@onready var Gamestate : Node = get_node("/root/GameState")

@export var button_title : String
@export var custom_size : float = 250
@export var next : Node
@export var previous : Node

const bip : Resource = preload("res://assets/sounds/sfx/menu/bip.wav")
const boop : Resource = preload("res://assets/sounds/sfx/menu/select.wav")
const UNACTIVE_TIME : float = 0.1
const DEFAULT_SCALE : Vector2 = Vector2(1.0, 1.0)
const HOVER_SCALE : Vector2 = Vector2(1.2, 1.2)
const ANIMATION_TIME : float = 0.1

signal activate(name)

var selected : bool = false
var disabled : bool = false
var time_since_selected : float = 0.0


func _ready() -> void :
	if disabled :
		modulate = Color.DIM_GRAY
		$Button.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _process(delta) -> void:
	if not next :
		var next_button : int = (get_index() + 1) % get_parent().get_child_count()
		next = get_parent().get_child(next_button)
	
	if not previous :
		var previous_button : int = (get_index() - 1) % get_parent().get_child_count()
		previous = get_parent().get_child(previous_button)

	$Button.custom_minimum_size.x = custom_size
	$Button.text = "  " + button_title + "  "
	
	if not(visible) :
		return
		
	if not(selected) :
		return
	
	if time_since_selected < UNACTIVE_TIME :
		time_since_selected += delta
		return
	
	if Input.is_action_just_pressed("ui_accept") :
		activate.emit(button_title)
		SoundManager.play_sound(bip, SoundManager, "Sfx")
		var tween : Tween = create_tween() # Creates a new tween
		tween.tween_property(self, "scale", DEFAULT_SCALE, ANIMATION_TIME)
		tween.tween_property(self, "scale", HOVER_SCALE, ANIMATION_TIME)
		return
		
	if Input.is_action_just_pressed("ui_down") :
		become_unselected()
		next.become_selected()
			
	if Input.is_action_just_pressed("ui_up") :
		become_unselected()
		previous.become_selected()



func become_selected(mute : bool = false) :
	if selected :
		return
	if disabled :
		next.become_selected()
		return
	if not mute :
		SoundManager.play_sound(boop, SoundManager, "Sfx")
	selected = true
	time_since_selected = 0.0
	var tween : Tween = create_tween() # Creates a new tween
	tween.tween_property(self, "scale", HOVER_SCALE, ANIMATION_TIME)



func become_unselected() :
	if not(selected) :
		return
	selected = false
	var tween : Tween = create_tween() # Creates a new tween
	tween.tween_property(self, "scale", DEFAULT_SCALE, ANIMATION_TIME)



func _on_button_pressed() -> void:
	if disabled :
		return
	activate.emit(button_title)
	SoundManager.play_sound(bip, SoundManager, "Sfx")
	var tween : Tween = create_tween() # Creates a new tween
	tween.tween_property(self, "scale", DEFAULT_SCALE, ANIMATION_TIME)
	tween.tween_property(self, "scale", HOVER_SCALE, ANIMATION_TIME)



func _on_button_mouse_entered():
	if disabled :
		return
	become_selected()
	for button in get_tree().get_nodes_in_group("button") :
		if button != self :
			button.become_unselected()
