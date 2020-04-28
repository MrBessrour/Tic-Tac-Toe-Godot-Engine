extends Node2D

var size = 3
var cell_size = 50
var player = 'X'
var font = DynamicFont.new()
var board = []
var pos = []

func _create_board()  -> void:
	var tab = []
	for i in range(size):
		for j in range(size):
			tab.append('')
		board.append(tab)
		tab = []

func set_pos_array() -> void:
	var posx = 0 ;
	var posy = 0 ;
	var tab = []
	for i in range(size):
		for j in range(size):
			tab.append(Vector2(posx,posy))
			posx += cell_size
		pos.append(tab)
		tab = []
		posy += cell_size
		posx = 0

func resize_screen(size):
	OS.set_window_size(Vector2(size*cell_size,size*cell_size))
	return 

func get_clicked_cell(p):
	for i in range(size):
		for j in range(size):
			if (p.x >= pos[i][j].x and p.x <= pos[i][j].x +cell_size ) and (p.y >= pos[i][j].y and p.y <= pos[i][j].y +cell_size)  :
				return [i,j]

func check_pos_is_valid(i,j) -> bool:
	if board[i][j] == '' :
		return true 
	else : 
		return false 


func switch_players() -> void:
	if player == 'X' :
		player = 'O' 
	elif player == 'O' :
		player = 'X'
	return

func play(i,j) -> void:
	board[i][j] = player 
	switch_players()
	print(player+' turn')
	update()

func _ready():
	font.font_data = load("res://Another Round.otf")
	font.size = cell_size
	set_pos_array()
	_create_board()
	resize_screen(size)

func check_winner() :
	#Row and column test 
	for i in range(size):
		var test = [true,true]
		for j in range(size):
#Row test
			if board[i][j] != board[i][0] or board[i][j] == '' :
				test[0] = false
#Column test
			if board[j][i] != board[0][i] or board[j][i] == '' :
				test[1] = false

		if test[0] :
			return board[i][0] ;
		if test[1] :
			return board[0][i] ;

#diagonal test 

	var dia_test = [true,true]
	var j = size - 1
	for i in range(size):
		if board[i][i] != board[0][0] or board[i][i] == '' :
			dia_test[0] = false

		if board[i][j] != board[size-1][0] or board[i][j] == '' :
			dia_test[1] = false
		j -= 1

	if dia_test[0] :
		return board[0][0]
	if dia_test[1] :
		return board[size-1][0]

	return null

func check_draw() :
	var k = 0
	for i in range(size):
		for j in range(size):
			if board[i][j] != '' :
				k += 1
	if k == pow(size,2) :
		return true
	return false 

func is_game_finished() :
	var winner = check_winner()
	if winner != null :
		print(winner + ' is winner')
		return true
	elif check_draw() :
		print('Draw')
		return true
	return false

func _draw():
	#drawing the board array
	for i in range(size):
		for j in range(size):
			draw_string(font,Vector2(pos[i][j].x + (cell_size*0.2) , pos[i][j].y + cell_size*0.8),board[i][j],Color(0,0,0,5))
	
	#drawing Grid
	var j = 0
	for i in range(size) :
		j += cell_size
		draw_line(Vector2(0,j),Vector2(cell_size*size,j),Color(0,0,0,5))
		draw_line(Vector2(j,0),Vector2(j,cell_size*size),Color(0,0,0,5))

func _input(event):
	if(Input.is_action_just_pressed("click")):
		var cell = get_clicked_cell(event.position)
		if check_pos_is_valid(cell[0],cell[1]) :
			play(cell[0],cell[1])
			if is_game_finished() :
				set_process_input(false)




