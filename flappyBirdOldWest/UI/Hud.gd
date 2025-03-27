extends CanvasLayer

onready var score__label = $score_Label

func update_score(new_score):
	score__label.text = str(new_score)
	
