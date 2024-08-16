extends CanvasLayer

func _ready():
	self.visible = false
	get_node('BlurRect').set_size(get_viewport().get_visible_rect().size)
	
	get_node("MenuTabs").tab_selected.connect(func(_x): print("tab switched"))
	
func _process(_delta):
	if Input.is_action_just_pressed('inventory') or Input.is_action_just_pressed('escape'):
		if get_tree().paused != true or visible:
			owner.pause_menu.emit()
			
func open_pause_menu():
	self.visible = true
	get_tree().paused = true
	
func close_pause_menu():
	get_node("MenuTabs/Inventory/InventoryMenu").close_selection_menu()
	self.visible = false
	get_tree().paused = false
