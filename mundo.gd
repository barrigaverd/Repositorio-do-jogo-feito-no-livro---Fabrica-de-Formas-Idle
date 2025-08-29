extends Node2D

@onready var exibidor_de_pontos = $Interface/ExibidorDePontos
@onready var botao_upgrade_clique = $Interface/MenuDeUpgrades/BotaoUpgradeClique
@onready var botao_comprar_gerador = $Interface/MenuDeUpgrades/BotaoComprarGerador

# --- Variáveis do Jogo ---
# Armazena a quantidade total de "formas" que o jogador possui.
var formas_totais = 0
# Armazena quantas formas o jogador ganha por cada clique.
var formas_por_clique = 1
# Armazena o custo do próximo upgrade de clique.
var custo_do_upgrade_de_clique = 10
# Armazena quantas formas são geradas automaticamente por segundo.
var formas_por_segundo = 0.0
# Armazena o custo do nosso primeiro tipo de gerador.
var custo_do_primeiro_gerador = 50

# Esta função é chamada automaticamente uma vez quando o jogo começa.
func _ready():
	print("O jogo 'Fábrica de Formas Idle' começou!")
	print("Formas iniciais:", formas_totais)
	print("Formas por clique:", formas_por_clique)
	atualizar_interface()

func _on_gerador_principal_gui_input(evento):
	# Primeiro, verificamos se o evento foi de um botão do mouse,
	# se foi o botão esquerdo, e se ele acabou de ser pressionado.
	if evento is InputEventMouseButton and evento.button_index == MOUSE_BUTTON_LEFT and evento.is_pressed():
		# Se todas as condições forem verdadeiras, executamos a lógica do jogo!
		formas_totais = formas_totais + formas_por_clique
		print("Forma gerada! Total agora é:", formas_totais)
		atualizar_interface() # Adicione esta linha

# Uma função nossa, criada para manter a interface do usuário atualizada.
func atualizar_interface():
	exibidor_de_pontos.text = "Formas: %s" % int(formas_totais)
	botao_upgrade_clique.text = "Melhorar Clique (Custo: %s)" % custo_do_upgrade_de_clique
	botao_comprar_gerador.text = "Comprar Gerador (Custo: %s)" % custo_do_primeiro_gerador

func _on_botao_upgrade_clique_pressed():
	# Passo 1: O jogo verifica se o jogador tem formas suficientes.
	if formas_totais >= custo_do_upgrade_de_clique:
		# Se a condição for verdadeira, o código abaixo é executado.
		
		# Passo 2: Subtrai o custo do total de formas.
		formas_totais = formas_totais - custo_do_upgrade_de_clique
		
		# Passo 3: Aumenta o poder do clique.
		formas_por_clique = formas_por_clique + 1
		
		# Passo 4: Aumenta o custo para o próximo upgrade.
		# Vamos torná-lo 15% mais caro, por exemplo.
		# A função floor() arredonda o número para baixo, evitando decimais.
		custo_do_upgrade_de_clique = floor(custo_do_upgrade_de_clique * 1.15)
		
		# Passo 5: Atualiza toda a interface.
		atualizar_interface()
		
# Esta função é chamada a cada quadro (frame) do jogo.
# 'delta' é o tempo em segundos que passou desde o último quadro.
func _process(delta):
	# Calcula quantas formas foram geradas neste exato quadro.
	var formas_geradas_neste_quadro = formas_por_segundo * delta
	
	# Adiciona o valor calculado ao nosso total de formas.
	formas_totais = formas_totais + formas_geradas_neste_quadro
	
	# Atualiza a interface para que o jogador veja a pontuação subindo!
	atualizar_interface()

func _on_botao_comprar_gerador_pressed():
	# Verifica se o jogador pode pagar pelo gerador.
	if formas_totais >= custo_do_primeiro_gerador:
		# Se puder, subtrai o custo.
		formas_totais = formas_totais - custo_do_primeiro_gerador
		
		# Aumenta a produção de formas por segundo.
		formas_por_segundo = formas_por_segundo + 0.5 # Cada gerador adiciona 0.5 formas/s
		
		# Aumenta o custo para o próximo gerador.
		custo_do_primeiro_gerador = floor(custo_do_primeiro_gerador * 1.20) # 20% mais caro
