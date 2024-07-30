extends CharacterBody2D


signal interact

var option_panel
var dialogue_panel

func _ready():
	interact.connect(on_interact)

func on_interact():
	dialogue_panel = Global.dialogue(self, ["Well hello there"])
	dialogue_panel.main()
	await dialogue_panel.complete
	# TODO: Will this cause problems instantiating too many options?
	option_panel = Global.option_panel(self, ["Yes", "No"])
	option_panel.option_selected.connect(on_option_selected)
	option_panel.main()
	await option_panel.complete
	print_debug("Option panel completed")
	
func on_option_selected(option):
	print_debug(option + " selected")
	
	
