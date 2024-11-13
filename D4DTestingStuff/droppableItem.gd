extends Node2D

var draggable = false
var is_dragging = false
var is_inside_droppable = false
var body_ref
var offset: Vector2
var initialPos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if draggable:
		if Input.is_action_just_pressed("click"):
			initialPos = global_position
			offset = get_global_mouse_position() - global_position
			is_dragging = true
			print("is clicking")
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
			is_dragging = true
		elif Input.is_action_just_released("click"):
			is_dragging = false
			var tween = get_tree().create_tween()
			if is_inside_droppable:
				tween.tween_property(self, "position", body_ref.position, 0.2).set_ease(Tween.EASE_OUT)
			else:
				tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)

func _on_area_2d_mouse_entered():
	if not is_dragging:
		draggable = true

func _on_area_2d_mouse_exited():
	if not is_dragging:
		draggable = false

func _on_area_2d_body_entered(body:StaticBody2D):
	if body.is_in_group('droppable'):
		is_inside_droppable = true
		body_ref = body

func _on_area_2d_body_exited(body:StaticBody2D):
	if body.is_in_group('droppable'):
		is_inside_droppable = false
