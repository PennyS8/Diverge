extends Node2D

@onready var chem_inventory = %ChemInventory

func _ready() -> void:
	reset_lab()

func reset_lab():
	chem_inventory.delete_items()
