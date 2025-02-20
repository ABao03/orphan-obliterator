extends Control

var currentPlayerRange : int

var attackForecastAssetPath = "res://Scenes/AttackForecast/Assets/"

#region UPDATE TEXTURE
func setAttackTexture(enemyAttackResource : EnemyAttack):
	var attackIcon = $AttackIcon
	var attackRange = enemyAttackResource.attackRange
	
	if attackRange == 0:
		attackIcon.texture = load(attackForecastAssetPath + "close.png")
	elif attackRange == 1:
		attackIcon.texture = load(attackForecastAssetPath + "medium.png")
	elif attackRange == 2:
		attackIcon.texture = load(attackForecastAssetPath + "far.png")
#endregion


#region GLOBAL SIGNALS
func _on_tree_entered() -> void:
	GlobalSignal.enemyAttackDeclared.connect(setAttackTexture)


func _on_tree_exited() -> void:
	GlobalSignal.enemyAttackDeclared.disconnect(setAttackTexture)
#endregion
