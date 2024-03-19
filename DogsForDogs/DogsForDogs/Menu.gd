extends Control

func _on_Player_pressed():
	get_tree().change_scene_to_file("res://Game.tscn")


func _on_Options_pressed():
	get_tree().change_scene_to_file("res://OptionsMenu.tscn")


func _on_Quit_pressed():
	get_tree().quit()
