class_name DamageNumbers
extends Marker2D


func displayNumber(damage: int, numberPosition : Vector2):
	# create label
	var number = Label.new()
	number.global_position = numberPosition
	if damage > 0:
		number.text = str(damage)
	else:
		number.text = "MISS"
	number.z_index = 5
	number.label_settings = LabelSettings.new()
	
	# set text properties
	number.label_settings.font_color = "#FFF"
	
	number.label_settings.font_size = 100
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 15
	
	call_deferred("add_child", number)
	
	# run the animation on the text
	await number.resized
	#await magic_number.resized
	number.pivot_offset = Vector2(number.size / 2)
	
	var tween = get_tree().create_tween()
	
	tween.set_parallel(true)
	
	tween.tween_property(
		number, "position:y", number.position.y - 50, 0.25
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		number, "position:y", number.position.y, 0.5
	).set_ease(Tween.EASE_IN).set_delay(0.25)
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.25
	).set_ease(Tween.EASE_IN).set_delay(0.5)
	
	await tween.finished
	#await magic_tween.finished
	number.queue_free()


#region GLOBAL SIGNALS
func _on_tree_entered() -> void:
	GlobalSignal.createDamageNumber.connect(displayNumber)


func _on_tree_exited() -> void:
	GlobalSignal.createDamageNumber.disconnect(displayNumber)
#endregion
