extends Camera2D

var min_zoom = 0.3
var max_zoom = 5

var player_combination

func _ready():
	player_combination = get_parent().get_node("Player/PlayerCombination")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vec = Vector2()
	if Input.is_key_pressed(KEY_W):
		vec += Vector2(0, -10)
	if Input.is_key_pressed(KEY_A):
		vec += Vector2(-10, 0)
	if Input.is_key_pressed(KEY_S):
		vec += Vector2(0, 10)
	if Input.is_key_pressed(KEY_D):
		vec += Vector2(10, 0)
	position += vec * zoom
	if Input.is_action_just_released("wheel_up"):
		self.zoom -= Vector2(0.09, 0.09)
		#self.position = self.position + () * 0.1
		#print("UP!!!")
	elif Input.is_action_just_released("wheel_down"):
		self.zoom += Vector2(0.09, 0.09)
		#self.position = self.position - (get_global_mouse_position() - self.position) * 0.1
	var _zoom = zoom.x
	_zoom = clamp(_zoom, min_zoom, max_zoom)
	self.zoom = Vector2(_zoom, _zoom)
