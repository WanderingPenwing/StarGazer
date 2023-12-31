extends CanvasLayer

const LENGTH : int = 20

@export var TextLabel : Node
@export var DebugLabel : Node
@export var DrawingBoard : Node

var text_info : Array 
var debug_info : Array 
var draw_lines : Array 
var draw_points : Array


func update_text() -> void :
	var text : String = ""
	
	for line in text_info :
		if line == "" :
			text += "\n"
			continue
		text += line + "\n"
		
	TextLabel.text = text



func update_debug() -> void :
	var text : String = ""
	
	for line in debug_info :
		if line == "" :
			text += "\n"
			continue
		text += line + "\n"
		
	DebugLabel.text = text



func print_text(txt : String, line : int) -> void :
	while line >= len(text_info) :
		text_info.append("")
	
	text_info[line] = txt



func print_debug_info(txt : String, line : int) -> void :
	while line >= len(debug_info) :
		debug_info.append("")
	
	debug_info[line] = txt



func clear_lines() -> void :
	draw_lines.clear()



func clear_points() -> void :
	draw_points.clear()



func print_line(start : Vector2, end : Vector2, color : Color = Color.WHITE) -> void :
	draw_lines.append({"start" : start, "end" : end, "color" : color})



func print_point(pos : Vector2, color : Color = Color.WHITE) -> void :
	draw_points.append({"pos" : pos, "color" : color})



func show_drawing() -> void :
	DrawingBoard.update_drawing(draw_lines, draw_points)

