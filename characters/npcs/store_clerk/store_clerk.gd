extends CharacterBody2D


signal interact

func _ready():
	interact.connect(on_interact)

func on_interact():
	print_debug("Interacting with store_clerk")
	
	
