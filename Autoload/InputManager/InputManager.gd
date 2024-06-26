# @category: Utils/InputManager
extends Node

# Signals.
# warning-ignore-all:unused_signal
signal single_tap
signal single_touch
signal single_drag
signal multi_drag
signal pinch
signal twist
signal any_gesture
signal focus_group_id_changed
signal special_work_status_id_changed

# Enum.
enum Gestures {PINCH, MULTI_DRAG, TWIST}

# Constants.
const debug = false
const DRAG_STARTUP_TIME = 0.02
const TAP_TIME_THRESHOLD = 0.2

# Control.
var last_mouse_press = null  # Last mouse button pressed.
var touches = {} # Keeps track of all the touches.
var drags = {}   # Keeps track of all the drags.

var tap_delay_timer = Timer.new()
var only_touch = null # Last touch if there wasn't another touch at the same time.

var tap_start_pos := Vector2()

var drag_startup_timer = Timer.new()
var drag_enabled = false 

var disabled_event := []



class InputManagerEvent:
	var sig : String
	var val : InputEventAction
	func _init(_sig := sig, _val := val):
		sig = _sig
		val = _val

## Creates the required timers and connects their timeouts.
func _ready():
	_add_timer(tap_delay_timer, null)
	_add_timer(drag_startup_timer, on_drag_startup_timeout)


func parse_event(event) -> InputManagerEvent:
	var input_manager_event : InputManagerEvent = null
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				input_manager_event = InputManagerEvent.new(
					"pinch",
					InputEventScreenPinch.new({
						"position": event.position,
						"distance": 200.0,
						"relative": -40.0,
						"speed"   : 25.0
					})
				)
			elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
				input_manager_event = InputManagerEvent.new(
					"pinch",
					InputEventScreenPinch.new({
						"position": event.position,
						"distance": 200.0,
						"relative": 40.0,
						"speed"   : 25.0
					})
				)
			last_mouse_press = event
		else:
			last_mouse_press = null
		
	elif event is InputEventMouseMotion:
		if last_mouse_press:
			if last_mouse_press.button_index == MOUSE_BUTTON_MIDDLE:
				input_manager_event = InputManagerEvent.new(
					"multi_drag",
					InputEventMultiScreenDrag.new({"position": event.position,
												"relative": event.relative,
												"speed": event.velocity})
				)
			elif last_mouse_press.button_index == MOUSE_BUTTON_RIGHT:
				var rel1 = event.position - last_mouse_press.position
				var rel2 = rel1 + event.relative
				input_manager_event = InputManagerEvent.new(
					"twist",
					InputEventScreenTwist.new({"position": last_mouse_press.position,
												"relative": rel1.angle_to(rel2),
												"speed": event.velocity})
				)
	
	# Touch.
	elif event is InputEventScreenTouch:
		if event.pressed:
			tap_start_pos = event.position
			touches[event.get_index()] = event 
			if (event.get_index() == 0): # First and only touch.
				input_manager_event = InputManagerEvent.new(
					"single_touch",
					InputEventSingleScreenTouch.new(event)
				)
				only_touch = event
				if tap_delay_timer.is_stopped(): tap_delay_timer.start(TAP_TIME_THRESHOLD)
			else:
				only_touch = null
				cancel_single_drag()
		else:
			touches.erase(event.get_index())
			drags.erase(event.get_index())
			cancel_single_drag()
			if only_touch:
				input_manager_event = InputManagerEvent.new(
					"single_touch",
					InputEventSingleScreenTouch.new(event)
				)
				if !tap_delay_timer.is_stopped() && (event.position - tap_start_pos).length() < 3: 
					tap_delay_timer.stop()
					input_manager_event = InputManagerEvent.new(
						"single_tap",
						InputEventSingleScreenTap.new(only_touch)
					)
		
	elif event is InputEventScreenDrag:
		drags[event.index] = event
		if !complex_gesture_in_progress():
			if(drag_enabled):
				input_manager_event = InputManagerEvent.new(
					"single_drag",
					InputEventSingleScreenDrag.new(event)
				)
			else:
				if drag_startup_timer.is_stopped(): drag_startup_timer.start(DRAG_STARTUP_TIME)
		else:
			cancel_single_drag()
			if drags.size() > 1 :
				var gesture = identify_gesture(drags)
				if gesture == Gestures.PINCH:
					input_manager_event = InputManagerEvent.new(
						"pinch",
						InputEventScreenPinch.new(drags)
					)
				elif gesture == Gestures.MULTI_DRAG:
					input_manager_event = InputManagerEvent.new(
						"multi_drag",
						InputEventMultiScreenDrag.new(drags)
					)
				elif gesture == Gestures.TWIST:
					input_manager_event = InputManagerEvent.new(
						"twist",
						InputEventScreenTwist.new(drags)
					)
	return input_manager_event

func feed_event(event):
	var input_manager_event = parse_event(event)
	if !is_instance_valid(input_manager_event):
		return
	if disabled_event.has(input_manager_event.sig):
		return
	emit(input_manager_event.sig, input_manager_event.val, true)

## Handles all unhandled inputs emiting the corresponding signals.
func _unhandled_input(event):
	feed_event(event)
	# Mouse to gesture.
	pass

# Emits signal sig with the specified args.
func emit(sig, val, feed_input := true):
	if debug: print(val.as_text())
	emit_signal("any_gesture", sig, val)
	emit_signal(sig, val)
	if feed_input:
		Input.parse_input_event(val)

# Disables drag and stops the drag enabling timer.
func cancel_single_drag():
	drag_enabled = false
	drag_startup_timer.stop()


# Checks if complex gesture (more than one finger) is in progress.
func complex_gesture_in_progress():
	return touches.size() > 1


# Checks if the gesture is pinch.
func identify_gesture(gesture_drags):
	var center = Vector2()
	for e in gesture_drags.values():
		center += e.position
	center /= gesture_drags.size()
	
	var sector = null
	for e in gesture_drags.values():
		var adjusted_position = center - e.position
		var raw_angle = fmod(adjusted_position.angle_to(e.relative) + (PI/4), TAU) 
		var adjusted_angle = raw_angle if raw_angle >= 0 else raw_angle + TAU
		var e_sector = floor(adjusted_angle / (PI/2))
		if sector == null: 
			sector = e_sector
		elif sector != e_sector:
			sector = -1
	
	if sector == -1:               return Gestures.MULTI_DRAG
	if sector == 0 or sector == 2: return Gestures.PINCH
	if sector == 1 or sector == 3: return Gestures.TWIST

func on_drag_startup_timeout():
	drag_enabled = !complex_gesture_in_progress() and drags.size() > 0

# Macro to add a timer and connect it's timeout to func_name.
func _add_timer(timer, callable):
	timer.one_shot = true
	if callable:
		timer.connect("timeout", callable)
	self.add_child(timer)

var special_work_status_id := ""
func change_special_work_status_id(id : String):
	special_work_status_id = id
	special_work_status_id_changed.emit()

var focus_group_id := ""

func change_focus_group_id(id : String):
	focus_group_id = id
	focus_group_id_changed.emit()
