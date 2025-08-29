extends Node2D

@onready var exibidor_de_pontos = $Interface/ExibidorDePontos
@onready var botao_upgrade_clique = $Interface/MenuDeUpgrades/BotaoUpgradeClique
@onready var botao_comprar_gerador = $Interface/MenuDeUpgrades/BotaoComprarGerador
@onready var animador_do_gerador = $GeradorPrincipal/AnimationPlayer

# --- Variáveis do Jogo ---
# Armazena a quantidade total de "formas" que o jogador possui.
var formas_totais = 0

# Dicionário para agrupar todas as informações do upgrade de clique.
var upgrade_clique = {
	"nivel": 1,
	"custo_base": 10,
	"custo_atual": 10,
	"fator_de_custo": 1.15
}

# Dicionário para o nosso primeiro tipo de gerador automático.
var gerador_tipo_1 = {
	"quantidade": 0,
	"custo_base": 50,
	"custo_atual": 50,
	"fator_de_custo": 1.20,
	"producao_por_unidade": 0.5 # Quantas formas por segundo cada unidade produz
}

# Esta função é chamada automaticamente uma vez quando o jogo começa.
func _ready():
	atualizar_interface()

func _on_gerador_principal_gui_input(evento):
	if evento is InputEventMouseButton and evento.button_index == MOUSE_BUTTON_LEFT and evento.is_pressed():
		# Dispara a animação!
		animador_do_gerador.play("clique")
		
		# O resto da lógica continua igual.
		formas_totais = formas_totais + upgrade_clique.nivel
		atualizar_interface()


# Uma função nossa, criada para manter a interface do usuário atualizada.
func atualizar_interface():
	exibidor_de_pontos.text = "Formas: %s" % int(formas_totais)
	botao_upgrade_clique.text = "Melhorar Clique (Custo: %s)" % upgrade_clique.custo_atual
	botao_comprar_gerador.text = "Comprar Gerador (Custo: %s)" % gerador_tipo_1.custo_atual


func _on_botao_upgrade_clique_pressed():
	if formas_totais >= upgrade_clique.custo_atual:
		formas_totais = formas_totais - upgrade_clique.custo_atual
		
		# Aumentamos o nível do upgrade.
		upgrade_clique.nivel += 1 # Atalho para: upgrade_clique.nivel = upgrade_clique.nivel + 1
		
		# Calculamos o novo custo.
		upgrade_clique.custo_atual = floor(upgrade_clique.custo_base * pow(upgrade_clique.fator_de_custo, upgrade_clique.nivel))
		atualizar_interface()

		
# Esta função é chamada a cada quadro (frame) do jogo.
# 'delta' é o tempo em segundos que passou desde o último quadro.
func _process(delta):
	# Calcula a produção total com base nos nossos geradores.
	var producao_total_por_segundo = gerador_tipo_1.quantidade * gerador_tipo_1.producao_por_unidade
	
	# O resto da lógica permanece o mesmo.
	var formas_geradas_neste_quadro = producao_total_por_segundo * delta
	formas_totais = formas_totais + formas_geradas_neste_quadro
	atualizar_interface()


func _on_botao_comprar_gerador_pressed():
	if formas_totais >= gerador_tipo_1.custo_atual:
		formas_totais = formas_totais - gerador_tipo_1.custo_atual
		gerador_tipo_1.quantidade += 1
		gerador_tipo_1.custo_atual = floor(gerador_tipo_1.custo_base * pow(gerador_tipo_1.fator_de_custo, gerador_tipo_1.quantidade))
