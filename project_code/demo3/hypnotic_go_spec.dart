import 'dart:html';
import 'fish.dart';
import 'gotext.dart';
import 'dart:async';
import 'dart:math' as Math;

List<Fish> fishes;
num lastStamp = 0.0;

void main() {
  CanvasElement main = querySelector("#main_canvas");
  int width = main.width;
  int height = main.height;
  CanvasRenderingContext2D mainCtxt = main.getContext("2d");
  mainCtxt.fillStyle = "rgba(0, 0, 0, 1)";
  mainCtxt.fillRect(0,0,width,height);
  SpecText gospec = new SpecText();
  fishes = makeFishs(width, height);
  Stopwatch watch = new Stopwatch();
  watch.start();
//  var timerTxt = new Timer.periodic(new Duration(seconds:1), (Timer timer) => nextLetter(gospec));
  window.animationFrame.then(loop);
}

List<Fish> makeFishs(int width, int height) {
  List<Fish> Fishs = new List<Fish>();
  for (int i = 0; i < 10000; i++) {
    Fishs.add(new Fish(width, height));
  }
  return Fishs;
}

void nextLetter(SpecText gospec) {
  CanvasElement txt = querySelector("#text_canvas");
  int height = txt.height;
  int width = txt.width;
  CanvasRenderingContext2D textCtxt = txt.getContext("2d");
  textCtxt.fillStyle = "rgba(255, 255, 255, 1)";
  textCtxt.fillRect(0,0,width,height);
  textCtxt.fillStyle = "rgba(0, 0, 0, 1)";
  textCtxt.font = "bold " + height.toString() + "px sans-serif";
  textCtxt.textAlign = "center";
  textCtxt.textBaseline = "middle";
  textCtxt.fillText(gospec.nextChar(), width/2, height/2 - 5);
}

void loop(num delta) {
  if (lastStamp == 0.0) {
    lastStamp = delta;
  }
  print(delta - lastStamp);
  lastStamp = delta;
  for (Fish fish in fishes) {
    fish.push();
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