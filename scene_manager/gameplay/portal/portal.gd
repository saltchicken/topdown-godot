class_name Portal extends Area2D

signal player_entered()

#@export var push_distance:int = 16	## how far into the room the player should be pushed upon entry
@export var path_to_new_scene: String
@export var target_portal: String

@export var teleport: bool = false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	if player_entered.get_connections().size() == 0:
		#print('Portal not connected yet from level')
		return
	#print("Player entered")
	player_entered.emit(self)
	
	if teleport:
		body.teleport_out()
		await get_tree().create_timer(1.0).timeout
	
	var gameplay_node:Gameplay = get_tree().root.get_node('Gameplay')
	var unload:Node = gameplay_node.current_level	# we're now responsible for tracking this
	Global.save_world(true) #TODO: Better place to put this for other scene swaps not using this and a better way to track.
	SceneManager.swap_scenes(path_to_new_scene, gameplay_node.level_holder, unload, "fade_to_black")
	#queue_free()
	
# // UTILITY FUNCTIONS //
## returns the starting location of the player based on this door's location and the 
## entry_direction (the Vector towards the room)
#func get_player_entry_vector() -> Vector2:
	#var vector:Vector2 = Vector2.LEFT
	#match entry_direction:
		#0:
			#vector = Vector2.UP
		#1: 
			#vector = Vector2.RIGHT
		#2:
			#vector = Vector2.DOWN
	#return (vector * push_distance) + self.position

## inverts entry direction to determine the direction player would have been moving
## when they entered the room
#func get_move_dir() -> Vector2:
	#var dir:Vector2 = Vector2.RIGHT
	#match entry_direction:
		#0:
			#dir = Vector2.DOWN
		#1: 
			#dir = Vector2.LEFT
		#2:
			#dir = Vector2.UP	
	#return dir
