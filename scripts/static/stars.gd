extends Node3D

const STAR_FILE : String = "res://data/bsc5-short.json"
const CONSTELLATIONS_FILE : String = "res://data/constellations.json"
const STAR : Resource = preload("res://prefabs/static/star.tscn")
const RADIUS : float = 40

@export var Infos : Node


func _ready() -> void:
	var Stars = load_stars()
	show_stars(Stars)
	
	var Consts = load_constellations()
	format_constellations(Consts)



func load_stars() -> Array :
	var Stars : Array = []
	
	if not FileAccess.file_exists(STAR_FILE) :
		printerr("Star file does not exits")
		return []
	
	var data_file = FileAccess.open(STAR_FILE, FileAccess.READ)
	
	while data_file.get_position() < data_file.get_length() :
		var json_string = data_file.get_line()
		var json = JSON.new()
		var _parse_result = json.parse(json_string.left(json_string.length() - 1))
		var star_data = json.get_data()
		
		if star_data :
			Stars.append(star_data)
	
	return Stars



func show_stars(Stars : Array) -> void :
	for child in get_children() :
		child.queue_free()
	
	var progress = 0
#
#	for star_data in Stars :
#		progress += 1
#		if progress % 1000 == 0 :
#			print("Loading... ", str(round(100.0*progress/len(Stars))), " %")
#
#		if not star_data :
#			continue
#
#		var star = STAR.instantiate()
#		add_child(star)
#
#		star.global_position = cartesian_from_text(star_data["RA"], star_data["Dec"])
#		var m = star.mesh.get_active_material(0).duplicate()  
#		m.set_shader_parameter("mag", float(star_data["V"]))  
#		star.mesh.set_surface_override_material(0, m)
#
#		if star_data.has("N") :
#			star.designation = star_data["N"]
#		if star_data.has("C") :
#			star.constellation = star_data["C"]
#			star.add_to_group(star_data["C"])
#
#		var key = str(round(star.global_position * Infos.PRECISION / RADIUS))
#
#		if Infos.Partition.has(key) :
#			Infos.Partition[key].append(star)
#		else :
#			Infos.Partition.merge({key : [star]})
		
	print("Partitions : ", len(Infos.Partition))
#	@warning_ignore("integer_division")
#	print("Stars per Partition : ", len(Stars)/len(Infos.Partition))



func load_constellations() -> Array :
	if not FileAccess.file_exists(CONSTELLATIONS_FILE) :
		printerr("Star file does not exits")
		return []
	
	var json_string = FileAccess.get_file_as_string(CONSTELLATIONS_FILE)
	var json = JSON.new()
	var _parse_result = json.parse(json_string.left(json_string.length() - 1))
		
	return json.get_data()["Constellations"]



func format_constellations(Consts : Array) -> void :
	for constellation in Consts :
		var pos = celestial_to_cartesian(float(constellation["RAh"]), float(constellation["DEd"]))
		var stars : Array = []
		
		for star in constellation["stars"] :
			stars.append(celestial_to_cartesian(star["RAh"], star["DEd"]))
			
		var lines : Array = []
		
		for l in constellation["lines"] :
			lines.append([stars[l[0]], stars[l[1]]])
		
		Infos.Constellations.merge({pos : {"name" : constellation["Name"], "lines" : lines}})
	print("Constellations : ", len(Infos.Constellations))
	
	Infos.LearningConstellations = Infos.Constellations.keys()



func cartesian_from_text(text_ra : String, text_dec : String) -> Vector3 :
	var ra_seconds = 3600.0 * int(text_ra.substr(0, 2)) + 60.0 * int(text_ra.substr(4, 2)) + float(text_ra.substr(8, 4))
	var dec_deg = float(text_dec.substr(1,2)) + float(text_dec.substr(5,2))/60 + float(text_dec.substr(9,2))/360
	
	var dec_sign : float = 1
	if text_dec.substr(0, 1) == "-" :
		dec_sign = -1
	
	return celestial_to_cartesian(ra_seconds/3600, dec_sign * dec_deg)



func celestial_to_cartesian(RAh : float, DEd : float) -> Vector3 :
	var y_rot = 2 * PI * RAh / 24 
	
	var x_rot = 2 * PI * DEd / 360
	
	
	var direction_vector = Vector3()
	direction_vector.x = sin(y_rot) * cos(x_rot)
	direction_vector.y = sin(x_rot)
	direction_vector.z = cos(y_rot) * cos(x_rot)
	
	return direction_vector * RADIUS



func mag_to_brightness(text_mag) -> Color :
	var brightness = max(0.0, min(1.0, (7 - float(text_mag))/7))
	return Color(brightness, brightness, brightness)



func mag_to_scale(text_mag) -> Vector3 :
	var _scale = max(0.0, min(1.0, (7 - float(text_mag))/7))
	return Vector3(1, 1, 1) * _scale
