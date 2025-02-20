class_name Player
extends Node2D

var playerHP : int = 100
var playerRange : int = 1


func _ready() -> void:
	GlobalSignal.sendPlayerRange.emit(playerRange)


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


func _on_tree_exited() -> void:
	GlobalSignal.requestPlayerRange.disconnect(sendPlayerRange)
	
	GlobalSignal.plusRangeButtonPressed.disconnect(incrementRange)
	GlobalSignal.minusRangeButtonPressed.disconnect(decrementRange)
#endregion
