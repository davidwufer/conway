$ ->
    board = new Board(5, 5)

    initBoard(board)

    $("tr td").click(() -> toggleCells($(this), board))
    $("button").click(() -> nextIteration(board))

nextIteration = (board) ->
    # Placeholder

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
    @boardAreaElement: () ->
        $("#board-area")

    @cellClass: () -> "table-col"

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
        Board._init(@board, @rows, @cols)

    toggleCell: (row, col) ->
        @getCell(row, col).toggle()

    getCell: (row, col) ->
        @board[row][col]

    getCellsToToggle: () ->
        cells = []
        for row in [0...@rows] by 1
            for col in [0...@cols] by 1
                cell = @getCell(row, col)
                if @shouldToggle(cell)
                    cells.push(cell)

    shouldToggle: (cell) ->
        @shouldLive() != cell.live()

    shouldLive: (cell) ->
        numNeighbors = @getNeighbors(cell)
        if cell.live
            numNeighbors == 2 || numNeighbors == 3
        else
            numNeighbors == 3



class Cell
    constructor: (@row, @col, @live = false) ->

    toggle: () ->
        @live = !@live

    getCellElement: () ->
        div = "#" + getCellName()
        $(div)

    getCellName: () ->
        ["cell", @row, @col].join("-")
