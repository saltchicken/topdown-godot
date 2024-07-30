extends CharacterBody2D


signal interact

var option_panel

func _ready():
	interact.connect(on_interact)

func on_interact():
	#Global.dialogue(self, ["Well hello there", "How can I help you?"])
	option_panel = Global.option_panel(self, ["Yes", "No"])
	option_panel.option_selected.connect(on_option_selected)
	option_panel.main()
	
func on_option_selected(option):
	print_debug(option + " selected")
	
	
