extends CharacterBody2D
class_name MultiplayerTank

@export var hp: int = 20
@export var bullets: int = 10

@onready var username: Label = $username

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var dead = false
var canmove = true
var canshoot = true

const BULLET = preload("res://scenes/bullet_multiplaer.tscn")

func _enter_tree() -> void:
	var uid = name.to_int()
	
	set_multiplayer_authority(uid)

func _ready() -> void:
	if !is_multiplayer_authority(): return
	
	username.text = Global.username

func _physics_process(delta: float) -> void:
	
	if !is_multiplayer_authority(): return
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var forward = Vector2(cos($Base.rotation), sin($Base.rotation))
	var direction := Input.get_axis("1tleft", "1tright")
	
	if canmove:
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
		if bullets > 0 and canshoot:
			spawn_bullet.rpc_id(1, $Spinny/Barrel/bullet_spawn_thing.global_position, $Spinny/Barrel/bullet_spawn_thing.global_rotation)
			
			$fire_cooldown.start()
			canshoot = false
			bullets -= 1
			
			print("Tank fired")
	move_and_slide()
	
	$hp.value = hp
	$bullets.value = bullets
	
	if hp <= 0 and !dead:
		dead = true
		explode()


@rpc("any_peer", "call_local") 
func spawn_bullet(position: Vector2, rotation: float):
	var bullet = BULLET.instantiate()
			
	get_parent().add_child(bullet, true)
	bullet.global_position = position
	bullet.global_rotation = rotation

@rpc("any_peer", "call_local")
func hurt() -> void:
	if !is_multiplayer_authority(): return
	
	print("Tank got hit")
	hp -= 1

func _on_bullet_cooldown_timeout() -> void:
	if bullets < 15:
		bullets += 1
		print("Tank reloaded")


func _on_fire_cooldown_timeout() -> void:
	canshoot = true

@rpc("any_peer", "call_local")
func server_set_position(given_position: Vector2) -> void:
	position = given_position 

func explode() -> void:

	canshoot = false
	canmove = false
	
	$explosion.visible = true
	$dead_anim.play("dead_anim")


func _on_dead_anim_animation_finished(anim_name: StringName) -> void:
	if !is_multiplayer_authority(): return
	
	visible = false
	position = Vector2(999, 999)
