extends Control

const width = 2

var draw_lines : Array

func _draw() :
	for line in draw_lines :
		draw_line(line["start"], line["end"], line["color"], width)



#func draw_triangle(pos, dir, color, _size):
#	var a = pos + dir * _size
#	var b = pos + dir.rotated(2*PI/3) * _size
#	var c = pos + dir.rotated(4*PI/3) * _size
#	var points = PackedVector2Array([a, b, c])
#	draw_polygon(points, PackedColorArray([color]))



func update_drawing(_draw_info : Array) :
	draw_lines = _draw_info
	self.hide()
	self.show()
