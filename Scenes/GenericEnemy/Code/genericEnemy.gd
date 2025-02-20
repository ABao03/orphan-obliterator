class_name GenericEnemy
extends Node2D

var currentPlayerRange : int

var enemyStatsResource : EnemyStats
var enemyRange : int
var enemyAttacks : Array[EnemyAttack]
var enemySprite : Sprite2D

var upcomingEnemyAttack : EnemyAttack

var enemyTexturesPath = "res://Scenes/EnemyManager/Assets/"

func _ready():
	enemyDeclareAttack()


#region INITIALIZE ENEMY STAT, ATTACK RESOURCES
func initializeEnemy(enemyData : Dictionary):
	enemyStatsResource = EnemyStats.new()
	enemyStatsResource.enemyName = enemyData["enemyName"]
	enemyStatsResource.enemyHP = enemyData["enemyHP"]
	
	# get enemy range by requesting it from the player
	GlobalSignal.requestPlayerRange.emit()
	enemyRange = currentPlayerRange
	
	enemyStatsResource.enemyAttackIndexes = enemyData["enemyAttacks"]
	
	setSpriteTexture(enemyTexturesPath + enemyStatsResource.enemyName.to_lower() + ".png")


func initializeEnemyAttacks(enemyAttacksData : Dictionary):
	for attackIndex in enemyStatsResource.enemyAttackIndexes:
		var enemyAttackData = enemyAttacksData[str(attackIndex)]
		
		var enemyAttackResource = EnemyAttack.new()
		enemyAttackResource.attackName = enemyAttackData["attackName"]
		enemyAttackResource.attackRange = enemyAttackData["attackRange"]
		enemyAttackResource.attackDamage = enemyAttackData["attackDamage"]
		enemyAttacks.append(enemyAttackResource)
#endregion


#region ENEMY ATTACK
func enemyDeclareAttack():
	var randomEnemyAttackIndex = randi_range(0, len(enemyAttacks)-1)
	var randomlySelectedAttack : EnemyAttack = enemyAttacks[randomEnemyAttackIndex]
	
	upcomingEnemyAttack = randomlySelectedAttack
	
	GlobalSignal.enemyAttackDeclared.emit(randomlySelectedAttack)


func enemyAttack():
	
	
	upcomingEnemyAttack = null
#endregion


#region SET SPRITE TEXTURE
func setSpriteTexture(texturePath : String):
	enemySprite = $Sprite2D
	var texture = load(texturePath)
	enemySprite.texture = texture
#endregion


#region MESSING WITH ENEMY RANGE
func updateSpriteScale():
	if enemyRange == 0:
		enemySprite.scale = Vector2(0.8, 0.8)
	elif enemyRange == 1:
		enemySprite.scale = Vector2(1, 1)
	elif enemyRange == 2:
		enemySprite.scale = Vector2(1.2, 1.2)


# called from actionMenu
func pushEnemyAway():
	if enemyRange < 2:
		enemyRange += 1
	updateSpriteScale()


# called from actionMenu
func pullEnemyCloser():
	if enemyRange > 0:
		enemyRange -= 1
	updateSpriteScale()


# called from player ONLY
func receivePlayerRange(playerRange : int):
	currentPlayerRange = playerRange
#endregion


#region GET PLAYER RANGE
func changeActionMenuRangeLabel(playerRange : int):
	var rangeLabel = $RangeManager/RangeLabel
	
	if playerRange == 0:
		rangeLabel.text = "CLOSE"
	elif playerRange == 1:
		rangeLabel.text = "MEDIUM"
	elif playerRange == 2:
		rangeLabel.text = "FAR"
#endregion


#region GLOBAL SIGNALS
func _on_tree_entered() -> void:
	GlobalSignal.sendPlayerRange.connect(receivePlayerRange)
	
	GlobalSignal.plusRangeButtonPressed.connect(pullEnemyCloser)
	GlobalSignal.minusRangeButtonPressed.connect(pushEnemyAway)


func _on_tree_exited() -> void:
	GlobalSignal.sendPlayerRange.disconnect(receivePlayerRange)
	
	GlobalSignal.plusRangeButtonPressed.disconnect(pullEnemyCloser)
	GlobalSignal.minusRangeButtonPressed.disconnect(pushEnemyAway)
#endregion
