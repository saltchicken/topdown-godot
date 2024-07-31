extends CanvasLayer

@onready var panel = get_node('PanelContainer')
@onready var button_container = get_node('PanelContainer/VBoxContainer')
@onready var receive_input = false

var options = []
@onready var selected_option: int = 0: set = _set_selected_option

func _set_selected_option(new_value):
	if new_value < 0:
		selected_option = 0
	elif new_value >= options.size():
		selected_option = options.size() - 1
	else:
		selected_option = new_value
	options[selected_option].grab_focus()
	



signal option_selected
signal complete

#func _ready():
	#panel.hide()
		
func on_button_pressed(button):
	option_selected.emit(button.text)
	finish()
	
func set_options(option_array: Array):
	for option in option_array:
		var button = Button.new()
		button.text = option
		button.pressed.connect(on_button_pressed.bind(button))
		button_container.add_child(button)
		options.append(button)
	#await get_tree().create_timer(0.05).timeout
	selected_option = 0
		

func _process(_delta):
	if visible:
		if Input.is_action_just_pressed("slot_select_confirm"):
			options[selected_option].pressed.emit()
		if Input.is_action_just_pressed("slot_select_back"):
			print_debug("Cancelled the Option Panel")
			finish()
		if Input.is_action_just_pressed("up"):
			selected_option -= 1
		if Input.is_action_just_pressed("down"):
			selected_option += 1
	
func main():
	print('set visible')
	get_tree().paused = true
	show()
	#await get_tree().create_timer(0.15).timeout
		
#func start_timer():
	#timer.start()
	
func finish():
	panel.hide()
	await get_tree().create_timer(0.05).timeout
	complete.emit()
	get_tree().paused = false
	queue_free()
	#finished_dialogue.emit()
	
#func _on_timer_timeout():
	#current_line += 1
	#timer.stop()
	#type()
