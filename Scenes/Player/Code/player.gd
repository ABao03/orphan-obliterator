class_name Player
extends Node2D

var playerHP : int = 100
var maxPlayerHP : int = 100
var playerRange : int = 1

@onready var sprite : Sprite2D = $Sprite2D
@onready var healthBar : ProgressBar = $HPBar


func _ready() -> void:
	GlobalSignal.sendPlayerRange.emit(playerRange)


#region DAMAGE PLAYER
func damagePlayer(enemyAttackResource : EnemyAttack):
	var damageAmount = returnRealDamage(enemyAttackResource)
	
	playerHP -= damageAmount
	updateHealthBar()
	
	GlobalSignal.createDamageNumber.emit(damageAmount, sprite.global_position)


func returnRealDamage(enemyAttackResource : EnemyAttack) -> int:
	if playerRange > enemyAttackResource.attackRange:
		return 0
	elif playerRange == enemyAttackResource.attackRange:
		return enemyAttackResource.attackDamage
	else:
		return floori(enemyAttackResource.attackDamage/4)
#endregion


#region HP BAR
func updateHealthBar():
	healthBar.value = playerHP
#endregion


#region RANGE GETTER + SETTERS
# sent to actionMenu, genericEnemy
func sendPlayerRange() -> void:
	GlobalSignal.sendPlayerRange.emit(playerRange)


# called from actionMenu
func incrementRange() -> void:
	if playerRange < 2:
		playerRange += 1


# called from actionMenu
func decrementRange() -> void:
	if playerRange > 0:
		playerRange -= 1
#endregion


#region GLOBAL SIGNALS
func _on_tree_entered() -> void:
	GlobalSignal.requestPlayerRange.connect(sendPlayerRange)
	
	GlobalSignal.plusRangeButtonPressed.connect(incrementRange)
	GlobalSignal.minusRangeButtonPressed.connect(decrementRange)
	
	GlobalSignal.damagePlayer.connect(damagePlayer)


func _on_tree_exited() -> void:
	GlobalSignal.requestPlayerRange.disconnect(sendPlayerRange)
	
	GlobalSignal.plusRangeButtonPressed.disconnect(incrementRange)
	GlobalSignal.minusRangeButtonPressed.disconnect(decrementRange)
	
	GlobalSignal.damagePlayer.disconnect(damagePlayer)
#endregion
