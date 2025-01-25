extends AnimatedSprite2D

enum State {IDLE, BLOWING, FILLING}

@export var is_full: bool = true
var state: State


func _ready():
	animation_finished.connect(_on_animation_finished)

func _process(_delta: float):
	if state == State.IDLE:
		var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if input_direction:
			play_prefixed_animation('swim')
			if input_direction.x != 0:
				flip_h = input_direction.x < 0
		else:
			play_prefixed_animation('idle')


func _on_animation_finished():
	state = State.IDLE
	play_prefixed_animation('idle')

func play_prefixed_animation(animation_name: String):
	var prefix = 'full_' if is_full else 'empty_'
	play(prefix + animation_name)


func _on_bubble_blown():
	state = State.BLOWING
	play('blow')

func _on_breath_filled():
	state = State.FILLING
	play('fill')