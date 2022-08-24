extends CanvasLayer

const BIN_NAME := "filepicker"
const ABS_PATH := "/app/bin/filepicker"

onready var output_control = $VSplitContainer/Output

onready var env_path_button = $VSplitContainer/HBoxContainer/EnvPath
onready var abs_path_button = $VSplitContainer/HBoxContainer/AbsPath
onready var read_last_button = $VSplitContainer/HBoxContainer/ReadLast

onready var status = $VSplitContainer/HBoxContainer/Status

var file_path := ""

#-----------------------------------------------------------------------------#
# Builtin functions                                                           #
#-----------------------------------------------------------------------------#

func _init() -> void:
	OS.center_window()

func _ready() -> void:
	env_path_button.connect("pressed", self, "_env_pressed")
	abs_path_button.connect("pressed", self, "_abs_pressed")
	read_last_button.connect("pressed", self, "_read_last_pressed")
	abs_path_button.hint_tooltip = ABS_PATH

#-----------------------------------------------------------------------------#
# Connections                                                                 #
#-----------------------------------------------------------------------------#

func _env_pressed() -> void:
	_run_bin(BIN_NAME)

func _abs_pressed() -> void:
	_run_bin(ABS_PATH)

func _read_last_pressed() -> void:
	if file_path.empty():
		output_control.text = "file_path is empty"
		return
	_read_file_to_output(file_path)

#-----------------------------------------------------------------------------#
# Private functions                                                           #
#-----------------------------------------------------------------------------#

func _run_bin(arg: String) -> void:
	var output := []
	var err: int = OS.execute(arg, [], true, output)
	
	if err != 0:
		output_control.text = "Invalid exit code %d" % err
		return
	
	for i in output:
		if i.empty():
			continue
		
		_read_file_to_output(i)
		break

func _read_file_to_output(path: String) -> void:
	file_path = path
	
	var file := File.new()
	
	var err := file.open(path, File.READ)
	
	output_control.text = file.get_as_text() if err == OK else "Unable to read file at path %s" % path

#-----------------------------------------------------------------------------#
# Public functions                                                            #
#-----------------------------------------------------------------------------#
