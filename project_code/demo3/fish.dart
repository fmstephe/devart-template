library fish;

import 'dart:math';

class Fish {
  
  static final double maxNear = 3.0;
  static final double maxFar = 0.3;
  
  static Random _rnd = new Random();
  static double _impulse = 0.005;
  static double _initImpulseSaler = 60.0;
  static double _impulseScaler = 3.0;
  
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
    _vx = (_impulse - (_rnd.nextDouble() * (2*_impulse))) * _initImpulseSaler;
    _vy = (_impulse - (_rnd.nextDouble() * (2*_impulse))) * _initImpulseSaler;
    _vz = (_impulse - (_rnd.nextDouble() * (2*_impulse))) * _impulseScaler;
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
  
  void push() {
    _vx += (_impulse - (_rnd.nextDouble() * (2*_impulse))) * _impulseScaler;
    _vy += (_impulse - (_rnd.nextDouble() * (2*_impulse))) * _impulseScaler;
    _vz += (_impulse - (_rnd.nextDouble() * (2*_impulse)));
  }

}