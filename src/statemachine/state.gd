class_name State extends Node

var parent: Node2D


func enter(): # What the state does when it is entered
	pass

func exit(): # What the state does when it is exited
	pass

func process_input(_event: InputEvent) -> State: # Handles input events
	return null

func process_physics(_delta) -> State: # Updates every physics tick
	return null

func process(_delta) -> State: # Updates every frame
	return null
