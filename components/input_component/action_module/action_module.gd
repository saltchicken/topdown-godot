extends InputModule

var use
var sneak
var dash
var cast

func update():
	use = Input.is_action_just_pressed('use')
	sneak = Input.is_action_pressed('sneak')
	dash = Input.is_action_just_pressed('dash')
	attack = Input.is_action_just_pressed('attack')
	cast = Input.is_action_just_pressed('cast')
