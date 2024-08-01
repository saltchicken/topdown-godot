extends CharacterBody2D


signal interact

var option_panel
var dialogue_panel

@onready var input_ready = false

func _ready():
	interact.connect(on_interact)

func on_interact():
	print("store clerk interact")
	# TODO: Will this cause problems instantiating too many options?
	#option_panel = Global.option_panel(self, ["Shop", "Talk", "Leave"])
	#option_panel.option_selected.connect(on_option_selected)
	#option_panel.main()
	#await option_panel.complete
	#print("complete")
	#Global.dialogue_panel(self, ["Hello there here is some more text", "General Kenobi blah blah blah"])
	if Global.option_node.visible or Global.dialogue_node.visible:
		return
	Global.option_panel(self, ["Shop", "Talk", "Leave"])
	Global.option_node.option_selected.connect(on_option_selected)
	
func on_option_selected(option):
	match option:
		"Shop":
			open_shop()
		"Talk":
			process_mode = Node.PROCESS_MODE_DISABLED
			Global.dialogue_panel(self, ["Well hello there", "How can I help you"])
			await Global.dialogue_node.complete
			process_mode = Node.PROCESS_MODE_ALWAYS
		"Leave":
			pass
				
func open_shop():
	pass
	
	
