import 'dart:html';
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart' as VM;
import 'package:three/three.dart' as THREE;

double WIDTH= 400.0;
double HEIGHT = 300.0;

double VIEW_ANGLE = 45.0;
double ASPECT = WIDTH/HEIGHT;
double NEAR = 0.1;
double FAR = 10 * 1000.0;

THREE.WebGLRenderer renderer = new THREE.WebGLRenderer();
THREE.PerspectiveCamera camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR);
THREE.Scene scene = new THREE.Scene();
THREE.PointLight light = new THREE.PointLight(0xFFFFFF);

void main() {
  Element container = querySelector("#container");
  scene.add(camera);
  camera.position.z = 300.0;
  renderer.setSize(WIDTH, HEIGHT);
  container.append(renderer.domElement);
  
  // Sphere vars
  double radius = 50.0;
  int segments = 16;
  int rings = 16;
  
  /**
  // Create material
  THREE.MeshLambertMaterial material = new THREE.MeshLambertMaterial(color: 0xCC0000, overdraw: true);
  // Create sphere geometry
  THREE.SphereGeometry sphereGeo = new THREE.SphereGeometry(radius, segments, rings);
  // Create sphere mesh
  THREE.Mesh sphere = new THREE.Mesh(sphereGeo, material);
  sphere.isDynamic = true;
  scene.add(sphere);
  */
  
  int particleCount = 100;
  
  THREE.GeometryAttribute positions = new THREE.GeometryAttribute.float32(particleCount * 3, 3);
  THREE.GeometryAttribute colors     = new THREE.GeometryAttribute.float32(particleCount * 3, 3);
  
  THREE.Geometry geometry = new THREE.BufferGeometry()..attributes = {
                                                                       "position": positions,
                                                                       "color": colors
  };
  THREE.ParticleBasicMaterial material = new THREE.ParticleBasicMaterial(color: 0xFFFFFF, size: 20);
  Math.Random rnd = new Math.Random();
  THREE.Color color = new THREE.Color();
  for (int i = 0; i < particleCount; i++) {
    double x = rnd.nextDouble() * 500 - 250;
    double y = rnd.nextDouble() * 500 - 250;
    double z = rnd.nextDouble() * 500 - 250;
    positions.array[ i     ] = x;
    positions.array[ i + 1 ] = y;
    positions.array[ i + 2 ] = z;
    double vx = ( x ) + 0.5;
    double vy = ( y ) + 0.5;
    double vz = ( z ) + 0.5;
    color.setRGB(vx, vy, vz);
    colors.array[ i ]     = color.r;
    colors.array[ i + 1 ] = color.g;
    colors.array[ i + 2 ] = color.b;
  }
  
  geometry.computeBoundingSphere();
  
  THREE.ParticleSystem particleSystem = new THREE.ParticleSystem(geometry, material);
  
  scene.add(particleSystem);
  
  light.position.x = 10.0;
  light.position.y = 50.0;
  light.position.z = 130.0;
  light.isDynamic = true;
  
  scene.add(light);
  
  render(0);
}

void render(num delta) {
  light.position.x++;
  light.position.y++;
  light.position.z++;
  print(delta);
  renderer.render(scene, camera);
  window.requestAnimationFrame(render);
}
