# Player.gd – jump + double-jump with ui_up
extends CharacterBody2D

@export var move_speed      : float = 250.0
@export var gravity         : float = 980.0
@export var jump_force      : float = 400.0
@export var max_jumps       : int   = 2      # 1 ground + 1 air-jump

var _jumps_left : int = max_jumps            # refill on landing

func _physics_process(delta: float) -> void:
	# ── gravity ───────────────────────────────────────────────
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0

	# ── horizontal arrows (left / right only) ────────────────
	var dir_x := Input.get_action_strength("ui_right") \
			   - Input.get_action_strength("ui_left")
	velocity.x = dir_x * move_speed

	# ── jump & double-jump on ui_up ───────────────────────────
	if Input.is_action_just_pressed("ui_up") and _jumps_left > 0:
		velocity.y = -jump_force
		_jumps_left -= 1

	move_and_slide()

	# ── landed? → reset jump counter ──────────────────────────
	if is_on_floor():
		_jumps_left = max_jumps
