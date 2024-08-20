extends Node

signal unlocked_spell_2
signal unlocked_spell_1
signal unlocked_spell_3_upgrade

var spell_2 := false :
	set(val):
		var prev = spell_2
		spell_2 = val
		if val == true and prev == false:
			unlocked_spell_2.emit()

var spell_1 := false :
	set(val):
		var prev = spell_1
		spell_1 = val
		if val == true and prev == false:
			unlocked_spell_1.emit()

var spell_3_upgrade := false :
	set(val):
		var prev = spell_3_upgrade
		spell_3_upgrade = val
		if val == true and prev == false:
			unlocked_spell_3_upgrade.emit()

func reset():
	spell_1 = false
	spell_2 = false
	spell_3_upgrade = false
