extends MarginContainer

signal confirmed(card, terrain)

@onready var _LabelName = $MarginContainer/VBoxContainer/LabelName
@onready var _ListRequirements = $MarginContainer/VBoxContainer/ListRequirements
@onready var _ButtonConfirm = $MarginContainer/VBoxContainer/ButtonConfirm
@onready var _HSeparator2 = $MarginContainer/VBoxContainer/HSeparator2
@onready var _VBoxContainer = $MarginContainer/VBoxContainer

var Scene_RequirementItem := preload("res://Assets/Scene/GUI/CardElementConfirmation/RequirementItem/RequirementItem.tscn")

var enabled := false

var demo_model_scene : ModelScene

var terrain : PlanetTerrain
func set_terrain(_terrain):
	terrain = _terrain

var card : CardElement
func set_card(_card):
	card = _card 

func _process(_delta):
	if is_instance_valid(terrain) and enabled:
		var camera : Camera3D = get_viewport().get_camera_3d()
		var position2d : Vector2 = camera.unproject_position(terrain.get_center())
		#global_position = position2d - size / 2
		global_position = position2d

func enable():
	show()
	_ButtonConfirm.mouse_filter = MOUSE_FILTER_STOP
	enabled = true
	set_process(true)

func disable():
	hide()
	_ButtonConfirm.mouse_filter = MOUSE_FILTER_IGNORE
	enabled = false
	set_process(false)
	if is_instance_valid(demo_model_scene):
		demo_model_scene.delete()

func init():
	if is_instance_valid(demo_model_scene):
		demo_model_scene.delete()
	_LabelName.text = card.card_name
	for i in _ListRequirements.get_children():
		i.queue_free()
	await get_tree().process_frame
	await get_tree().process_frame
	var flag := true
	for r in card.requirements:
		var s : String = str(r)
		var check : bool = r.check(terrain)
		#print("%s:%s" % [s, str(check)])
		if !check:
			flag = false
		var new_requirement_item = Scene_RequirementItem.instantiate()
		new_requirement_item.set_text(s)
		new_requirement_item.set_valid(check)
		_ListRequirements.add_child(new_requirement_item)
		new_requirement_item.init()
	_ButtonConfirm.disabled = !flag
	_HSeparator2.visible = card.requirements.size() > 0
	update_minimum_size()
	await get_tree().create_timer(0.1)
	update_minimum_size()
	demo_model_scene = card.element_instance.get_demo_model_scene()
	add_child(demo_model_scene)
	demo_model_scene.demo_display(flag)
	terrain.place_model_scene(demo_model_scene, card.element_instance.on_liquid_surface and card.element_instance.can_with_liquid)


func _on_button_confirm_pressed():
	confirmed.emit(card, terrain)
	pass # Replace with function body.
