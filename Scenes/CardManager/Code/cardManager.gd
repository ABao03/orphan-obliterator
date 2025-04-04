extends Node # must inherit node to drag and drop nodes? is this why all my @onready stuff was failing?

var cardsData : Dictionary
var cardDataPath = "res://Data/cardData.json"

@onready var heldCardsContainer = $HeldCardsContainer

var currentHeldCardIndexes : Array[int]

func _ready():
	currentHeldCardIndexes = [0, 1, 2]
	cardsData = loadCardDataJson()
	updateCardsInHand()


#region LOAD HAND
func updateCardsInHand():
	for heldCardIndex in currentHeldCardIndexes:
		var thisCardData : Dictionary = cardsData[str(heldCardIndex)]
		var newCard = load("res://Scenes/GenericCard/Code/card.tscn")
		var newCardInstance = newCard.instantiate()
		newCardInstance.initializeCard(thisCardData)
		heldCardsContainer.add_child(newCardInstance)
#endregion


#region LOAD CARD DATA JSON
func loadCardDataJson() -> Dictionary:
	var fileString = FileAccess.get_file_as_string(cardDataPath)
	var jsonData : Dictionary
	if fileString != null:
		jsonData = JSON.parse_string(fileString)
	
	return jsonData
#endregion
