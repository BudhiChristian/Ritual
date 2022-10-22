@tool # note that "tool" in this line is a special keyword that forces the script to run in the editor as well as at runtime.
# it doesn't actually refer to the tool (needles, thurible, dagger) that a player will use.
extends Node2D

@onready var click_handler: Area2D = %click_handler
@onready var tool_asset: Sprite2D = %tool_asset
@onready var tool_frame: Node2D = %tool_frame

@export var _tool_texture: Texture:
	set(value):
		_tool_texture = value
		if Engine.is_editor_hint():
			_update_tool_asset()
@export var _tool_color: Color:
	set(value):
		_tool_color = value
		if Engine.is_editor_hint():
			_update_tool_asset()
@export var _tool_scale: Vector2:
	set(value):
		_tool_scale = value
		if Engine.is_editor_hint():
			_update_tool_asset()

@export var _associated_state: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	click_handler.input_event.connect(_handle_click)
	MessageBus.enable_tool.connect(enable_tool)
	MessageBus.disable_tool.connect(disable_tool)
	MessageBus.state_entered.connect(func(state):
		tool_frame.modulate = Color.SKY_BLUE if state == _associated_state else Color.WHITE
	)
	_update_tool_asset()

func _update_tool_asset():
	tool_asset.texture = _tool_texture
	tool_asset.modulate = _tool_color
	tool_asset.scale = _tool_scale

func _handle_click(_viewport, event: InputEvent, _shape_idx):
	if Engine.is_editor_hint(): return
	var mouse_event = event as InputEventMouseButton
	if mouse_event and mouse_event.is_pressed():
		if _associated_state.is_usable:
			_associated_state.start()
		else:
			print("tool not available")
func enable_tool(tool):
	if tool == _associated_state.tool_name:
		visible = true
func disable_tool(tool):
	if tool == _associated_state.tool_name:
		visible = false
