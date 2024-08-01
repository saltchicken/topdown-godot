extends CanvasLayer

@onready var panel = get_node('Panel')
@onready var label = get_node("Panel/RichTextLabel")
#signal finished_dialogue
#signal line_changed_dialogue(current_line)

var current_line: int = 0
@export var story_text: PackedStringArray

# Timer was no longer needed. Keeping in case that needs to be an option
#@onready var timer = get_node("Panel/Timer")

@onready var letter_per_second = 30.0

@onready var input_ready = false
@onready var line_complete: bool = false
@onready var tween

signal complete

#func _ready():
	#panel.hide()
	
func _process(_delta):
	if visible:
		if Input.is_action_just_released('interact'):
			input_ready = true
		if Input.is_action_just_pressed("interact") and input_ready:
			input_ready = false
			if tween == null:
				return
			if !line_complete:
				tween.kill()
				label.visible_ratio = 1
				line_complete = true
			else:
				current_line += 1
				line_complete = false
				type()
			
			#current_line += 1
			#timer.stop()
			#type()
			#start_timer()
			#finish()

func set_text(text_array: Array):
	story_text = text_array
	get_tree().paused = true
	#await get_tree().create_timer(0.05).timeout
	type()
	
func set_complete_line():
	line_complete = true

func type():
	get_tree().paused = true
	if current_line < story_text.size():
		#var lines = round((story_text[current_line].length()/1.0))
		#print("Lines: '%s'" %lines)
		var time_length = round((story_text[current_line].length() / letter_per_second))
		label.text = ""
		label.visible_ratio = 0
		tween = create_tween()
		label.text = "[center]" + story_text[current_line] + "[/center]" 
		tween.tween_property(label, "visible_ratio", 1, time_length)
		tween.set_trans(Tween.TRANS_LINEAR)
		tween.tween_callback(set_complete_line)
		#tween.tween_callback(start_timer)
		
		#panel.position.y -= lines * 2
		#panel.size.y = label.size.y + lines * 4 + 5
	else:
		finish()

	
func reset():
	current_line = 0
	story_text = [""] # NOTE: This probably isn't needed
	label.text = ""
	line_complete = false
	input_ready = false
	
func finish():
	#panel.hide()
	reset()
	hide()
	get_tree().paused = false
	complete.emit()
	await get_tree().create_timer(0.05).timeout
	
	
	#queue_free()
	#finished_dialogue.emit()
	
#func _on_timer_timeout():
	#current_line += 1
	#timer.stop()
	#type()
