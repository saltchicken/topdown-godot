extends CharacterBody2D


signal interact

func _ready():
	interact.connect(on_interact)

func on_interact():
	Global.dialogue(self, ["Well hello there"])
	
	
