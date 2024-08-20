class_name Chest
extends TextBoxInteractable

signal unlocked

@export_flags("spell_2:1", "spell_1:2", "spell_3_upgrade:4")
var unlock: int

func _on_player_interaction(area: Area2D):
	if area == self:
		%"Audio Open".play()
		$Texture.play("open")
		$Collision.disabled = true
		Unlocks.spell_2 = Unlocks.spell_2 or unlock & 1 != 0
		Unlocks.spell_1 = Unlocks.spell_1 or unlock & 2 != 0
		Unlocks.spell_3_upgrade = Unlocks.spell_3_upgrade or unlock & 4 != 0
		unlocked.emit()
