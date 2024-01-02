extends Camera3D

const CENTER : Vector2 = Vector2(800, 450)
const RADIUS : float = 20
const MIN_FOV : float = 15
const MAX_FOV : float = 90
const ZOOM_SLIP = 0.7



@export var Ui : Node
@export var FetchInfo : Node
@export var constellation_color : Color

var last_target : Vector3
var last_rotate_mouse_pos : Vector2
var last_mouse_pos : Vector2
var average_fps : float
var min_fps : float = 1000
var number_frames : int
var display_constellations : bool = false

@onready var Gamestate : Node = get_node("/root/GameState")



func _ready() -> void :
	Ui.print_text("Esc : show constellations", 2)



func _process(delta: float) -> void :
	var moved : bool = false
	
	fps(delta)
	
	zoom()
	
	move()
	
	rotate_screen()
	
	hud_constellations()
	
	Ui.clear_lines()
	show_constellation()
	Ui.show_drawing()
	
	start_roll()
	
	Ui.update_text()
	Ui.update_debug()



func fps(delta : float) -> void :
	average_fps = (average_fps * number_frames + 1/delta) / (number_frames + 1)
	number_frames += 1
	if 1/delta < min_fps :
		min_fps = 1/delta
	Ui.print_debug_info("Fps : " + str(round(1/delta)) + " (avg : " + str(round(average_fps)) + ", lowest : " + str(round(min_fps)) + ")", 0)



func zoom() -> void :
	if Input.is_action_just_pressed("zoom") :
		self.fov = lerp(self.fov, max(self.fov * 0.9, MIN_FOV), ZOOM_SLIP)
	
	if Input.is_action_just_pressed("dezoom") :
		self.fov = lerp(self.fov, min(self.fov / 0.9, MAX_FOV), ZOOM_SLIP)
	
	Ui.print_debug_info("Fov : " + str(round(self.fov)), 1)



func move() -> bool :
	var target = project_ray_normal(get_viewport().get_mouse_position())
	
	Ui.print_text("Left Mouse Click, drag : Move", 0)
	
	star_name(target)
	
	if Input.is_action_just_pressed("click") :
		last_target = target
	
	var center = project_ray_normal(CENTER)
	
	Ui.print_debug_info("Center Normal : " + str(center), 2)
	
	if not Input.is_action_pressed("click") :
		return false
	
	
	if (target - last_target).length() > 0 :
		var target_transform = transform.rotated((target - last_target).rotated(center, -PI/2).normalized(), (target - last_target).length())

		var a = Quaternion(transform.basis)
		var b = Quaternion(target_transform.basis)
		var c = a.slerp(b, 0.8)
	
		transform.basis = Basis(c)
	
	last_mouse_pos = get_viewport().get_mouse_position()
	last_target = project_ray_normal(get_viewport().get_mouse_position())
	
	return true



func star_name(target : Vector3) -> void :
	if not target :
		return
	var closest = FetchInfo.fetch_star(target)

	if not closest :
		Ui.print_debug_info("Closest star : None ", 4)
	else :
		Ui.print_debug_info("Closest star : WIP", 4)



func rotate_screen() -> bool :
	Ui.print_text("Right Mouse Click, drag : Rotate", 1)
	
	if Input.is_action_just_pressed("r_click") :
		last_rotate_mouse_pos = get_viewport().get_mouse_position()
	
	if not Input.is_action_pressed("r_click") :
		return false
	
	var mouse_pos = get_viewport().get_mouse_position()
	self.global_rotation.z -= (mouse_pos - CENTER).angle_to(last_rotate_mouse_pos - CENTER)
	last_rotate_mouse_pos = get_viewport().get_mouse_position()
	
	return true



func hud_constellations() -> bool :
	if not Input.is_action_just_pressed("ui_cancel") :
		return false
	
	display_constellations = not(display_constellations)
	
	if display_constellations :
		Ui.print_text("Esc : hide constellations", 2)
		return false
	
	Ui.print_text("Esc : show constellations", 2)
	Ui.print_debug_info("", 5)
	return true



func start_roll() -> void :
	Ui.print_text("R : roll", 3)
	if not Input.is_action_just_pressed("roll") :
		return
	print("roll")



func show_constellation() -> void :
	if not(display_constellations) :
		return
	var target = project_ray_normal(get_viewport().get_mouse_position()) * RADIUS
	var constellations = FetchInfo.fetch_constellations(target)
	
	var constellations_names : String = ""
	
	
	for c in constellations :
		constellations_names += c["name"].substr(0, 3) + " - "
		for line in c["lines"] :
			var p1 = unproject_position(line[0])
			var p2 = unproject_position(line[1])
			if not(within_screen_bounds(p1)) and not(within_screen_bounds(p2)) :
				continue
			Ui.print_line(p1 + (p2 - p1).normalized() * 10 , p2 - (p2 - p1).normalized() * 10, Color(constellation_color, c["alpha"]))
		
	
	Ui.print_debug_info("Constellations : " + constellations_names.left(len(constellations_names) - 3), 5)



func within_screen_bounds(point : Vector2) -> bool :
	if point.x > 1600 or point.x < 0 :
		return false
	if point.y > 900 or point.y < 0 :
		return false
	return true



func fuzzy_within_screen_bounds(point : Vector2, delta : float) -> bool :
	if within_screen_bounds(point + Vector2(delta, 0)) :
		return true
	if within_screen_bounds(point + Vector2(-delta, 0)) :
		return true
	if within_screen_bounds(point + Vector2(0, delta)) :
		return true
	if within_screen_bounds(point + Vector2(0, -delta)) :
		return true
	return false
