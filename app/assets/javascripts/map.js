$(document).ready(function() {
  function drawRect(x, y, w, h, color) {
    ctx.strokeStyle = color;
    ctx.fillStyle = color;

    ctx.fillRect(x, y, w, h);
  }

  function drawCircle(x, y, radius, color) {
    ctx.strokeStyle = color;
    ctx.fillStyle = color;

    ctx.beginPath();
    ctx.arc(x, y, radius, 0, Math.PI * 2, false);
    ctx.fill();
  }


  function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }

  var canvas = document.getElementById('canvas');
  var ctx = canvas.getContext('2d');

  var img = new Image();
  img.src = '/assets/plain_terrain.png';

  ctx.canvas.width = window.innerWidth * 0.95;
  ctx.canvas.height = window.innerHeight * 0.95;

  var SPACE_KEY = 32;
  var LEFT_KEY = 37;
  var UP_KEY = 38;
  var RIGHT_KEY = 39;
  var DOWN_KEY = 40;

  var SCREEN_WIDTH = ctx.canvas.width;
  var SCREEN_HEIGHT = ctx.canvas.height;

  var rowCount = cells.length;
  var columnCount = cells[0].length;

  var originX = 0;
  var originY = 0;

  var cellSize = 32;

  function draw() {
    ctx.clearRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    // Draw elements of the game here.
    // Can use `drawRect` and `drawCircle` function.
    // e.g. draw the ball colored green





    for (var row = 0; row < rowCount; row++) {
      for (var column = 0; column < columnCount; column++) {
        if (cells[row][column] == "shallow_water_dirt_west_u") {
          var imageX = 150
          var imageY = 100
        } else if (cells[row][column] == "shallow_water_dirt_east_u") {
          var imageX = 100
          var imageY = 100
        } else if (cells[row][column] == "shallow_water_dirt_north_u") {
          var imageX = 50
          var imageY = 100
        } else if (cells[row][column] == "shallow_water_dirt_south_u") {
          var imageX = 0
          var imageY = 100
        } else if (cells[row][column] == "shallow_water_dirt_south_east") {
          var imageX = 100
          var imageY = 50
        } else if (cells[row][column] == "shallow_water_dirt_south_west_L") {
          var imageX = 200
          var imageY = 50
        } else if (cells[row][column] == "shallow_water_dirt_north_west_L") {
          var imageX = 250
          var imageY = 0
        } else if (cells[row][column] == "shallow_water_dirt_south_east_L") {
          var imageX = 200
          var imageY = 0
        } else if (cells[row][column] == "shallow_water_dirt_north_east_L") {
          var imageX = 250
          var imageY = 50
        } else if (cells[row][column] == "shallow_water_dirt_west_shore") {
          var imageX = 0
          var imageY = 50
        } else if (cells[row][column] == "shallow_water_dirt_east_shore") {
          var imageX = 0
          var imageY = 0
        } else if (cells[row][column] == "shallow_water_dirt_north_shore") {
          var imageX = 50
          var imageY = 0
        } else if (cells[row][column] == "shallow_water_dirt_south_shore") {
          var imageX = 50
          var imageY = 50
        } else if (cells[row][column] == "shallow_water_dirt_sw_corner") {
          var imageX = 100
          var imageY = 50
        } else if (cells[row][column] == "shallow_water_dirt_se_corner") {
          var imageX = 150
          var imageY = 50
        } else if (cells[row][column] == "shallow_water_dirt_nw_corner") {
          var imageX = 100
          var imageY = 0
        } else if (cells[row][column] == "shallow_water_dirt_ne_corner") {
          var imageX = 150
          var imageY = 0





        } else if (cells[row][column] == "dirt") {
          var imageX = 32
          var imageY = 0
        } else if (cells[row][column] == "shallow_water") {
          var imageX = 128
          var imageY = 0
        } else if (cells[row][column] == "water") {
          var imageX = 0
          var imageY = 0
        } else if (cells[row][column] == "grass") {
          var imageX = 64
          var imageY = 0
        } else if (cells[row][column] == "tree") {
          var imageX = 0
          var imageY = 150
        } else if (cells[row][column] == "mountain") {
          var imageX = 96
          var imageY = 0
        } else if (cells[row][column] == "frozen_water_1") {
          var imageX = 0
          var imageY = 32
        } else if (cells[row][column] == "snow") {
          var imageX = 0
          var imageY = 64
        } else if (cells[row][column] == "snow_mountain_1") {
          var imageX = 32
          var imageY = 32
        } else if (cells[row][column] == "snow_mountain_2") {
          var imageX = 32
          var imageY = 64
        } else if (cells[row][column] == "snow_mountain_3") {
          var imageX = 64
          var imageY = 32
        } else if (cells[row][column] == "snow_mountain_4") {
          var imageX = 64
          var imageY = 64

        } else {
          var color = 'black';
        }





        ctx.drawImage(img, imageX, imageY, cellSize, cellSize, column * cellSize - originX, row * cellSize - originY, cellSize, cellSize);
      }
    }

  }

  function loop(time) {
    draw();

    window.requestAnimationFrame(function(time) {
      loop(time);
    });
  }

  function keyDown(event) {
    var handled = true;

    switch (event.keyCode) {

    // Handle user input here when a key is pressed.
    // A few key constants are defined in /js/key_codes.js
    // e.g. stops the ball from moving when pressing down the space bar

    case SPACE_KEY:

      break;

    case DOWN_KEY:
      originY += 50;
      break;

    case UP_KEY:
      originY += -50;
      break;

    case LEFT_KEY:
      originX += -50;
      break;

    case RIGHT_KEY:
      originX += 50;
      break;

    default:
      handled = false;
      break;
    }

    if (handled) {
      event.preventDefault();
    }
  }

  function keyUp(event) {
    var handled = true;

    switch (event.keyCode) {

    // Handle user input here when a key is released.
    // A few key constants are defined in /js/key_codes.js
    // e.g. starts the ball moving again when releasing space bar

    case SPACE_KEY:
      break;

    case DOWN_KEY:

      break;

    default:
      handled = false;
      break;
    }

    if (handled) {
      event.preventDefault();
    }
  }

  function run() {
    window.onkeydown = keyDown;
    window.onkeyup = keyUp;

    window.requestAnimationFrame(function(time) {
      loop(time);
    });
  }

  run();
});
