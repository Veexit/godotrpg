extends CharacterBody2D

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true

const SPEED = 300.0
var current_dir = "none"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$AnimatedSprite2D.play("idle_front")


func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	
	if health <= 0:
		player_alive = false
		health = 0
		print("This is the end...")
		$AnimatedSprite2D.play("dead")
		$attack_cd.start()
		#self.queue_free()
	
func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = SPEED
		velocity.y
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -SPEED
		velocity.y
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = SPEED
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -SPEED		
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()

func play_anim(movement):
	var anim = $AnimatedSprite2D
	
	if current_dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_right")
		elif movement == 0:
			anim.play("idle_right")
	if current_dir == "left":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_left")
		elif movement == 0:
			anim.play("idle_left")
	if current_dir == "down":
		anim.flip_h = true
		if movement == 1:
			anim.play("walk_front")
		elif movement == 0:
			anim.play("idle_front")
	if current_dir == "up":
		anim.flip_h = true
		if movement == 1:
			anim.play("walk_rear")
		elif movement == 0:
			anim.play("idle_rear")

func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true


func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown:
		health = health - 20
		enemy_attack_cooldown = false
		$attack_cd.start()
		print(health)

func _on_attack_cd_timeout():
	enemy_attack_cooldown = true
