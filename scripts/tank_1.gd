extends CharacterBody2D
class_name Tank

@export var hp: int = 20
@export var bullets: int = 10

@export var go_forward: String
@export var backward: String
@export var turn_base_right: String
@export var turn_base_left: String
@export var turn_barrel_right: String
@export var turn_barrel_left: String
@export var fire: String

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var dead = false
var canmove = true
var canshoot = true
var canhurt = true

const BULLET = preload("res://scenes/bullet.tscn")

func _ready() -> void:
	if Global.is_big_map_single:
		$camera.enabled = true

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var forward = Vector2(cos($Base.rotation), sin($Base.rotation))
	
	var direction := Input.get_axis(turn_base_left, turn_base_right)
	if direction:
		$Base.rotation += direction * .05
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_pressed(go_forward):
		position += forward * SPEED * delta
	
	if Input.is_action_pressed(backward):
		position -= forward * SPEED * delta
		
	var bdirection := Input.get_axis(turn_barrel_left, turn_barrel_right)
	
	if bdirection:
		$Spinny.rotation += bdirection * .05
		
	
	
	if Input.is_action_just_pressed(fire):
		if bullets > 0 and canshoot:
			var bullet = BULLET.instantiate()
			
			get_parent().add_child(bullet)
			bullet.global_position = $Spinny/Barrel/bullet_spawn_thing.global_position
			bullet.global_rotation = $Spinny/Barrel/bullet_spawn_thing.global_rotation
			
			$fire_cooldown.start()
			canshoot = false
			bullets -= 1
			
			print("Tank 1 fired")
	move_and_slide()
	
	
	$hp.value = hp
	$bullets.value = bullets
	
	
	if hp <= 0 and !dead:
		dead = true
		explode()
		
		
func hurt() -> void:
	if canhurt:
		print("Tank got hit")
		hp -= 1

func _on_bullet_cooldown_timeout() -> void:
	if bullets < 15:
		bullets += 1
		print("Tank reloaded")


func _on_fire_cooldown_timeout() -> void:
	canshoot = true

func explode() -> void:

	canshoot = false
	canmove = false
	
	$explosion.visible = true
	$dead_anim.play("dead_anim")


func _on_dead_anim_animation_finished(anim_name: StringName) -> void:
	visible = false
	position = Vector2(999, 999)
	

func get_powerup(powerup: Global.POWERUP) -> void:
	match powerup:
		Global.POWERUP.SHIELD:
			
			canhurt = false
			$shield.visible = true
			await get_tree().create_timer(5, false).timeout
			canhurt = true
			$shield.visible = false
		
		Global.POWERUP.SPEED:
			
			pass
