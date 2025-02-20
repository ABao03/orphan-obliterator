class_name EnemyManager
extends Node2D

# Enemy children
var enemyDataPath = "res://Data/enemyData.json"
var enemyAttacksPath = "res://Data/enemyAttacks.json"
var genericEnemyScenePath = "res://Scenes/GenericEnemy/Code/genericEnemy.tscn"

var enemyJsonData : Dictionary
var enemyAttacksData : Dictionary

# Anchors
@onready var AnchorContainer = $AnchorContainer
@onready var closeAnchor = $AnchorContainer/CloseAnchor
@onready var mediumAnchor = $AnchorContainer/MediumAnchor
@onready var farAnchor = $AnchorContainer/FarAnchor
var currentAnchor : Control
var enemyAnchor : Control


func _ready() -> void:
	enemyJsonData = loadEnemyJsonData()
	enemyAttacksData = loadEnemyAttacksJsonData()
	spawnEnemy()


#region ENEMY SPAWNING
func spawnEnemy() -> void:
	var randomEnemyIndex : int = randi_range(0, len(enemyJsonData) - 1)
	var randomEnemyData = enemyJsonData[str(randomEnemyIndex)]
	
	var newEnemy = ResourceLoader.load(genericEnemyScenePath)
	var enemyInstance : GenericEnemy = newEnemy.instantiate()
	enemyInstance.initializeEnemy(randomEnemyData)
	enemyInstance.initializeEnemyAttacks(enemyAttacksData)
	
	enemyAnchor = Control.new()
	enemyAnchor.name = "EnemyAnchor"
	enemyAnchor.size = Vector2(0, 0)
	
	enemyAnchor.add_child(enemyInstance)
	mediumAnchor.add_child(enemyAnchor)
	currentAnchor = mediumAnchor
#endregion


#region CHANGE RANGE
func pushEnemyAway() -> void:
	if currentAnchor == closeAnchor:
		enemyAnchor.reparent(mediumAnchor)
		currentAnchor = mediumAnchor
		
	elif currentAnchor == mediumAnchor:
		enemyAnchor.reparent(farAnchor)
		currentAnchor = farAnchor
	
	centerEnemyAnchor()


func pullEnemyCloser() -> void:
	if currentAnchor == mediumAnchor:
		enemyAnchor.reparent(closeAnchor)
		currentAnchor = closeAnchor
		
	elif currentAnchor == farAnchor:
		enemyAnchor.reparent(mediumAnchor)
		currentAnchor = mediumAnchor
	
	centerEnemyAnchor()
#endregion


#region JSON LOADING
func loadEnemyJsonData() -> Dictionary:
	var fileString = FileAccess.get_file_as_string(enemyDataPath)
	var jsonData : Dictionary
	if fileString != null:
		jsonData = JSON.parse_string(fileString)
	
	return jsonData


func loadEnemyAttacksJsonData() -> Dictionary:
	var fileString = FileAccess.get_file_as_string(enemyAttacksPath)
	var jsonData : Dictionary
	if fileString != null:
		jsonData = JSON.parse_string(fileString)
	
	return jsonData
#endregion


#region CONTROL GUI
func centerEnemyAnchor():
	if currentAnchor == closeAnchor:
		enemyAnchor.global_position = closeAnchor.global_position
	elif currentAnchor == mediumAnchor:
		enemyAnchor.global_position = mediumAnchor.global_position
	elif currentAnchor == farAnchor:
		enemyAnchor.global_position = farAnchor.global_position
#endregion


#region GLOBAL SIGNALS
func _on_tree_entered() -> void:
	GlobalSignal.plusRangeButtonPressed.connect(pushEnemyAway)
	GlobalSignal.minusRangeButtonPressed.connect(pullEnemyCloser)


func _on_tree_exited() -> void:
	GlobalSignal.plusRangeButtonPressed.disconnect(pushEnemyAway)
	GlobalSignal.minusRangeButtonPressed.disconnect(pullEnemyCloser)
#endregion
