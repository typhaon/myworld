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
  img.src = '/assets/terrain.png';

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

  function draw() {
    ctx.clearRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    // Draw elements of the game here.
    // Can use `drawRect` and `drawCircle` function.
    // e.g. draw the ball colored green

    var cellSize = 30;



    for (var row = 0; row < rowCount; row++) {
      for (var column = 0; column < columnCount; column++) {
        if (cells[row][column] == "water") {
          var imageX = 10
          var imageY = 10
        } else if (cells[row][column] == "rock") {
          var imageX = 210
          var imageY = 10
        } else if (cells[row][column] == "shallow_water") {
          var imageX = 60
          var imageY = 10
        } else if (cells[row][column] == "grass") {
          var imageX = 110
          var imageY = 10
        } else if (cells[row][column] == "dirt") {
          var imageX = 160
          var imageY = 10
        } else if (cells[row][column] == "ice") {
          var color = 'seashell'
        } else if (cells[row][column] == "mud") {
          var color = 'lightgray'
        } else {
          var color = 'black';
        }





        ctx.drawImage(img, imageX, imageY, cellSize, cellSize, column * cellSize, row * cellSize, cellSize, cellSize);
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
      // do something in here
      break;

    case DOWN_KEY:
      camera.moveDown = true;
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
      camera.moveDown = false;
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
