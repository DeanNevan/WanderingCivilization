extends Control

onready var ani = $AnimationPlayer

var on_mouse = false

var window
onready var window_tween_1 = Tween.new()
onready var window_tween_2 = Tween.new()
var start_position

var is_window_shown = false

func _ready():
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	ani.play_backwards("choose")
	ani.playback_speed = 3
	start_position = rect_global_position
	#print(start_position)
	add_child(window_tween_1)
	add_child(window_tween_2)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if on_mouse and Input.is_action_pressed("left_mouse_button"):
		rect_scale = Vector2(0.8, 0.8)
		rect_global_position = start_position + Vector2(10, 10)
		#print(rect_position)
	else:
		rect_global_position = start_position
		rect_scale = Vector2(1, 1)
	if on_mouse and Input.is_action_just_released("left_mouse_button"):
		#on_mouse = true
		if is_window_shown:
			close_window()
		else:
			show_window()

func _on_mouse_entered():
	on_mouse = true
	if !ani.is_playing():
		$TextureProgress.fill_mode = randi() % 9
	#print("222")
	ani.play("choose", -1, 1.4)

func _on_mouse_exited():
	on_mouse = false
	ani.play_backwards("choose")

func show_window():
	is_window_shown = true
	window_tween_1.interpolate_property(window, "rect_position", start_position, window.position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	window_tween_2.interpolate_property(window.get_node("Background"), "rect_size", Vector2(80, 80), window.size, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	window_tween_1.start()
	window_tween_2.start()
	yield(get_tree(), "idle_frame")
	modulate = Color(1, 1, 1, 0.3)
	window.visible = true

func close_window():
	is_window_shown = false
	window_tween_1.interpolate_property(window, "rect_position", window.position, start_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	window_tween_2.interpolate_property(window.get_node("Background"), "rect_size", window.size, Vector2(80, 80), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	window_tween_1.start()
	window_tween_2.start()
	yield(get_tree().create_timer(0.2), "timeout")
	window.visible = false
	modulate = Color(1, 1, 1, 1)