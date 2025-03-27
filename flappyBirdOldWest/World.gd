extends Node2D

onready var hud = $Hud
onready var obstacle_spawner = $ObstacleSpawner
onready var ground = $Ground
onready var menu_layer = $MenuLayer

var score = 0 setget set_score
var highScore = 0

const save_file_path = "user://savedata.save"

func _ready():
	obstacle_spawner.connect("obstacleCreated", self, "_on_obstacleCreated")
	load_highscore()

func new_game():
	self.score = 0
	obstacle_spawner.start()

func set_score(new_score):
	score = new_score
	hud.update_score(score)
	
func player_score():
	self.score += 1
	
func _on_obstacleCreated(obs):
	obs.connect("score", self, "player_score")
	
func _on_DeathZone_body_entered(body):
	if body is Player:
		if body.has_method("die"):
			body.die()

func _on_Player_died():
	game_over()
	
func game_over():
	obstacle_spawner.stop()
	ground.get_node("AnimationPlayer").stop()
	get_tree().call_group("obstacles" ,"set_physics_process", false)
	
	if highScore < score:
		highScore = score
		save_highscore()
	
	menu_layer._init_gameOver(score, highScore)
	
	
func _on_MenuLayer_gameStarted():
	new_game()
	
func save_highscore():
	var save_data = File.new()
	save_data.open(save_file_path, File.WRITE)
	save_data.store_var(highScore)
	save_data.close()
	
func load_highscore():
	var save_data = File.new()
	if save_data.file_exists(save_file_path):
		save_data.open(save_file_path, File.READ)
		highScore = save_data.get_var()
		save_data.close()
