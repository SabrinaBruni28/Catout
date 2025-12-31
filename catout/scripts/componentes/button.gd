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

	# Teclado
	if event is InputEventKey and event.pressed and not event.echo:
		atribuir_evento(event)
		return

	# Botão do controle
	if event is InputEventJoypadButton and event.pressed:
		atribuir_evento(event)
		return

	# Analógico do controle
	if event is InputEventJoypadMotion:
		if abs(event.axis_value) > 0.6:
			atribuir_evento(event)
			return

func atribuir_evento(event: InputEvent):
	var action := player + "_" + action_name

	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event.duplicate())

	esperando_input = false
	atualizar_texto()

	focus_mode = foco_original
	release_focus()

	get_viewport().set_input_as_handled()

func atualizar_texto():
	var action := player + "_" + action_name
	var eventos = InputMap.action_get_events(action)

	if eventos.is_empty():
		text = "Não configurado"
	else:
		text = limitar_texto(eventos[0].as_text(), 15)

func limitar_texto(texto: String, limite_por_linha: int) -> String:
	var max_chars := limite_por_linha * 3

	# Cabe tudo em uma linha
	if texto.length() <= limite_por_linha:
		return texto

	# Cabe em até 3 linhas sem cortar
	if texto.length() <= max_chars:
		var linhas := []
		for i in range(0, texto.length(), limite_por_linha):
			linhas.append(texto.substr(i, limite_por_linha))
		return "\n".join(linhas)

	# Texto grande demais → corta e adiciona …
	var linhas := []
	for i in range(0, limite_por_linha * 2, limite_por_linha):
		linhas.append(texto.substr(i, limite_por_linha))

	var ultima := texto.substr(limite_por_linha * 2, limite_por_linha - 1) + "…"
	linhas.append(ultima)

	return "\n".join(linhas)
