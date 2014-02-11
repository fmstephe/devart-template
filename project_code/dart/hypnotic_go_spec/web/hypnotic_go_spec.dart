import 'dart:html';
import 'gotext.dart';
import 'particle.dart';
import 'dart:async';
import 'dart:math';

List<Particle> particles;
num lastStamp = 0.0;

void main() {
  CanvasElement main = querySelector("#main_canvas");
  int width = main.width;
  int height = main.height;
  CanvasRenderingContext2D mainCtxt = main.getContext("2d");
  mainCtxt.fillStyle = "rgba(0, 0, 0, 1)";
  mainCtxt.fillRect(0,0,width,height);
  SpecText gospec = new SpecText();
  particles = makeParticles(width, height);
  Stopwatch watch = new Stopwatch();
  watch.start();
//  var timerTxt = new Timer.periodic(new Duration(seconds:1), (Timer timer) => nextLetter(gospec));
  window.animationFrame.then(loop);
}

List<Particle> makeParticles(int width, int height) {
  List<Particle> particles = new List<Particle>();
  for (int i = 0; i < 10000; i++) {
    particles.add(new Particle(width, height));
  }
  return particles;
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
  for (Particle particle in particles) {
    particle.push();
    particle.move();
  }
  render(particles);
  window.requestAnimationFrame(loop);
}

void render(List<Particle> particles) {
  CanvasElement main = querySelector("#main_canvas");
  int width = main.width;
  int height = main.height;
  CanvasRenderingContext2D mainCtxt = main.getContext("2d");
  mainCtxt.fillStyle = "rgba(0, 0, 0, 0.05)";
  mainCtxt.fillRect(0,0,width,height);
  mainCtxt.fillStyle = "rgba(255, 180, 180, 0.1)";
  for (Particle particle in particles) {
    mainCtxt.beginPath();
    mainCtxt.arc(particle.getX(), particle.getY(), 1, 0, PI*2, false);
    mainCtxt.closePath();
    mainCtxt.fill();
  }
}