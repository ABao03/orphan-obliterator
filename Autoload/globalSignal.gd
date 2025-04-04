extends Node

signal requestPlayerRange
signal sendPlayerRange(currentRange : int)

signal enemyAttackDeclared(enemyAttack : EnemyAttack)

signal damagePlayer(enemyAttackResource : EnemyAttack)
signal damageEnemy(cardDataResource : CardData)
signal endedTurn

signal plusRangeButtonPressed
signal minusRangeButtonPressed

signal showHoverMenu(resource)
signal hideHoverMenu

signal createDamageNumber(damage : int, numberPosition : Vector2)
