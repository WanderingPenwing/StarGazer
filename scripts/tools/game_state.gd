extends Node

const SAVE_FILE : String = "user://state.save"

var master_sound : int = 50
var sfx : int = 50
var music : int = 50

@onready var master_bus : int = AudioServer.get_bus_index("Master")
@onready var sfx_bus : int = AudioServer.get_bus_index("Sfx")
@onready var music_bus : int = AudioServer.get_bus_index("Music")



func _ready() -> void :
	load_state()
	update_volume()



func save_state() -> void :
	var save_dict := {
		"master_sound" : master_sound,
		"sfx" : sfx,
		"music" : music
	}
	var save_game := FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	var json_string := JSON.stringify(save_dict)
	
	save_game.store_line(json_string)



func load_state() -> void :
	if not FileAccess.file_exists(SAVE_FILE) :
		return
	
	var state_file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	
	while state_file.get_position() < state_file.get_length() :
		var json_string = state_file.get_line()
		var json = JSON.new()
		var _parse_result = json.parse(json_string)
		var state_data = json.get_data()
		
		if not state_data :
			continue
		master_sound = state_data["master_sound"]
		sfx = state_data["sfx"]
		music = state_data["music"]



func update_volume() -> void :
	AudioServer.set_bus_volume_db(master_bus,linear_to_db(master_sound/200.0))
	AudioServer.set_bus_volume_db(sfx_bus,linear_to_db(sfx/100.0))
	AudioServer.set_bus_volume_db(music_bus,linear_to_db(music/100.0))
