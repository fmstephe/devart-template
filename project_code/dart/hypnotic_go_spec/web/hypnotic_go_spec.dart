import 'dart:html';
import 'gotext.dart';
import 'dart:async';

void main() {
  SpecText gospec = new SpecText();
  print(gospec.nextChar());
  print(gospec.nextChar());
  print(gospec.nextChar());
  print(gospec.nextChar());
  print(gospec.nextChar());
  print(gospec.nextChar());
  var timer = new Timer.periodic(new Duration(seconds:10), (Timer timer) => nextLetter(gospec));
}

void nextLetter(SpecText gospec) {
  var txt = querySelector("#text_canvas");
  var ctxt = txt.getContext("2d");
  var hgt = txt.height;
  var wdt = txt.width;
  ctxt.fillStyle = "rgba(255, 255, 255, 1)";
  ctxt.fillRect(0,0,wdt,hgt);
  ctxt.fillStyle = "rgba(0, 0, 0, 1)";
  ctxt.font = "bold " + hgt.toString() + "px sans-serif";
  ctxt.textAlign = "center";
  ctxt.textBaseline = "middle";
  ctxt.fillText(gospec.nextChar(), wdt/2, hgt/2 - 5);
}