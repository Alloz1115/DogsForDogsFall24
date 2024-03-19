extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var label: String
var dropped_on_target: bool = false

# Called when the node enters the scene tree for the first time
func _ready():
	add_to_group("DRAGGABLE")
	pass # Replace with function body






func get_drag_data(position: Vector2):
	var slot = get_parent().get_name()
	
	var data = {}
	data["origin_node"] = self
	data["origin_slot"] = slot
	data["origin_texture_normal"] = texture_normal
	data["origin_texture_pressed"] = texture_pressed
	
	#var dragPreview = DRAGPREVIEW.instance()
	#dragPreview.texture = texture_normal
	#add_child(dragPreview)
	
	return data
	
func can_drop_data(position, data):
	var target_slot = get_parent().get_name()
	data["target_texture_normal"] = texture_normal
	data ["target_texture_pressed"] = texture_pressed
	
	return true

func drop_data(position, data):
	
	data["origin_node"].texture_normal = data["target_texture_normal"]
	data["origin_node"].texture_pressed = data["target_texture_pressed"]
	
	texture_normal = data["origin_texture_normal"]
	texture_pressed = data["origin_texture_pressed"]
