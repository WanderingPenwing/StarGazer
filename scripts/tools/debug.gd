extends Control

const width = 3

var draw_lines : Array
var draw_points : Array


func _draw() :
	for line in draw_lines :
		draw_line(line["start"], line["end"], line["color"], width)
	
	for point in draw_points :
		draw_circle(point["pos"], width / 2, point["color"])



func update_drawing(_draw_lines : Array, _draw_points : Array = []) :
	draw_lines = _draw_lines
	draw_points = _draw_points
	queue_redraw()
