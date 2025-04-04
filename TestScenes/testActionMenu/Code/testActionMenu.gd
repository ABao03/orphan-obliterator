class_name ActionMenu
extends Control

var currentPlayerRange : int


#region RANGE BUTTONS PRESSED
func _on_increase_range_button_pressed() -> void:
	GlobalSignal.plusRangeButtonPressed.emit()
	GlobalSignal.endedTurn.emit()
	changeActionMenuRangeLabel()


func _on_decrease_range_button_pressed() -> void:
	GlobalSignal.minusRangeButtonPressed.emit()
	GlobalSignal.endedTurn.emit()
	changeActionMenuRangeLabel()
#endregion


#region UPDATE RANGE LABEL
func _ready():
	changeActionMenuRangeLabel()


func changeActionMenuRangeLabel() -> void:
	var rangeLabel = $RangeManager/RangeLabel
	GlobalSignal.requestPlayerRange.emit()
	
	if currentPlayerRange == 0:
		rangeLabel.text = "CLOSE"
	elif currentPlayerRange == 1:
		rangeLabel.text = "MEDIUM"
	elif currentPlayerRange == 2:
		rangeLabel.text = "FAR"
#endregion


#region GET PLAYER RANGE
# called from player ONLY
func receivePlayerRange(playerRange : int):
	currentPlayerRange = playerRange
#endregion


#region GLOBAL SIGNALS
func _on_tree_entered() -> void:
	GlobalSignal.sendPlayerRange.connect(receivePlayerRange)


func _on_tree_exited() -> void:
	GlobalSignal.sendPlayerRange.disconnect(receivePlayerRange)
#endregion
