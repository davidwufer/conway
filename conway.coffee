$ ->
  board = new Board(3, 3)

  initBoard(board)

  $("tr td").click(() -> toggleCells($(this), board))
  $(".next").click(() -> nextIteration(board))
  $(".clear").click(() -> clear(board))

clear = (board) ->
  # TODO: Implement
  alert("Clear!")

nextIteration = (board) ->
  cellsToToggle = board.getCellsToToggle()
  elementsToToggle = cellsToElements(cellsToToggle)
  jqueryElements = $(_.map(elementsToToggle, (elem) -> elem[0]))

  toggleCells(jqueryElements, board)

cellsToElements = (cellsToToggle) ->
  elems = []
  for cell in cellsToToggle
    elems.push(cell.getCellElement())
  return elems

toggleCells = (elems, board) ->
  elems.toggleClass("live")

  for elem in elems
    split = elem.id.split("-")
    row = parseInt(split[1])
    col = parseInt(split[2])

    board.toggleCell(row, col)


initBoard = (board) ->
  boardArea = Constants.boardAreaElement()

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
  @boardAreaElement: ->
    $("#board-area")

  @cellClass: -> "table-col"

# Row, then col
class Board
  @steps = [[-1, -1],
            [-1,  0],
            [-1,  1],
            [ 0, -1],
            [ 0,  1],
            [ 1, -1],
            [ 1,  0],
            [ 1,  1]]

  @_init: (board, row_count, col_count) ->
    for row in [0...row_count] by 1
      rows = []
      for col in [0...col_count] by 1
        rows.push(new Cell(row, col))
      board.push(rows)

  constructor: (@rows = 20, @cols = 20) ->
    @board = []
    Board._init @board, @rows, @cols

  onBoard: (row, col) ->
    row >= 0 && col >= 0 && row < @rows && col < @cols

  toggleCell: (row, col) ->
    @getCell(row, col).toggle()

  getCell: (row, col) ->
    debugger
    @board[row][col]

  getCellsToToggle: ->
    cells = []
    for row in [0...@rows] by 1
      for col in [0...@cols] by 1
        cell = @getCell(row, col)
        if @shouldToggle cell
          cells.push cell
    return cells

  shouldToggle: (cell) ->
    # debugger
    @shouldLive(cell) != cell.isLive()

  shouldLive: (cell) ->
    # debugger
    numLiveNeighbors = @getNumLiveNeighbors(cell)
    if cell.isLive()
      numLiveNeighbors == 2 || numLiveNeighbors == 3
    else
      numLiveNeighbors == 3

  getNumLiveNeighbors: (cell) ->
    debugger
    numLiveNeighbors = 0

    for step in Board.steps
      row = step[0] + cell.row
      col = step[1] + cell.col

      if @onBoard(row, col)
        neighborCell = @getCell(row, col)
        if neighborCell.isLive()
          numLiveNeighbors = numLiveNeighbors + 1
    return numLiveNeighbors

class Cell
  constructor: (@row, @col, @live = false) ->

  toggle: ->
    @live = !@live

  getCellElement: ->
    elemName = "#" + @getCellName()
    $(elemName)

  getCellName: ->
    ["cell", @row, @col].join("-")

  isLive: ->
    @live
