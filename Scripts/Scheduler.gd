extends Node

func schedule(function_name:Callable, delay:float):
	var timer  = Timer.new()
	timer.timeout.connect(function_name)
	timer.timeout.connect(timer.queue_free)
	get_tree().root.add_child(timer)
	timer.start(delay)
	#print("delayed function call for "+str(function_name)+" in "+str(delay)+" second(s)")
