

$ ->
	initBoard(20, 20)
	$("tr td").click(() -> $(this).toggleClass("toggled"))

initBoard = (row, col) ->
	boardArea = Constants.boardAreaElement()

	board = new Board(row, col)
	for row in [0...board.rows]
		newRow = jQuery('<tr>', {
				id: "row-" + row,
				class: "table-row"
			})
		boardArea.append(newRow)

		for col in [0...board.cols]
			cell = board.getCell(row, col)
			newElement = jQuery('<td>', {
					id: cell.getCellName(),
					class: Constants.cellClass()
				})
			newRow.append(newElement)

class Constants
	@boardAreaElement: () ->
		$("#board-area")

	@cellClass: () -> "table-col"

# Row, then col
class Board
	@_init: (board, row_count, col_count) ->
		for row in [0...row_count] by 1
			rows = []
			for col in [0...col_count] by 1
				rows.push(new Cell(row, col))
			board.push(rows)

	constructor: (@rows = 20, @cols = 20) ->
		@board = []
		Board._init(@board, @rows, @cols)

	getCell: (row, col) ->
		@board[row][col]


class Cell
	constructor: (@row, @col, @toggled = false) ->

	toggle: () ->
		@toggled = !@toggled

	getCellElement: () ->
		div = "#" + getCellName()
		$(div)

	getCellName: () ->
		"cell-" + @row + "-" + @col
