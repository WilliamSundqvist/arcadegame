extends AudioStreamPlayer

const music = preload("res://music/bouncybrew.wav") #enable this when we have music
#In the musicplayernode settings the Music Bus is chosen (For changing music volume)

func _ready() -> void:
	_play_music(music)

func _play_music(new_music: AudioStream, volume = 0.0):
	if stream == new_music:
		return
	stream = new_music
	volume_db = volume
	play()

#func play_music(music: AudioStream): #enable this when we have music
#	_play_music(music)

func _on_finished() -> void:
	stream_paused = false
	play(0)
	
func pause():
	playing = false
	stream_paused = true
