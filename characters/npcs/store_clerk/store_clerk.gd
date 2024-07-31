extends CharacterBody2D


signal interact

var option_panel
var dialogue_panel

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
	Global.dialogue_panel(self, ["Hello there here is some more text", "General Kenobi blah blah blah"])
	
func on_option_selected(option):
	match option:
		"Shop":
			open_shop()
		"Talk":
			await get_tree().create_timer(0.05).timeout
			dialogue_panel = Global.dialogue(self, ["Well hello there", "How can I help you"])
			dialogue_panel.main()
			#await dialogue_panel.complete
		"Leave":
			pass
				
func open_shop():
	pass
	
	
