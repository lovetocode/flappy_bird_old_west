extends CanvasLayer

onready var start_message = $startMenu/startMessage
onready var start_menu = $startMenu
onready var tween = $Tween
onready var game_over_menu = $GameOverMenu
onready var score_label = $GameOverMenu/VBoxContainer/Score_label
onready var highscore__label = $GameOverMenu/VBoxContainer/Highscore_Label
onready var restart = $GameOverMenu/VBoxContainer/Restart


signal gameStarted
var started = false

func _input(event):
	if event.is_action_pressed("flap") && !started:
		emit_signal("gameStarted")
		started = true
		tween.interpolate_property(start_message, "modulate:a", 1, 0, 0.5)
		tween.start()
		
func _init_gameOver(score, highScore):
	score_label.text = "Score: " + str(score)
	highscore__label.text = "Best: " + str(highScore)
	game_over_menu.visible = true

func _on_Restart_pressed():
	get_tree().reload_current_scene()
