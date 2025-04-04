class_name GenericEnemy
extends Node2D

var currentPlayerRange : int

var isStunned : bool = false
var stunnedTurnCounter : int = 0

var enemyStatsResource : EnemyStats
var enemyAttacks : Array[EnemyAttack]
var enemySprite : Sprite2D
var stunnedSprite : Sprite2D

var upcomingEnemyAttack : EnemyAttack

@onready var sprite : Sprite2D = $Sprite2D

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
	
	enemyStatsResource.enemyAttackIndexes = enemyData["enemyAttacks"]
	
	setSpriteTexture(enemyTexturesPath + enemyStatsResource.enemyName.to_lower() + ".png")


# called from enemyManager
func initializeEnemyAttacks(enemyAttacksData : Dictionary):
	for attackIndex in enemyStatsResource.enemyAttackIndexes:
		var enemyAttackData = enemyAttacksData[str(attackIndex)]
		
		var enemyAttackResource = EnemyAttack.new()
		enemyAttackResource.attackName = enemyAttackData["attackName"]
		enemyAttackResource.attackRange = enemyAttackData["attackRange"]
		enemyAttackResource.attackWeakRange = enemyAttackData["attackWeakRange"]
		enemyAttackResource.attackDamage = enemyAttackData["attackDamage"]
		enemyAttacks.append(enemyAttackResource)
#endregion


#region TURN ENDED
func turnEnded():
	if isStunned == false:
		enemyPerformsAttack()
	elif isStunned == true:
		if stunnedTurnCounter == 0:
			stunnedTurnCounter += 1
		elif stunnedTurnCounter == 1:
			unstunEnemy()
			enemyDeclareAttack()
#endregion


#region ENEMY ATTACK
func enemyDeclareAttack():
	var randomEnemyAttackIndex = randi_range(0, len(enemyAttacks)-1)
	var randomlySelectedAttack : EnemyAttack = enemyAttacks[randomEnemyAttackIndex]
	
	upcomingEnemyAttack = randomlySelectedAttack
	
	GlobalSignal.enemyAttackDeclared.emit(randomlySelectedAttack)


func enemyPerformsAttack():
	GlobalSignal.damagePlayer.emit(upcomingEnemyAttack)
	
	upcomingEnemyAttack = null
	
	enemyDeclareAttack()
#endregion


#region DAMAGE ENEMY
func damageEnemy(cardDataResource : CardData):
	var damageAmount = returnRealDamage(cardDataResource)
	
	if damageAmount > 0:
		checkIfWeaknessWasHit()
	
	GlobalSignal.createDamageNumber.emit(damageAmount, sprite.global_position)
	enemyStatsResource.enemyHP -= damageAmount
	
	if enemyStatsResource.enemyHP <= 0:
		enemyDead()


func checkIfWeaknessWasHit():
	if currentPlayerRange == upcomingEnemyAttack.attackWeakRange:
		stunEnemy()
		GlobalSignal.enemyAttackDeclared.emit(null)


func returnRealDamage(cardDataResource : CardData) -> int:
	if currentPlayerRange > cardDataResource.cardRange:
		return 0
	elif currentPlayerRange == cardDataResource.cardRange:
		return cardDataResource.cardDamage
	else:
		return floori(cardDataResource.cardDamage/4)


func enemyDead():
	queue_free()
#endregion


#region SET SPRITE TEXTURE
func setSpriteTexture(texturePath : String):
	enemySprite = $Sprite2D
	stunnedSprite = $StunnedSprite
	var texture = load(texturePath)
	enemySprite.texture = texture


func stunEnemy():
	isStunned = true
	stunnedSprite.visible = true


func unstunEnemy():
	stunnedTurnCounter = 0
	isStunned = false
	stunnedSprite.visible = false
#endregion


#region MESSING WITH ENEMY RANGE
func updateSpriteScale():
	if currentPlayerRange == 0:
		enemySprite.scale = Vector2(1.2, 1.2)
		stunnedSprite.scale = Vector2(0.6, 0.6)
	elif currentPlayerRange == 1:
		enemySprite.scale = Vector2(1, 1)
		stunnedSprite.scale = Vector2(0.5, 0.5)
	elif currentPlayerRange == 2:
		enemySprite.scale = Vector2(0.8, 0.8)
		stunnedSprite.scale = Vector2(0.3, 0.3)


# called from actionMenu
func pushEnemyAway():
	if currentPlayerRange < 2:
		currentPlayerRange += 1
	updateSpriteScale()


# called from actionMenu
func pullEnemyCloser():
	if currentPlayerRange > 0:
		currentPlayerRange -= 1
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
	
	GlobalSignal.plusRangeButtonPressed.connect(pushEnemyAway)
	GlobalSignal.minusRangeButtonPressed.connect(pullEnemyCloser)
	
	GlobalSignal.damageEnemy.connect(damageEnemy)
	GlobalSignal.endedTurn.connect(turnEnded)


func _on_tree_exited() -> void:
	GlobalSignal.sendPlayerRange.disconnect(receivePlayerRange)
	
	GlobalSignal.plusRangeButtonPressed.disconnect(pushEnemyAway)
	GlobalSignal.minusRangeButtonPressed.disconnect(pullEnemyCloser)
	
	GlobalSignal.damageEnemy.disconnect(damageEnemy)
	GlobalSignal.endedTurn.disconnect(turnEnded)
#endregion
