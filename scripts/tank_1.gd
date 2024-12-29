extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var canshoot = true

const BULLET = preload("res://scenes/bullet.tscn")

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var forward = Vector2(cos($Base.rotation), sin($Base.rotation))
	var direction := Input.get_axis("1tleft", "1tright")
	if direction:
		$Base.rotation += direction * .05
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_pressed("1forward"):
		position += forward * SPEED * delta
	
	if Input.is_action_pressed("1backward"):
		position -= forward * SPEED * delta
		
	var bdirection := Input.get_axis("1tbleft", "1tbright")
	
	if bdirection:
		$Spinny.rotation += bdirection * .05
		
	
	
	if Input.is_action_just_pressed("1fire"):
		if Global.bullets1 > 0 and canshoot:
			var bullet = BULLET.instantiate()
			
			get_parent().add_child(bullet)
			bullet.global_position = $Spinny/Barrel/bullet_spawn_thing.global_position
			bullet.global_rotation = $Spinny/Barrel/bullet_spawn_thing.global_rotation
			
			$fire_cooldown.start()
			canshoot = false
			Global.bullets1 -= 1
			
			print("Tank 1 fired")
	move_and_slide()

func hurt1() -> void:
	print("Tank 1 got hit")
	Global.hp1 -= 1

func _on_bullet_cooldown_timeout() -> void:
	if Global.bullets1 < 15:
		Global.bullets1 += 1
		print("Tank 1 reloaded")


func _on_fire_cooldown_timeout() -> void:
	canshoot = true
