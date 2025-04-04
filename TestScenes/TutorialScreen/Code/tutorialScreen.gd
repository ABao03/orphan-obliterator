extends Node2D

@onready var tutorialsCanvasLayer = $Tutorial
@onready var tutorialsParent = %Tutorials
var currentTutorialIndex = 0
var currentTutorialScreen


func _ready():
	updateTutorialScreen()


func updateTutorialScreen():
	if currentTutorialScreen != null:
		currentTutorialScreen.visible = false
	
	currentTutorialScreen = tutorialsParent.get_child(currentTutorialIndex)
	if currentTutorialScreen != null:
		currentTutorialScreen.visible = true
	else:
		tutorialsCanvasLayer.visible = false

func _on_button_pressed() -> void:
	currentTutorialIndex += 1
	updateTutorialScreen()
