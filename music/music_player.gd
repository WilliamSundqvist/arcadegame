extends AudioStreamPlayer

#const music = preload("res://music/INSERT MUSIC HERE.wav") #enable this when we have music
#In the musicplayernode settings the Music Bus is chosen (For changing music volume)

func _ready() -> void:
	print("Music ready")
	#play_music(music)

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	stream = music
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
