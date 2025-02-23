# Made with love by JuanCarlos "Juanky" Aguilera
# Github Repo: https://github.com/JCAguilera/godot3-drag-and-drop

extends Node

var sprites = []
var top_sprite = null

@onready var status = $Status
@onready var spriteList = $SpriteList

func _input(_event):
	if Input.is_action_just_pressed("left_click"): #When we click
		top_sprite = _top_sprite() #Get the sprite on top (largest z_index)
		if top_sprite: #If there's a sprite
			top_sprite.dragging = true #We set dragging to true
	if Input.is_action_just_released("left_click"): #When we release
		if top_sprite:
			top_sprite.dragging = false #Set dragging to false
			top_sprite = null #Top sprite to null
	_print_status()

class SpritesSorter: #Custom sorter
	static func z_index(a, b): #Sort by z_index
		if a.z_index > b.z_index:
			return true
		return false

func _add_sprite(sprt): #Add sprite to list
	if not sprites.find(sprt) == -1: #If sprite exists
		return #Do nothing
	sprites.append(sprt) #Add sprite to list

func _remove_sprite(sprt): #Remove sprite from list
	var idx = sprites.find(sprt) #find the index
	sprites.remove_at(idx) #remove

func _top_sprite(): #Get the top sprite
	if len(sprites) == 0: #If the list is empty
		return null
	sprites.sort_custom(Callable(SpritesSorter, "z_index")) #Sort by z_index
	return sprites[0] #Return top sprite

#Print status
func _print_status():
	var aux_sprt = []
	var aux_sprt_can_drag = []
	for i in sprites:
		aux_sprt.append(i.z_index)
	for i in sprites:
		aux_sprt_can_drag.append(i.dragging)
	if not top_sprite == null:
		status.text = "Top: " + str(top_sprite.z_index) + " - Dragging: " + str(top_sprite.dragging)
		spriteList.text = "Sprites: " + str(aux_sprt) + " - Can drag: " + str(aux_sprt_can_drag)
	else:
		status.text = "Top: null - Dragging: False"
		spriteList.text = "Sprites: " + str(aux_sprt) + " - Can drag: " + str(aux_sprt_can_drag)
