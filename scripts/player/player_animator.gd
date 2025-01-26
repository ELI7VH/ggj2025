extends AnimatedSprite2D

enum State {IDLE, BLOWING, FILLING, DASHING}

@export var is_full: bool = true
var state: State


func _ready():
	animation_finished.connect(_on_animation_finished)

func _process(_delta: float):
	if Input.is_action_just_pressed('blow'):
		state = State.BLOWING
		play('blow')
	elif Input.is_action_just_released('blow'):
		state = State.IDLE
	
	if state == State.IDLE:
		var input_direction = Input.get_vector("left", "right", "up", "down")
		if input_direction:
			play_prefixed_animation('swim')
			if abs(input_direction.x) > 0.1:
				flip_h = input_direction.x < 0
		else:
			play_prefixed_animation('idle')


func _on_animation_finished():
	state = State.IDLE
	play_prefixed_animation('idle')

func play_prefixed_animation(animation_name: String):
	var prefix = 'full_' if is_full else 'empty_'
	play(prefix + animation_name)


func _on_breath_exhausted():
	is_full = false
	play_prefixed_animation('idle')

func _on_breath_gained(_breath_amount: float):
	is_full = true
	state = State.FILLING
	play('fill')

func _on_dashed():
	state = State.DASHING
	play('fart')
