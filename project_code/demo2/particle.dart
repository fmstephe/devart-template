import 'dart:math';

class Particle {
  
  static Random _rnd = new Random();
  static double _impulse = 0.005;
  static double _initImpulseSaler = 120.0;
  static double _impulseScaler = 6.0;
  
  double _x;
  double _y;
  double _vx;
  double _vy;
  double _width;
  double _height;
  
  Particle(int width, int height) {
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
  
  void place() {
    _x = _rnd.nextDouble() * _width;
    _y = _rnd.nextDouble() * _height;
    _vx = (_impulse - (_rnd.nextDouble() * (2*_impulse))) * _initImpulseSaler;
    _vy = (_impulse - (_rnd.nextDouble() * (2*_impulse))) * _initImpulseSaler;
  }
  
  void move() {
    _x += _vx;
    _y += _vy;
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
  }
  
  void push() {
    _vx += (_impulse - (_rnd.nextDouble() * (2*_impulse))) * _impulseScaler;
    _vy += (_impulse - (_rnd.nextDouble() * (2*_impulse))) * _impulseScaler;
  }

}