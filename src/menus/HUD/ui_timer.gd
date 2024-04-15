extends CenterContainer


@onready var hud_logic = $"../../../.."
@onready var timer_bar_texture = $TimerBarTexture

func _ready():
	# Connects signal from time script
	hud_logic.time_progress.connect(_progress_time)


# Updates progress bar time in UI
func _progress_time(value_to_add : int, did_progress : bool) -> void:
	if not did_progress:
		return

# if value in texture bigger than 100, does not update
	if timer_bar_texture.value < 100:
		timer_bar_texture.value = timer_bar_texture.value + value_to_add
