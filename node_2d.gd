extends Node2D

var gold_amount: float = 1.0  # Começar com 1 de gold
var gold_per_click: float = 1.0  # Initial gold per click
var upgrade_cost: int = 10  # Cost for upgrading
var gold_per_tick: float = 0.1  # Gold generated per tick
var penalty_per_tick: float = -0.1  # Penalidade de ouro por tick negativo
var penalty_multiplier: float = 1.1  # Multiplicador da penalidade
var penalty_tick_count: int = 0  # Contador de ticks de penalidade
var is_game_over: bool = false  # Estado do jogo
var click_count: int = 0  # Contador de cliques no AddGoldButton

@onready var toggle_button: Button = $ToggleButton
@onready var options_container: VBoxContainer = $AddGoldButton2
@onready var add_gold_button: Button = $AddGoldButton
@onready var upgrade_button: Button = $UpgradeButton
@onready var reset_button: Button = $ResetButton  # Novo botão de reset
@onready var gold_label: Label = $GoldLabel
@onready var gold_timer: Timer = $GoldTimer
@onready var description_label: Label = $Description
@onready var penalty_timer: Timer = $PenaltyTimer
@onready var game_over_label: Label = $GameOverLabel  # Nova Label para Game Over
@onready var option_button_asa: Button = $AddGoldButton2/Button  # Exemplo para Asa
@onready var option_button_ese: Button = $AddGoldButton2/Button2  # Exemplo para Ese
@onready var option_button_isi: Button = $AddGoldButton2/Button3  # Exemplo para Isi

func _ready() -> void:
	# Conectar sinais dos botões
	add_gold_button.pressed.connect(_on_AddGoldButton_pressed)
	upgrade_button.pressed.connect(_on_UpgradeButton_pressed)
	reset_button.pressed.connect(_on_ResetButton_pressed)  # Conectar o botão de reset
	gold_timer.timeout.connect(_on_GoldTimer_timeout)
	penalty_timer.timeout.connect(_on_PenaltyTimer_timeout)  # Conectar o timer de penalidade
	gold_timer.start()  # Start the gold timer
	penalty_timer.start()  # Start the penalty timer
	toggle_button.pressed.connect(_on_toggle_button_pressed)

	# Configuração da descrição
	description_label.anchor_bottom = 1  # Anexar na parte inferior
	description_label.anchor_left = 0  # Anexar à esquerda
	description_label.anchor_right = 1  # Anexar à direita
	description_label.text = "Selecione uma opção para ver a descrição."  # Texto padrão
	description_label.visible = false  # Inicialmente invisível

	# Configuração da label de Game Over
	game_over_label.text = "GAME OVER"  # Texto de Game Over
	game_over_label.visible = false  # Inicialmente invisível
	game_over_label.modulate = Color(1, 0, 0)  # Cor vermelha
	game_over_label.set("rect_size", Vector2(400, 100))  # Definir tamanho da caixa
	game_over_label.set("rect_position", Vector2((get_viewport().size.x - 400) / 2, (get_viewport().size.y - 100) / 2))  # Centralizar

	# Esconder o botão de upgrade e reset inicialmente
	upgrade_button.visible = false
	reset_button.visible = false  # Esconder o botão de reset inicialmente

	# Ocultar as opções inicialmente
	options_container.visible = false

	# Conectar os sinais dos botões de opções
	option_button_asa.pressed.connect(_on_asa_pressed)
	option_button_ese.pressed.connect(_on_ese_pressed)
	option_button_isi.pressed.connect(_on_isi_pressed)

func _on_toggle_button_pressed() -> void:
	options_container.visible = !options_container.visible
	description_label.visible = options_container.visible  # Mostrar descrição se as opções estiverem visíveis
	toggle_button.text = "Ocultar Opções" if options_container.visible else "Mostrar Opções"

func _on_AddGoldButton_pressed() -> void:
	gold_amount += gold_per_click  # Increment gold amount
	gold_label.text = "Gold: " + str(gold_amount)  # Update the label text

	# Incrementar o contador de cliques
	click_count += 1
	
	# Verificar se o botão de upgrade deve ser exibido
	if click_count >= 10:
		upgrade_button.visible = true  # Mostrar o botão de upgrade

func _on_UpgradeButton_pressed() -> void:
	if gold_amount >= upgrade_cost:  # Check if the player has enough gold
		gold_amount -= upgrade_cost  # Deduct the cost from gold amount
		gold_per_click = 2.0  # Set to 2 after the upgrade
		gold_label.text = "Gold: " + str(gold_amount)  # Update the label text
		upgrade_button.disabled = true  # Disable the upgrade button
		upgrade_button.text = "Upgraded!"  # Change button text to indicate upgrade
	else:
		print("Not enough gold to upgrade!")  # Feedback if not enough gold

func _on_GoldTimer_timeout() -> void:
	if not is_game_over:  # Verificar se não está em game over
		gold_amount += gold_per_tick  # Increment gold amount by the tick rate
		gold_label.text = "Gold: " + str(gold_amount)  # Update the label text

func _on_PenaltyTimer_timeout() -> void:
	if not is_game_over:  # Verificar se não está em game over
		penalty_tick_count += 1
		gold_amount += penalty_per_tick  # Deduzir a penalidade
		gold_label.text = "Gold: " + str(gold_amount)  # Atualizar o texto do rótulo

		# Aumentar o multiplicador a cada 2 ticks
		if penalty_tick_count % 2 == 0:
			penalty_per_tick *= penalty_multiplier
			print("Nova penalidade: " + str(penalty_per_tick))

		# Verificar se o ouro chegou a 0
		if gold_amount <= 0:
			gold_amount = 0  # Garantir que não fique negativo
			is_game_over = true  # Ativar o estado de game over
			penalty_timer.stop()  # Parar o timer de penalidade
			game_over()  # Chamar game over

func game_over() -> void:
	game_over_label.visible = true  # Tornar a label de Game Over visível
	reset_button.visible = true  # Mostrar o botão de reset
	print("Game Over! Você ficou sem ouro.")

func _on_ResetButton_pressed() -> void:
	# Resetar todas as variáveis ao estado inicial
	gold_amount = 1.0  # Começar novamente com 1 de gold
	gold_per_click = 1.0
	upgrade_cost = 10
	gold_per_tick = 0.1
	penalty_per_tick = -0.1
	penalty_tick_count = 0
	is_game_over = false
	click_count = 0
	
	# Atualizar a interface
	gold_label.text = "Gold: " + str(gold_amount)
	upgrade_button.visible = false
	game_over_label.visible = false  # Esconder a label de Game Over
	reset_button.visible = false  # Esconder o botão de reset
	penalty_timer.start()  # Reiniciar o timer de penalidade

func _on_asa_pressed() -> void:
	description_label.text = "O secretário municipal realiza atendimento ao público, agendamento de reuniões, gestão de documentos, análise de dados, processamento de solicitações e comunicação."  # Atualizar a descrição para "asa"

func _on_ese_pressed() -> void:
	description_label.text = "O subsecretário realiza atendimento ao público, coordenação de equipes, gestão de documentos, análise de dados, elaboração de relatórios e comunicação."  # Atualizar a descrição para "ese"

func _on_isi_pressed() -> void:
	description_label.text = "Os diretores de departamento realizam gestão de equipes, coordenação de projetos, análise de dados, elaboração de relatórios, supervisão de processos e comunicação entre setores."  # Atualizar a descrição para "isi"
