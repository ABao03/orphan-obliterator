extends Control

var currentEnemyAttackResource : EnemyAttack

var attackIcon : TextureRect

var attackForecastAssetPath = "res://Scenes/AttackForecast/Assets/"


#region UPDATE TEXTURE
# called from genericEnemy
func setAttackTexture(enemyAttackResource : EnemyAttack):
	attackIcon = $AttackIcon
	currentEnemyAttackResource = enemyAttackResource
	
	if enemyAttackResource == null:
		attackIcon.texture = null
	else:
		var attackRange = enemyAttackResource.attackRange
		
		if attackRange == 0:
			attackIcon.texture = load(attackForecastAssetPath + "close.png")
		elif attackRange == 1:
			attackIcon.texture = load(attackForecastAssetPath + "medium.png")
		elif attackRange == 2:
			attackIcon.texture = load(attackForecastAssetPath + "far.png")
#endregion


#region MOUSE HOVER
func _on_mouse_entered() -> void:
	GlobalSignal.showHoverMenu.emit(currentEnemyAttackResource)


func _on_mouse_exited() -> void:
	GlobalSignal.hideHoverMenu.emit()
#endregion


#region GLOBAL SIGNALS
func _on_tree_entered() -> void:
	GlobalSignal.enemyAttackDeclared.connect(setAttackTexture)


func _on_tree_exited() -> void:
	GlobalSignal.enemyAttackDeclared.disconnect(setAttackTexture)
#endregion
