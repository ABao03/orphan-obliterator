extends Panel

@onready var hoverMenu = $"."
@onready var viewportRect = get_viewport_rect()

@onready var nameLabel = $NameLabel
@onready var rangeLabel = $InfoBox/RangeLabel
@onready var rangeIndicatorContainer = $InfoBox/RangeIndicatorContainer
@onready var cooldownLabel = $InfoBox/AttackStatsGrid/CooldownLabel
@onready var cooldownAmountLabel = $InfoBox/AttackStatsGrid/CooldownAmountLabel
@onready var weaknessLabel = $InfoBox/AttackStatsGrid/WeaknessLabel
@onready var weaknessValueLabel = $InfoBox/AttackStatsGrid/WeaknessValueLabel
@onready var damageLabel = $InfoBox/AttackStatsGrid/DamageLabel
@onready var damageAmountLabel = $InfoBox/AttackStatsGrid/DamageAmountLabel

var mousePosition : Vector2
var newPosition : Vector2


#region MOVE MENU AROUND
func _process(_delta: float):
	if visible == true:
		mousePosition = get_viewport().get_mouse_position()
		newPosition = mousePosition + Vector2(40, 40)
		
		newPosition.x = clamp(newPosition.x, 0, viewportRect.size.x - hoverMenu.size.x - 80)
		newPosition.y = clamp(newPosition.y, 0, viewportRect.size.y - hoverMenu.size.y)
		
		hoverMenu.global_position = newPosition
#endregion


#region SET HOVER MENU LABELS
func setPlayerCardHoverMenu(cardDataResource : CardData):
	nameLabel.text = cardDataResource.cardName
	
	setRangeIndicator(cardDataResource.cardRange)
	
	cooldownLabel.visible = true
	cooldownAmountLabel.visible = true
	weaknessLabel.visible = false
	weaknessValueLabel.visible = false
	
	cooldownAmountLabel.text = str(cardDataResource.cardCooldown)
	
	damageAmountLabel.text = str(cardDataResource.cardDamage)


func setEnemyAttackHoverMenu(enemyAttackResource : EnemyAttack):
	nameLabel.text = enemyAttackResource.attackName
	
	setRangeIndicator(enemyAttackResource.attackRange)
	
	cooldownLabel.visible = false
	cooldownAmountLabel.visible = false
	weaknessLabel.visible = true
	weaknessValueLabel.visible = true
	
	setWeaknessValue(enemyAttackResource.attackWeakRange)
	
	damageAmountLabel.text = str(enemyAttackResource.attackDamage)


func setRangeIndicator(specifiedRange : int):
	var index = 2
	for rangeRect in rangeIndicatorContainer.get_children():
		if index == specifiedRange:
			rangeRect.color = Color(0,255,0)
		else:
			rangeRect.color = Color(255,255,255)
		
		index -= 1


func setWeaknessValue(weakRange : int):
	if weakRange == 0:
		weaknessValueLabel.text = "CLOSE"
	elif weakRange == 1:
		weaknessValueLabel.text = "MEDIUM"
	elif weakRange == 2:
		weaknessValueLabel.text = "FAR"
#endregion


#region TOGGLE HOVER MENU VISIBILITY
func _ready():
	hideMenu()


func showMenu(resource):
	visible = true
	
	if resource is EnemyAttack:
		setEnemyAttackHoverMenu(resource)
	elif resource is CardData:
		setPlayerCardHoverMenu(resource)


func hideMenu():
	visible = false
#endregion


#region GLOBAL SIGNALS
func _on_tree_entered() -> void:
	GlobalSignal.showHoverMenu.connect(showMenu)
	GlobalSignal.hideHoverMenu.connect(hideMenu)


func _on_tree_exited() -> void:
	GlobalSignal.showHoverMenu.disconnect(showMenu)
	GlobalSignal.hideHoverMenu.disconnect(hideMenu)
#endregion
