extends CanvasLayer

@export var health_component : HealthComponent
@onready var health_gauge = get_node("HealthGauge")
@onready var mana_gauge = get_node("ManaGauge")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_component.health_update.connect(on_health_update)
	health_gauge.material.set_shader_parameter("fillValue", health_component.health / health_component.MAX_HEALTH)

func on_health_update():
	health_gauge.material.set_shader_parameter("fillValue", health_component.health / health_component.MAX_HEALTH)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
