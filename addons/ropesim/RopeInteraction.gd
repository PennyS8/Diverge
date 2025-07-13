@tool
extends Node
class_name RopeInteraction

## Handles mutual interaction of a target node with a rope.
## Useful for rope grabbing or pulling mechanics where an object should be able to affect the rope
## while also being constrained by it.[br]
## [br]
## Internally, a [RopeHandle] and a [RopeAnchor] is used to update the rope and retrieve the new
## position afterwards.[br]
## It essentially works by running the following three steps every frame:[br]
## 1. Set [RopeHandle] position to target node position.[br]
## 2. Wait for rope simulation to be finished.[br]
## 3. Set target node position to [RopeAnchor] position.

## Emitted when the target node should be moved and [member RopeInteraction.position_update_mode] is [enum RopeInteraction.EmitSignal].
signal on_movement_request(target: Node2D, requested_position: Vector2)


## Determines how the position of the target node is updated.
enum PositionUpdateMode {
    ## Set [member Node2D.global_position] directly.
    SetGlobalPosition,

    ## Use [method CharacterBody2D.move_and_slide]. Only applicable to [CharacterBody2D] targets.
    MoveAndSlide,

    ## Do not set the position automatically, but emit the [signal RopeInteraction.on_movement_request]
    ## signal to allow manual handling.
    EmitSignal,
}

## Enable or disable.
@export var enable: bool = true : set = set_enable

## Always disable this node in editor. Mostly useful to not accidentally move nodes around, e.g. PinJoints.
@export var disable_in_editor: bool = false : set = set_disable_in_editor

## Determines how the position of the target node should be updated.
@export var position_update_mode: PositionUpdateMode = PositionUpdateMode.EmitSignal

## Target node that should be attached to the rope.
@export var target_node: Node2D

## (Optional) Use the given node instead of the target node to update the rope point's position.
## If set, the target_node will only be snapped to the rope, but it will not affect it.[br]
## [br]
## One use-case is attaching a RigidBody to a rope. The RigidBody should affect the rope, but in
## order to constrain it, a PointJoint2D is needed.
## To make it work, the PinJoint2D must be set as target_node and the RigidBody as input_node_override.
@export var input_node_override: Node2D

## Target rope.
@export var rope: Rope : set = set_rope

## Position on the rope between 0 and 1.
@export_range(0.0, 1.0) var rope_position: float = 1.0 : set = set_rope_position

## Handle strength. See also [member RopeHandle.strength].
## Usually only useful when the rope_position is either 0.0 or 1.0, i.e. one of the endpoints.
@export_range(0.0, 1.0) var strength: float = 0.0 : set = set_strength

## Offset to apply between rope and target_node/input_node_override.
@export var offset: Vector2

var _anchor: RopeAnchor
var _handle: RopeHandle


func _init() -> void:
    _handle = _create_default_handle()
    _handle.on_before_update.connect(_on_before_update)
    add_child(_handle)

    _anchor = _create_default_anchor()
    _anchor.on_after_update.connect(_on_after_update)
    add_child(_anchor)

    _update_enable_state()


func _enter_tree() -> void:
    set_rope(rope)

    if not target_node:
        push_warning("RopeInteraction: No target node selected -> Disabling")
        enable = false


func _on_before_update() -> void:
    _handle.global_position = (input_node_override if input_node_override else target_node).global_position + offset


func _on_after_update() -> void:
    var target_pos := _anchor.global_position - offset
    var diff := target_pos - target_node.global_position

    if diff.length_squared() < 0.01 * 0.01:
        return

    match position_update_mode:
        PositionUpdateMode.EmitSignal:
            on_movement_request.emit(target_node, target_pos)
        PositionUpdateMode.SetGlobalPosition:
            target_node.global_position = target_pos
        PositionUpdateMode.MoveAndSlide:
            var body := target_node as CharacterBody2D

            if not body:
                push_error("RopeInteraction: Target node is not a CharacterBody2D")
                return

            var backup_vel := body.velocity
            # Counteract the delta multiplication that happens in move_and_slide() because we want to travel the whole distance
            body.velocity = diff / get_physics_process_delta_time()
            body.move_and_slide()
            body.velocity = backup_vel


## Determine the nearest position on the rope to the target node and use it as [member RopeInteraction.rope_position].
func use_nearest_position() -> void:
    _handle.use_nearest_position_to_point(target_node.global_position + offset)
    rope_position = _handle.rope_position


## Snaps the target node to the current position on the rope.
func force_snap_to_rope() -> void:
    _anchor.force_update = true  # TODO: This should be a function to call
    _on_after_update()


func set_rope_position(value: float) -> void:
    rope_position = value
    _handle.rope_position = value
    _anchor.rope_position = value


# func set_rope(value: NodePath) -> void:
func set_rope(value: Rope) -> void:
    rope = value

    if rope:
        # NOTE: For some reason, rope.get_path() will result in unrecoverable path errors when the
        # RopeInteraction node is moved in the tree. Using a relative path works fine.
        # Maybe a Godot bug.
        var path := _handle.get_path_to(rope)
        _handle.rope_path = path
        _anchor.rope_path = path
    else:
        _handle.rope_path = ""
        _anchor.rope_path = ""


func set_enable(value: bool) -> void:
    enable = value
    _update_enable_state()


func set_disable_in_editor(value: bool) -> void:
    disable_in_editor = value
    _update_enable_state()


func set_strength(value: float) -> void:
    strength = value
    _handle.strength = strength


## Returns the internal [RopeAnchor].
func get_anchor() -> RopeAnchor:
    return _anchor


## Returns the internal [RopeHandle].
func get_handle() -> RopeHandle:
    return _handle


func _create_default_handle() -> RopeHandle:
    var handle := RopeHandle.new()
    handle.enable = true
    handle.rope_position = rope_position
    handle.precise = true
    handle.strength = strength
    return handle


func _create_default_anchor() -> RopeAnchor:
    var anchor := RopeAnchor.new()
    anchor.enable = true
    anchor.rope_position = rope_position
    anchor.precise = true
    return anchor


func _update_enable_state() -> void:
    _handle.enable = enable
    _anchor.enable = enable and (not disable_in_editor or not Engine.is_editor_hint())
