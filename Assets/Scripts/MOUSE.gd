extends Node

onready var MouseRegionRect = ColorRect.new()
onready var MouseRegion = Area2D.new()
onready var MouseRegionShape = CollisionShape2D.new()

var mouse_region_start_position = Vector2()

var arr = []

onready var world = get_node("/root/InGame/World")

func _ready():
	if world != null:
		world.get_parent().add_child(MouseRegionRect)
		MouseRegionRect.rect_size = Vector2()
		MouseRegionRect.color = Color(1, 1, 1, 0.2)
		world.get_parent().add_child(MouseRegion)
		MouseRegion.add_child(MouseRegionShape)
		MouseRegionShape.shape = RectangleShape2D.new()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if world == null:
		return
	if Input.is_action_just_pressed("left_mouse_button"):
		mouse_region_start_position = world.get_global_mouse_position()
	if Input.is_action_pressed("left_mouse_button"):
		var del = world.get_global_mouse_position() - mouse_region_start_position
		MouseRegion.global_position = (mouse_region_start_position + (del / 2))
		MouseRegionShape.shape.extents = Vector2(abs(del.x / 2), abs(del.y / 2))
		
		MouseRegionRect.rect_position = mouse_region_start_position + Vector2(world.get_global_mouse_position().x - mouse_region_start_position.x, 0)
		MouseRegionRect.rect_size = Vector2(abs(world.get_global_mouse_position().x - mouse_region_start_position.x), abs(world.get_global_mouse_position().y - mouse_region_start_position.y))
		
		if world.get_global_mouse_position().x < mouse_region_start_position.x and world.get_global_mouse_position().y < mouse_region_start_position.y:
			MouseRegionRect.rect_scale = Vector2(1, -1)
		elif world.get_global_mouse_position().x < mouse_region_start_position.x and world.get_global_mouse_position().y > mouse_region_start_position.y:
			MouseRegionRect.rect_scale = Vector2(1, 1)
		elif world.get_global_mouse_position().x > mouse_region_start_position.x and world.get_global_mouse_position().y > mouse_region_start_position.y:
			MouseRegionRect.rect_scale = Vector2(-1, 1)
		elif world.get_global_mouse_position().x > mouse_region_start_position.x and world.get_global_mouse_position().y < mouse_region_start_position.y:
			MouseRegionRect.rect_scale = Vector2(-1, -1)
		
	else:
		MouseRegionShape.shape.extents = Vector2(0, 0)
		MouseRegionRect.rect_size = Vector2()
