extends Node

signal hit_player
signal player_attack
signal push_back
signal charge
signal ranged_attack
signal kill_all
signal reset_all
signal total_death_wizard

export var mob_speed = 50
export(PackedScene) var mob_scene
var money = 0

var wave = 1

var is_shopping = false

export var wave_no = 0
var current_wave = wave_no

var monsters_slain = 5
var monsters_for_wave = 5

var stocks_and_shares = 0
var stocks_and_shares_change = 0.0

var mob_timer = 3

var cash = 0
var cash_change = 0.0

var crypto = 0
var crypto_change = 0.0

var game_over = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# Set initial label text
	$WizardHealthCounter.text = "HP: " +str($PlayerScene.current_health) + " / " + str($PlayerScene.maximum_health)
	$CoinCounter.text = "£"+str(money)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_mob_died(mob):
	money += mob.money
	$CoinCounter.text = "£"+str(money)
	monsters_slain -= 1
	if (monsters_slain <= 0):
		moveToBank()
		
func moveToBank():
	if game_over:
		return
	is_shopping = true
	$ChargedAttack.visible = false
	$RangedAttack.visible = false
	$WizardHealthCounter.visible = false
	$OpenInvestments.visible = true
	$Continue.show()
	$ParallaxBackground/ParallaxLayer7.visible = true
	$ParallaxBackground.scroll_offset = Vector2(0, 0)
	
	
	

func _on_player_hit(mob):
	if($PlayerScene.charging):
		mob.kill()
		return
	
	if(mob.remaining_health <= 0):
		emit_signal("player_attack")
	else:
		emit_signal("hit_player")
		emit_signal("push_back")
	
	
	
	$WizardHealthCounter.text = "HP: " + str($PlayerScene.current_health) + " / " + str($PlayerScene.maximum_health)
	

func _on_MobTimer_timeout():
	if (monsters_for_wave <= 0):
		return
	monsters_for_wave -= 1
	
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instance()

	# Spawn at location
	var mob_spawn_location = get_node("MobSpawn")

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position
	mob.connect("hit_player", self, "_on_player_hit")
	mob.connect("mob_died", self, "_on_mob_died")
	connect("push_back", mob, "push_back")
	connect("charge", mob, "_on_charge")
	connect("kill_all", mob, "kill")
	
	# Reset functions
	#connect("reset_all", mob, "kill")

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_ChargedAttack_input_event(viewport, event, shape_idx):
	if(event is InputEventScreenTouch or (event is InputEventMouseButton and event.pressed)):
		if $ChargedAttack.enabled:
			emit_signal("charge")
	


func _on_RangedAttack_input_event(viewport, event, shape_idx):
	if(event is InputEventScreenTouch or (event is InputEventMouseButton and event.pressed)):
		if $RangedAttack.enabled:
			emit_signal("ranged_attack")


func _on_PlayerScene_game_over():
	$LoseScreen.visible = true
	$LoseScreen/LoseText.text = "GAME OVER" +"\n" + "Money: £" + str(stepify(money, 0.01)) + "\nStocks & Shares: £" + str(stepify(stocks_and_shares, 0.01)) + "\nCash to Bank: £" + str(stepify(cash, 0.01)) + "\nCrypto: £" + str(stepify(crypto, 0.01)) + "\n" + "\nYou earned: £"+ str(stepify(money + crypto + stocks_and_shares + cash, 0.01))
	
	$Restart.visible = true
	$OpenInvestments.hide()
	$Continue.hide()
	# DOn't spawn anymore mobs
	$MobTimer.stop()
	# Hide all mobs
	game_over = true
	emit_signal("kill_all")
	
	
	
	
	
	
	
	

	
	
	
	
	
func resetStage():
	emit_signal("reset_all")
	
	# Reset wizard 
	$WizardHealthCounter.text = "HP: " + str($PlayerScene.current_health) + " / " + str($PlayerScene.maximum_health)
	
	# Reset monsters
	$MobTimer.start(3)
	
	# Show stage
	$LoseScreen.hide()
	
	$Restart.hide()
	
	
	
	
	
	
func restartGame():
	
	# Reset wave
	current_wave = 0
	
	
	
	# Full reset wizard
	emit_signal("total_death_wizard")
	
	resetStage()
	stocks_and_shares = 0
	stocks_and_shares_change = 0
	cash = 0
	cash_change = 0
	crypto = 0
	crypto_change = 0
	
	# Reset earnings
	money = 0
	$CoinCounter.text = "£0"
	
	game_over = false
	
	
	
	


func _on_Restart_input_event(viewport, event, shape_idx):
	if(event is InputEventScreenTouch or (event is InputEventMouseButton and event.pressed)):
		if(game_over):
			restartGame()



func _on_OpenInvestments_input_event(viewport, event, shape_idx):
	if(event is InputEventScreenTouch or (event is InputEventMouseButton and event.pressed)):
		openInvestments()
		
func openInvestments():
	$"Stocks and Shares2".show()
	$Cryptocurrency.show()
	$Cash.show()
			

func _on_Stocks_and_Shares2_add():
	if money >= 10:
		stocks_and_shares += 10
		$"Stocks and Shares2".setValue(stocks_and_shares)
		money -= 10
		$CoinCounter.text = "£"+str(money)


func _on_Stocks_and_Shares2_take():
	if stocks_and_shares >= 10:
			money += 10
			stocks_and_shares -= 10
			$"Stocks and Shares2".setValue(stocks_and_shares)
			$CoinCounter.text = "£"+str(money)


func _on_Stocks_and_Shares_add():
	if money >= 10:
		cash += 10
		$"Cash".setValue(cash)
		money -= 10
		$CoinCounter.text = "£"+str(money)


func _on_Stocks_and_Shares_take():
	if cash >= 10:
		money += 10
		cash -= 10
		$Cash.setValue(cash)
		$CoinCounter.text = "£"+str(money)


func _on_Cryptocurrency_add():
	if money >= 10:
		crypto += 10
		$Cryptocurrency.setValue(crypto)
		money -= 10
		$CoinCounter.text = "£"+str(money)


func _on_Cryptocurrency_take():
	if crypto >= 10:
		money += 10
		crypto -= 10
		$Cryptocurrency.setValue(crypto)
		$CoinCounter.text = "£"+str(money)


func _on_Continue_input_event(viewport, event, shape_idx):
	if(event is InputEventScreenTouch or (event is InputEventMouseButton and event.pressed)):
		# Hide screen
		$"Stocks and Shares2".hide()
		$Cryptocurrency.hide()
		$Cash.hide()
		$OpenInvestments.hide()
		$Continue.hide()
		
		
		# Show screen
		$ChargedAttack.show()
		$RangedAttack.show()
		
		# Start next level
		
	
		# Reset wizard 
		
		
		# Set up next wave
		nextWave()
		emit_signal("reset_all")
		monsters_slain = monsters_for_wave
		$WizardHealthCounter.text = "HP: " + str($PlayerScene.current_health) + " / " + str($PlayerScene.maximum_health)
		$WizardHealthCounter.show()
		
func nextWave():
	wave += 1
	monsters_slain = 5 + wave
	monsters_for_wave = 5 + wave
	$MobTimer.start(mob_timer - (0.1 * wave))
	
	var random = RandomNumberGenerator.new()
	random.randomize()
	
	stocks_and_shares_change = 1 + (random.randf() / 4.0) - 0.1
	
	stocks_and_shares *= stocks_and_shares_change;
	
	$"Stocks and Shares2".setRate(stocks_and_shares_change)
	
	# Cash change
	cash_change = 1 + (0.05)
	cash *= cash_change
	$Cash.setRate(cash_change)
	
	# Crypto change
	crypto_change = (random.randf() * 4) - 2
	if (crypto_change <= 0):
		crypto_change = 0.01
		
	crypto *= crypto_change
	$Cryptocurrency.setRate(crypto_change)
	
	$"Stocks and Shares2".setValue(stocks_and_shares)
	$Cash.setValue(cash)
	$Cryptocurrency.setValue(crypto)
