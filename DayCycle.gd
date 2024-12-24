extends Node2D

const  MINUTES_PER_DAY = 1440
const MINUTES_PER_HOUR = 60
const INGAME_TO_REAL_MINUTE_DURATION = (2*PI)/ MINUTES_PER_DAY

var time = 0
var past_minute : float = -1.0
var day : int
var hour : int
var minute : int

enum DayState {
	morning,
	afternoon,
	evening,
	night
}

@export var gradient : GradientTexture1D
@export var INGAME_SPEED  = 2
@export var INIT_HOUR = 12:
	set(h):
		INIT_HOUR = h
		time = INGAME_TO_REAL_MINUTE_DURATION * INIT_HOUR * MINUTES_PER_HOUR

const  NIGHT_COLOR = Color("#3f40a3")
const  DAY_COLOR = Color("#e9e697")

var state : DayState

signal time_tick(day:int, hour: int, minute: int)

func _ready() -> void:
	time = INGAME_TO_REAL_MINUTE_DURATION * INIT_HOUR * MINUTES_PER_HOUR
func _process(delta: float) -> void:
	#time += delta * 0.1# * 0.0333333333
	#self.color = DAY_COLOR.lerp(NIGHT_COLOR,abs(sin(time)))
	#if self.color == Color("#3f40a3"):
		#state = 1
	#elif self.color == Color("#e9e697"):
		#state = 0
	#print(state)
	time += delta * INGAME_TO_REAL_MINUTE_DURATION * INGAME_SPEED
	var value = (sin(time - PI/2)+1.0)/2.0
	self.color = gradient.gradient.sample(value)
	recalculate_time()

func recalculate_time() -> void:
	var total_minutes = int(time / INGAME_TO_REAL_MINUTE_DURATION)
	
	day = int(total_minutes / MINUTES_PER_DAY)
	var current_day_minutes = total_minutes % MINUTES_PER_DAY
	hour = int(current_day_minutes / MINUTES_PER_HOUR)
	minute = int(current_day_minutes % MINUTES_PER_HOUR)
	
	if past_minute != minute:
		past_minute = minute
		time_tick.emit(day,hour,minute)
	
	if hour >= 8 and hour < 12:
		state = DayState.morning
	elif hour >= 12 and hour <18:
		state = DayState.afternoon
	elif hour >= 18 and hour <23:
		state = DayState.evening
	elif hour >= 0 and hour <8:
		state = DayState.night
