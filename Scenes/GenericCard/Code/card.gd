class_name Card
extends Button

var cardIconsPath = "res://Scenes/GenericCard/Assets/"
var cardDataResource : CardData = CardData.new()

var currentCooldown : int
var cooldownBar : ProgressBar
var cardUsed : bool = false

var readyColor = Color(255, 255, 255)
var rechargingColor = Color(128, 128, 128)


#region INITIALIZE CARD
func initializeCard(cardData : Dictionary):
	cardDataResource.cardName = cardData["cardName"]
	cardDataResource.cardRange = cardData["cardRange"]
	cardDataResource.cardCooldown = int(cardData["cardCooldown"])
	cardDataResource.cardDamage = cardData["cardDamage"]
	
	initializeCardIcon()
	initializeCardCooldownBar()


func initializeCardIcon():
	var cardIcon = $CardIcon
	cardIcon.texture = load(cardIconsPath + cardDataResource.cardName.to_lower() + ".png")
#endregion


#region CARD COOLDOWN
func initializeCardCooldownBar():
	cooldownBar = $CooldownBar
	
	cooldownBar.max_value = cardDataResource.cardCooldown
	resetCooldown()


func incrementCardCooldown():
	cooldownBar = $CooldownBar
	
	if cooldownBar.value < cooldownBar.max_value:
		currentCooldown += 1
		cooldownBar.value = currentCooldown


func resetCooldown():
	currentCooldown = 0
	cooldownBar.value = currentCooldown
#endregion


#region TURN ENDED
func turnEnded():
	incrementCardCooldown()
#endregion


#region CARD PRESSED
func _on_pressed() -> void:
	if currentCooldown == cooldownBar.max_value:
		GlobalSignal.damageEnemy.emit(cardDataResource)
		GlobalSignal.endedTurn.emit()
		resetCooldown()
	else:
		pass
#endregion


#region CARD HOVERED
func _on_mouse_entered() -> void:
	GlobalSignal.showHoverMenu.emit(cardDataResource)


func _on_mouse_exited() -> void:
	GlobalSignal.hideHoverMenu.emit()
#endregion


#region GLOBAL SIGNALS
func _on_tree_entered() -> void:
	GlobalSignal.endedTurn.connect(turnEnded)


func _on_tree_exited() -> void:
	GlobalSignal.endedTurn.disconnect(turnEnded)
#endregion
