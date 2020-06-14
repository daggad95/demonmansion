extends Node

var speed 
var duration 
var entity
var dir
var timer

func _init(entity, dir, speed, duration):
	self.entity = entity
	self.dir = dir
	self.speed = speed
	self.duration = duration
	
	timer = Timer.new()
	timer.connect("timeout", self, "_on_timeout")
	add_child(timer)

func _ready():
	timer.start(duration)
	entity.can_control_movement = false

func _physics_process(delta):
	entity.velocity = dir.normalized() * speed

func _on_timeout():
	entity.can_control_movement = true
	queue_free()
