extends Control

@onready var master_volume_label = %MasterVolumeLabel
@onready var sound_effect_volume_label = %SoundEffectVolumeLabel
@onready var music_volume_label = %MusicVolumeLabel
@onready var ambience_volume_label = %AmbienceVolumeLabel

@onready var master_volume_slider = $VBoxContainer/MasterVolumeSlider/MasterVolumeSlider
@onready var sound_effect_volume_slider = $VBoxContainer/SoundEffectSlider/SoundEffectVolumeSlider
@onready var music_volume_slider = $VBoxContainer/MusicSlider/musicVolumeSlider
@onready var ambience_volume_slider = $VBoxContainer/AmbienceSlider/AmbienceVolumeSlider







func _on_master_volume_slider_value_changed(value):
	OptionsManager.master_volume = value
	UpdateVolumeVisuals(value, master_volume_label, "Master")

func _on_sound_effect_volume_slider_value_changed(value):
	OptionsManager.sound_effect_volume = value
	UpdateVolumeVisuals(value, sound_effect_volume_label, "SFX")

func _on_music_volume_slider_value_changed(value):
	OptionsManager.music_volume = value
	UpdateVolumeVisuals(value, music_volume_label, "Music")

func _on_ambience_volume_slider_value_changed(value):
	OptionsManager.ambience_volume = value
	UpdateVolumeVisuals(value, ambience_volume_label, "Ambience")



func UpdateVolumeVisuals(volume_value, volume_label, label_text):
	volume_label.text = str(label_text, ": ", volume_value, "%")





func UpdateSettingsVisuals():
	master_volume_slider.value = OptionsManager.master_volume
	master_volume_slider.actual_value = OptionsManager.master_volume
	UpdateVolumeVisuals(OptionsManager.master_volume, master_volume_label, "Master")
	
	sound_effect_volume_slider.value = OptionsManager.sound_effect_volume
	sound_effect_volume_slider.actual_value = OptionsManager.sound_effect_volume
	UpdateVolumeVisuals(OptionsManager.sound_effect_volume, sound_effect_volume_label, "SFX")
	
	music_volume_slider.value = OptionsManager.music_volume
	music_volume_slider.actual_value = OptionsManager.music_volume
	UpdateVolumeVisuals(OptionsManager.music_volume, music_volume_label, "Music")
	
	ambience_volume_slider.value = OptionsManager.ambience_volume
	ambience_volume_slider.actual_value = OptionsManager.ambience_volume
	UpdateVolumeVisuals(OptionsManager.ambience_volume, ambience_volume_label, "Ambience")


