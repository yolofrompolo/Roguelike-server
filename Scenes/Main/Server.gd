extends Node

var network = NetworkedMultiplayerENet.new()
var port = 4645
var MAX_PLAYER = 8

onready var player_verification_process = get_node("PlayerVerification")

func _ready():
	StartServer()

func StartServer():
	network.create_server(port, MAX_PLAYER)
	get_tree().set_network_peer(network)
	print("Сервер запущен")

	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")


func _Peer_Connected(player_id):
	print("Пользователь " + str(player_id) +" подключен")
	player_verification_process.start(player_id)

func _Peer_Disconnected(player_id):
	print("Пользователь " + str(player_id) +" отключен")
	get_node(str(player_id)).queue_free()
	
remote func FetchPlayerStats():
	var player_id = get_tree().get_rpc_sender_id()
	var player_stats = get_node(str(player_id)).player_stats
	rpc_id(player_id,"ReturnPlayerStats", player_id)
	print("Статы проверенны")
