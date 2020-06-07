extends Node

const speed = 1000
const duration = 0.1
var entity
var dir
var timer

func _init(entity, dir):
	self.entity = entity
	self.dir = dir
	
	timer = Timer.new()
	timer.connect("timeout", self, "_on_timeout")
	add_child(timer)

func _ready():
	timer.start(duration)
	entity.can_move = false

func _physics_process(delta):
	entity.move_and_slide(dir * speed * delta)

func _on_timeout():
	entity.can_move = true
	queue_free()
