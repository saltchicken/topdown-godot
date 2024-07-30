extends CanvasLayer

@onready var panel = get_node('PanelContainer')
@onready var button_container = get_node('PanelContainer/VBoxContainer')

signal option_selected

func _ready():
	panel.hide()
		
func on_button_pressed(button):
	option_selected.emit(button.text)
	finish()
	
func set_options(option_array: Array):
	for option in option_array:
		var button = Button.new()
		button.text = option
		button.pressed.connect(on_button_pressed.bind(button))
		button_container.add_child(button)

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		print_debug("Interact pressed")
	
func main():
	await get_tree().create_timer(0.05).timeout
	panel.show()
		
#func start_timer():
	#timer.start()
	
func finish():
	panel.hide()
	await get_tree().create_timer(0.05).timeout
	get_tree().paused = false
	queue_free()
	#finished_dialogue.emit()
	
#func _on_timer_timeout():
	#current_line += 1
	#timer.stop()
	#type()
