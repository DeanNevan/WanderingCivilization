extends Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("wheel_up"):
		self.zoom -= Vector2(0.04, 0.04)
		#print("UP!!!")
	elif Input.is_action_just_released("wheel_down"):
		self.zoom += Vector2(0.04, 0.04)
	var _zoom = zoom.x
	_zoom = clamp(_zoom, 0.3, 5)
	self.zoom = Vector2(_zoom, _zoom)
