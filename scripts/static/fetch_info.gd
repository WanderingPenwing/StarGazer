extends Node3D

const PRECISION : float = 5
const CONSTELLATION_DAMPENING : Dictionary = {"min" : 20, "max" : 30}

@export var Ui : Node

var Partition : Dictionary
var Constellations : Dictionary
var LearningConstellations : Array

var target : Vector3


func fetch_star(_target : Vector3) -> Node :
	var key = str(round(_target * PRECISION))
	if not Partition.has(key) :
		Ui.print_debug_info("target chunk size : 0 ", 3)
		return
	Ui.print_debug_info("target chunk size : " + str(len(Partition[key])), 3)
	
	var closest : Node
	for star in Partition[key] :
		if not closest :
			closest = star
			continue
		if star.global_position.distance_squared_to(_target) > closest.global_position.distance_squared_to(_target) :
			continue
		closest = star
	
	return closest



func fetch_star_alt(_target : Vector3) -> Dictionary :
	var key = str(round(_target * PRECISION))
	if not Partition.has(key) :
		Ui.print_debug_info("target chunk size : 0 ", 3)
		return {}
	Ui.print_debug_info("target chunk size : " + str(len(Partition[key])), 3)
	
	var closest : Dictionary
	for star in Partition[key] :
		if not closest :
			closest = star
			continue
		if star["pos"].distance_squared_to(_target) > closest["pos"].distance_squared_to(_target) :
			continue
		closest = star
	
	return closest



func fetch_constellations(_target : Vector3) -> Array :
	var Consts = Constellations.keys()
	target = _target
	Consts.sort_custom(sort_distance)
	
	var Consts_data : Array = []
	
	for c in range(len(Consts)) :
		Consts_data.append(Constellations[Consts[c]])
		Consts_data[-1]["alpha"] = min(1.0, max(0.0, 1.0 - (Consts[c].distance_to(target) - CONSTELLATION_DAMPENING["min"])/(CONSTELLATION_DAMPENING["max"] - CONSTELLATION_DAMPENING["min"])))
		
		if Consts[c].distance_to(target) > CONSTELLATION_DAMPENING["max"] :
			return Consts_data
			
	return Consts_data



func sort_distance(a, b) -> bool :
	return a.distance_to(target) < b.distance_to(target)
