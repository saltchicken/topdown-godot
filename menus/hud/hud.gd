extends CanvasLayer

@export var health_component : HealthComponent
@export var mana_component : ManaComponent
@onready var health_gauge = get_node("HealthGauge")
@onready var mana_gauge = get_node("ManaGauge")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_component.health_update.connect(on_health_update)
	#health_gauge.material.set_shader_parameter("fillValue", health_component.health / health_component.MAX_HEALTH)
	mana_component.mana_update.connect(on_mana_update)
	#mana_gauge.material.set_shader_parameter("fillValue", mana_component.mana / mana_component.MAX_MANA)
	

func on_health_update():
	health_gauge.material.set_shader_parameter("fillValue", health_component.health / health_component.MAX_HEALTH)
	
func on_mana_update():
	mana_gauge.material.set_shader_parameter("fillValue", mana_component.mana / mana_component.MAX_MANA)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
