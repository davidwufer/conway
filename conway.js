// Generated by CoffeeScript 1.6.3
(function() {
  var Board, Cell, Constants, cellsToElements, clear, initBoard, nextIteration, toggleCells;

  $(function() {
    var board;
    board = new Board(3, 3);
    initBoard(board);
    $("tr td").click(function() {
      return toggleCells($(this), board);
    });
    $(".next").click(function() {
      return nextIteration(board);
    });
    return $(".clear").click(function() {
      return clear(board);
    });
  });

  clear = function(board) {
    return alert("Clear!");
  };

  nextIteration = function(board) {
    var cellsToToggle, elementsToToggle, jqueryElements;
    cellsToToggle = board.getCellsToToggle();
    elementsToToggle = cellsToElements(cellsToToggle);
    jqueryElements = $(_.map(elementsToToggle, function(elem) {
      return elem[0];
    }));
    return toggleCells(jqueryElements, board);
  };

  cellsToElements = function(cellsToToggle) {
    var cell, elems, _i, _len;
    elems = [];
    for (_i = 0, _len = cellsToToggle.length; _i < _len; _i++) {
      cell = cellsToToggle[_i];
      elems.push(cell.getCellElement());
    }
    return elems;
  };

  toggleCells = function(elems, board) {
    var col, elem, row, split, _i, _len, _results;
    elems.toggleClass("live");
    _results = [];
    for (_i = 0, _len = elems.length; _i < _len; _i++) {
      elem = elems[_i];
      split = elem.id.split("-");
      row = parseInt(split[1]);
      col = parseInt(split[2]);
      _results.push(board.toggleCell(row, col));
    }
    return _results;
  };

  initBoard = function(board) {
    var boardArea, cell, col, newElement, newRow, row, _i, _ref, _results;
    boardArea = Constants.boardAreaElement();
    _results = [];
    for (row = _i = 0, _ref = board.rows; 0 <= _ref ? _i < _ref : _i > _ref; row = 0 <= _ref ? ++_i : --_i) {
      newRow = jQuery('<tr>', {
        id: "row-" + row,
        "class": "table-row"
      });
      boardArea.append(newRow);
      _results.push((function() {
        var _j, _ref1, _results1;
        _results1 = [];
        for (col = _j = 0, _ref1 = board.cols; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; col = 0 <= _ref1 ? ++_j : --_j) {
          cell = board.getCell(row, col);
          newElement = jQuery('<td>', {
            id: cell.getCellName(),
            "class": Constants.cellClass()
          });
          _results1.push(newRow.append(newElement));
        }
        return _results1;
      })());
    }
    return _results;
  };

  Constants = (function() {
    function Constants() {}

    Constants.boardAreaElement = function() {
      return $("#board-area");
    };

    Constants.cellClass = function() {
      return "table-col";
    };

    return Constants;

  })();

  Board = (function() {
    Board.steps = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]];

    Board._init = function(board, row_count, col_count) {
      var col, row, rows, _i, _j, _results;
      _results = [];
      for (row = _i = 0; _i < row_count; row = _i += 1) {
        rows = [];
        for (col = _j = 0; _j < col_count; col = _j += 1) {
          rows.push(new Cell(row, col));
        }
        _results.push(board.push(rows));
      }
      return _results;
    };

    function Board(rows, cols) {
      this.rows = rows != null ? rows : 20;
      this.cols = cols != null ? cols : 20;
      this.board = [];
      Board._init(this.board, this.rows, this.cols);
    }

    Board.prototype.onBoard = function(row, col) {
      return row >= 0 && col >= 0 && row < this.rows && col < this.cols;
    };

    Board.prototype.toggleCell = function(row, col) {
      return this.getCell(row, col).toggle();
    };

    Board.prototype.getCell = function(row, col) {
      debugger;
      return this.board[row][col];
    };

    Board.prototype.getCellsToToggle = function() {
      var cell, cells, col, row, _i, _j, _ref, _ref1;
      cells = [];
      for (row = _i = 0, _ref = this.rows; _i < _ref; row = _i += 1) {
        for (col = _j = 0, _ref1 = this.cols; _j < _ref1; col = _j += 1) {
          cell = this.getCell(row, col);
          if (this.shouldToggle(cell)) {
            cells.push(cell);
          }
        }
      }
      return cells;
    };

    Board.prototype.shouldToggle = function(cell) {
      return this.shouldLive(cell) !== cell.isLive();
    };

    Board.prototype.shouldLive = function(cell) {
      var numLiveNeighbors;
      numLiveNeighbors = this.getNumLiveNeighbors(cell);
      if (cell.isLive()) {
        return numLiveNeighbors === 2 || numLiveNeighbors === 3;
      } else {
        return numLiveNeighbors === 3;
      }
    };

    Board.prototype.getNumLiveNeighbors = function(cell) {
      debugger;
      var col, neighborCell, numLiveNeighbors, row, step, _i, _len, _ref;
      numLiveNeighbors = 0;
      _ref = Board.steps;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        step = _ref[_i];
        row = step[0] + cell.row;
        col = step[1] + cell.col;
        if (this.onBoard(row, col)) {
          neighborCell = this.getCell(row, col);
          if (neighborCell.isLive()) {
            numLiveNeighbors = numLiveNeighbors + 1;
          }
        }
      }
      return numLiveNeighbors;
    };

    return Board;

  })();

  Cell = (function() {
    function Cell(row, col, live) {
      this.row = row;
      this.col = col;
      this.live = live != null ? live : false;
    }

    Cell.prototype.toggle = function() {
      return this.live = !this.live;
    };

    Cell.prototype.getCellElement = function() {
      var elemName;
      elemName = "#" + this.getCellName();
      return $(elemName);
    };

    Cell.prototype.getCellName = function() {
      return ["cell", this.row, this.col].join("-");
    };

    Cell.prototype.isLive = function() {
      return this.live;
    };

    return Cell;

  })();

}).call(this);
