import 'dart:core';
import 'dart:html';
import 'dart:async';
import 'dart:math' as Math;

List<Dust> dustParticles;
double expectedDelta = 100.0;
Math.Random rnd = new Math.Random();
int height;
List<int> data;
bool clearLetter = true;

void main() {
  CanvasElement main = querySelector("#main_canvas");
  int width = main.width;
  int height = main.height;
  CanvasRenderingContext2D mainCtxt = main.getContext("2d");
  mainCtxt.fillStyle = "rgba(0, 0, 0, 1)";
  mainCtxt.fillRect(0,0,width,height);
  SourceCode sourceCode = new SourceCode();
  dustParticles = makeDust(width, height);
  cycleText(sourceCode);
  Stopwatch stopwatch = new Stopwatch();
  stopwatch.start();
  var loopTxt = new Timer.periodic(new Duration(milliseconds:expectedDelta.round()), (Timer timer) => loop(stopwatch));
  var timerTxt = new Timer.periodic(new Duration(seconds:18), (Timer timer) => cycleText(sourceCode));
}

List<Dust> makeDust(int width, int height) {
  List<Dust> dustParticles = new List<Dust>();
  for (int i = 0; i < 10000; i++) {
    dustParticles.add(new Dust(width, height));
  }
  return dustParticles;
}

void cycleText(SourceCode sourceCode) {
  print("Blanked");
  CanvasElement txt = querySelector("#text_canvas");
  height = txt.height;
  int width = txt.width;
  CanvasRenderingContext2D textCtxt = txt.getContext("2d");
  textCtxt.fillStyle = "rgba(0, 0, 0, 1)";
  textCtxt.fillRect(0, 0, width, height);
  data = textCtxt.getImageData(0, 0, width, height).data;
  clearLetter = true;
  new Future.delayed(new Duration(seconds:2), () => nextLetter(sourceCode));
}

void nextLetter(SourceCode sourceCode) {
  String char = sourceCode.nextChar();
  if (char == null) {
    new Future.delayed(new Duration(seconds:1), () => nextLetter(sourceCode));
    return;
  }
  clearLetter = false;
  print("New Char \"" + char + "\"");
  CanvasElement txt = querySelector("#text_canvas");
  height = txt.height;
  int width = txt.width;
  CanvasRenderingContext2D textCtxt = txt.getContext("2d");
  textCtxt.fillStyle = "rgba(255, 255, 255, 1)";
  textCtxt.fillRect(0, 0, width, height);
  textCtxt.fillStyle = "rgba(0, 0, 0, 1)";
  textCtxt.font = "bold " + height.toString() + "px sans-serif";
  textCtxt.textAlign = "center";
  textCtxt.textBaseline = "middle";
  textCtxt.fillText(char, width/2, height/2 - 5);
  data = textCtxt.getImageData(0, 0, width, height).data;
}

void loop(Stopwatch stopwatch) {
  double delta = stopwatch.elapsedMilliseconds * 1.0;
  print(delta);
  stopwatch.reset();
  for (Dust dust in dustParticles) {
    if (clearLetter) {
      dust.speedUp2D(delta);
    } else {
      if (rnd.nextDouble() > 0.70) {
        if (!isColored(dust.getX(), dust.getY())) {
          dust.speedUp2D(delta);
        } else {
          dust.slowDown2D(delta);
        }
      }
    }
  dust.pushRandom(delta);
  dust.move(delta);
  }
  window.requestAnimationFrame(renderMain);
}

void renderMain(num delta) {
  CanvasElement main = querySelector("#main_canvas");
  int width = main.width;
  int height = main.height;
  CanvasRenderingContext2D mainCtxt = main.getContext("2d");
  mainCtxt.fillStyle = "rgba(0, 0, 0, 0.2)";
  mainCtxt.fillRect(0,0,width,height);
  mainCtxt.fillStyle = "rgba(255, 180, 180, 0.1)";
  for (Dust dust in dustParticles) {
    mainCtxt.beginPath();
    mainCtxt.arc(dust.getX(), dust.getY(), dust.getZ(), 0, Math.PI*2, false);
    mainCtxt.closePath();
    mainCtxt.fill();
  }
}

bool isColored(double x, double y) {
  int idx = (y.floor() * height + x.floor()) * 4;
  return idx < data.length && data[idx] < 255;
}

class Dust {
  
  static final Math.Random _rnd = new Math.Random();
  static final double _impulse = 0.003;
  static final double _initImpulseSaler = 60.0;
  static final double _initZImpulseSaler = 6.0;
  static final double _impulseScaler = 6.0;
  static final double maxNear = 2.0;
  static final double maxFar = 0.3;
  static final double maxV2D = _impulse * _initImpulseSaler;
  static final double maxVZ = _impulse * _initZImpulseSaler;
  static final double changeDivisor = 4.0;
  
  double _x;
  double _y;
  double _z;
  double _vx;
  double _vy;
  double _vz;
  double _width;
  double _height;
  
  Dust(int width, int height) {
    _width = width * 1.0;
    _height = height * 1.0;
    place();
  }
  
  double getX() {
    return _x;
  }
  
  double getY() {
    return _y;
  }
  
  double getZ() {
    return _z;
  }
  
  void place() {
    _x = _rnd.nextDouble() * _width;
    _y = _rnd.nextDouble() * _height;
    _z = _rnd.nextDouble() * (maxNear - maxFar) + maxFar;
    _vx = 0.0;
    _vy = 0.0;
    _vz = 0.0;
    double vx = (_impulse - (_rnd.nextDouble() * (2*_impulse))) * _initImpulseSaler;
    double vy = (_impulse - (_rnd.nextDouble() * (2*_impulse))) * _initImpulseSaler;
    double vz = (_impulse - (_rnd.nextDouble() * (2*_impulse))) * _initZImpulseSaler;
    push(vx, vy, vz, expectedDelta);
  }
  
  void move(double delta) {
    double r = normaliseDelta(delta);
    _x += r * _vx;
    _y += r * _vy;
    _z += r * _vz;
    if (_x < 0) {
      _x = _width + _x;
    }
    if (_x > _width) {
      _x = _x - _width;
    }
    if (_y < 0) {
      _y = _height + _y;
    }
    if (_y > _height) {
      _y = _y - _height;
    }
    if (_z < maxFar) {
      _z = maxFar + (maxFar - _z);
      _vz = -_vz;
    }
    if (_z > maxNear) {
      _z = maxNear + (_z - maxNear);
      _vz = -_vz;
    }
  }
  
  void pushRandom(double delta) {
    double vx = (_impulse - (_rnd.nextDouble() * (2*_impulse))) * _impulseScaler;
    double vy = (_impulse - (_rnd.nextDouble() * (2*_impulse))) * _impulseScaler;
    double vz = (_impulse - (_rnd.nextDouble() * (2*_impulse))) * _impulseScaler;
    push(vx, vy, vz, delta);
  }
  
  void speedUp2D(double delta) {
    push(_vx/changeDivisor, _vy/changeDivisor, _vz/changeDivisor, delta);
  }
  
  void slowDown2D(double delta) {
    push(-_vx/changeDivisor, -_vy/changeDivisor, _vz/changeDivisor, delta);
  }
  
  void push(double px, double py, double pz, double delta) {
    double r = normaliseDelta(delta);
    _vx += r * px;
    _vy += r * py;
    _vz += r * pz;
    _vx = Math.max(Math.min(_vx, maxV2D), -maxV2D);
    _vy = Math.max(Math.min(_vy, maxV2D), -maxV2D);
    _vz = Math.max(Math.min(_vz, maxVZ), -maxVZ);
  }
  
  double normaliseDelta(double delta) {
    return delta / expectedDelta;
  }

}

class SourceCode {
  
  String _text = null;
  int _idx = 0;
  
  SourceCode() {
    HttpRequest.request(Uri.base.origin + "/hypnotic_go_spec.dart").then((HttpRequest request) => (_text = request.responseText));
  }
  
  String nextChar() {
    if (_text == null) {
      return null;
    }
    int idx = _idx%_text.length;
    var c = _text.substring(idx, idx+1);
    _idx++;
    return c.toUpperCase();
  }
}