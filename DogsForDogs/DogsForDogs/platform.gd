extends StaticBody2D

#func _ready():
#	modulate = Color(Color.aliceblue, 0.7)
	
func _process(delta):
	if global.is_dragging:
		visible = true
	else:
		visible = false