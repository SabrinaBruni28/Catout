extends Button

@export var action_name: String = ""
@export var player: String = ""

@onready var label: Label = $Label

var esperando_input := false
var foco_original := FocusMode.FOCUS_ALL


func _ready():
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.text = action_name
	atualizar_texto()


func _on_pressed():
	esperando_input = true
	text = "Pressione\numa tecla..."

	# Salva foco original e desativa navegação
	foco_original = focus_mode
	focus_mode = Control.FOCUS_NONE


func _input(event):
	if not esperando_input:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		atribuir_evento(event)


func atribuir_evento(event: InputEventKey):
	var action := player + "_" + action_name

	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event.duplicate())

	esperando_input = false
	atualizar_texto()

	# Restaura foco
	focus_mode = foco_original
	release_focus()

	get_viewport().set_input_as_handled()


func atualizar_texto():
	var action := player + "_" + action_name
	var eventos = InputMap.action_get_events(action)

	if eventos.is_empty():
		text = "Não configurado"
	else:
		text = eventos[0].as_text()
