import 'dart:html';
import 'dart:async';
import 'dart:math' as Math;

List<Fish> fishes;
num lastStamp = 0.0;
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
  SpecText gospec = new SpecText();
  fishes = makeFish(width, height);
  cycleText(gospec);
  var timerTxt = new Timer.periodic(new Duration(seconds:18), (Timer timer) => cycleText(gospec));
  window.animationFrame.then(loop);
}

List<Fish> makeFish(int width, int height) {
  List<Fish> Fishs = new List<Fish>();
  for (int i = 0; i < 10000; i++) {
    Fishs.add(new Fish(width, height));
  }
  return Fishs;
}

void cycleText(SpecText gospec) {
  print("Blanked");
  CanvasElement txt = querySelector("#text_canvas");
  height = txt.height;
  int width = txt.width;
  CanvasRenderingContext2D textCtxt = txt.getContext("2d");
  textCtxt.fillStyle = "rgba(0, 0, 0, 1)";
  textCtxt.fillRect(0, 0, width, height);
  data = textCtxt.getImageData(0, 0, width, height).data;
  clearLetter = true;
  new Future.delayed(new Duration(seconds:4), () => nextLetter(gospec));
}

void nextLetter(SpecText gospec) {
  String char = gospec.nextChar();
  if (char == null) {
    new Future.delayed(new Duration(seconds:1), () => nextLetter(gospec));
    return;
  }
  clearLetter = false;
  print("New Char");
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

void loop(num delta) {
  if (lastStamp == 0.0) {
    lastStamp = delta;
  }
//  print(delta - lastStamp);
  lastStamp = delta;
  for (Fish fish in fishes) {
    if (clearLetter) {
      fish.speedUp2D();
    } else {
      if (rnd.nextDouble() > 0.70) {
        if (!isColored(fish.getX(), fish.getY())) {
          fish.speedUp2D();
        } else {
          fish.slowDown2D();
        }
      }
    }
  fish.pushRandom();
  fish.move();
  }
  renderMain(fishes);
  window.requestAnimationFrame(loop);
}

void renderMain(List<Fish> fishes) {
  CanvasElement main = querySelector("#main_canvas");
  int width = main.width;
  int height = main.height;
  CanvasRenderingContext2D mainCtxt = main.getContext("2d");
  mainCtxt.fillStyle = "rgba(0, 0, 0, 0.2)";
  mainCtxt.fillRect(0,0,width,height);
  mainCtxt.fillStyle = "rgba(255, 180, 180, 0.1)";
  for (Fish fish in fishes) {
    mainCtxt.beginPath();
    mainCtxt.arc(fish.getX(), fish.getY(), fish.getZ(), 0, Math.PI*2, false);
    mainCtxt.closePath();
    mainCtxt.fill();
  }
}

bool isColored(double x, double y) {
  int idx = (y.floor() * height + x.floor()) * 4;
  return idx < data.length && data[idx] < 255;
}

class Fish {
  
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
  
  Fish(int width, int height) {
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
    push(vx, vy, vz);
  }
  
  void move() {
    _x += _vx;
    _y += _vy;
    _z += _vz;
    if (_x < 0) {
      _x = -_x;
      _vx = -_vx;
    }
    if (_x > _width) {
      _x = _width - (_x - _width);
      _vx = -_vx;
    }
    if (_y < 0) {
      _y = -_y;
      _vy = -_vy;
    }
    if (_y > _height) {
      _y = _height - (_y - _height);
      _vy = -_vy;
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
  
  void pushRandom() {
    double vx = (_impulse - (_rnd.nextDouble() * (2*_impulse))) * _impulseScaler;
    double vy = (_impulse - (_rnd.nextDouble() * (2*_impulse))) * _impulseScaler;
    double vz = (_impulse - (_rnd.nextDouble() * (2*_impulse))) * _impulseScaler;
    push(vx, vy, vz);
  }
  
  void push(double px, double py, double pz) {
    _vx += px;
    _vy += py;
    _vz += pz;
    _vx = Math.max(Math.min(_vx, maxV2D), -maxV2D);
    _vy = Math.max(Math.min(_vy, maxV2D), -maxV2D);
    _vz = Math.max(Math.min(_vz, maxVZ), -maxVZ);
  }
  
  void speedUp2D() {
    push(_vx/changeDivisor, _vy/changeDivisor, _vz/changeDivisor);
  }
  
  void slowDown2D() {
    push(-_vx/changeDivisor, -_vy/changeDivisor, _vz/changeDivisor);
  }

}

class SpecText {
  
  String _text = null;
  int _idx = 0;
  
  SpecText() {
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