extends Node

@export var server: Server


func start_event():
	var servers = $"../../../Servers"
	if server:
		server.reparent(servers)
