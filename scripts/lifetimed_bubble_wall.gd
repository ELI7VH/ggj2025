extends Node2D

@export var spawn_width: float = 240
@export var minimum_size: float = 4
@export var maximum_size: float = 20
@export var emit_period = 0.2
@export var bubble_scene: PackedScene
@export var lifetime: float = 4

var enabled: bool = true
var timer: float = 0

var bubbles: Array[BubbleWithLifetime]


func _process(delta: float) -> void:
	if !enabled: return
	timer += delta
	while timer > emit_period:
		timer -= emit_period
		emit_bubble()

	for bubble in bubbles:
		bubble.lifetime += delta
	bubbles.filter(bubble_should_live)


func emit_bubble():
	var new_bubble = bubble_scene.instantiate()
	add_child(new_bubble)
	new_bubble.position = Vector2.RIGHT * (2 * randf() - 1) * spawn_width
	new_bubble.radius = lerpf(minimum_size, maximum_size, pow(randf(), 2))
	$SfxBlop.play()

	var b = BubbleWithLifetime.new()
	b.bubble = new_bubble
	bubbles.append(b)


func enable():
	enabled = true


func bubble_should_live(bubble: BubbleWithLifetime) -> bool:
	if !is_instance_valid(bubble.bubble): return false
	if bubble.lifetime > lifetime:
		bubble.bubble.queue_free()
		return false
	return true


class BubbleWithLifetime:
	var bubble: Bubble
	var lifetime: float

	func __init(b: Bubble):
		bubble = b
		lifetime = 0
