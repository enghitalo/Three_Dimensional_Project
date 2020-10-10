// import 'dart:html';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:vector_math/vector_math_64.dart';
import 'main.dart';
import 'dart:math';
// import 'package:flutter/rendering.dart';

List temporare_value;


rotateX(theta) {
  // Vector2(x,y).scaleOrthogonalInto(scale, out);
  // Vector3(x,y,z).applyProjection(arg);
  // Vector3(x,y,z).applyAxisAngle(axis, angle);
  // Vector3(x,y,z).applyQuaternion(arg);
  // Vector3(x,y,z).scale(arg);
  // Vector3(x,y,z).normalize();
  // Vector4(x,y,z,w).normalize();
  // Quaternion(x,y,z,w).scale(scale);
  // Quaternion().rotate(v).applyProjection(arg);
  // Quaternion().setAxisAngle(axis, radians);



  temporare_value = [];
  var x;
  var y;
  var z;
  List node = [];
  List t_node = [];
  node = list_of_accessors[file_content_map['meshes'][0]['primitives'][0]
      ['attributes']['POSITION']];

  for (var n = 0; n < node.length; n++) {
    x = node[n][0];
    y = node[n][1];
    z = node[n][2];
    y = y * cos(theta) - z * sin(theta);
    z = z * cos(theta) + y * sin(theta);
    t_node.add([
      x, y, z
    ]);

    lista_de_offset_dx_dy_vertices.replaceRange(n, n + 1, [Offset(x, y)]);
  }
  list_of_accessors.replaceRange(
      file_content_map['meshes'][0]['primitives'][0]['attributes']['POSITION'],
      file_content_map['meshes'][0]['primitives'][0]['attributes']['POSITION'] +
          1,
      [t_node]);
// print(list_of_accessors);
}








rotateY(theta) {
  var x;
  var y;
  var z;
  List node = [];
  List t_node = [];
  node = list_of_accessors[file_content_map['meshes'][0]['primitives'][0]
      ['attributes']['POSITION']];

  for (var n = 0; n < node.length; n++) {
    x = node[n][0];
    y = node[n][1];
    z = node[n][2];
    x = x * cos(theta) + z * sin(theta);
    z = z * cos(theta) - x * sin(theta);

    t_node.add([
      x, y, z
    ]);

    lista_de_offset_dx_dy_vertices.replaceRange(n, n + 1, [Offset(x, y)]);
  }
  list_of_accessors.replaceRange(
      file_content_map['meshes'][0]['primitives'][0]['attributes']['POSITION'],
      file_content_map['meshes'][0]['primitives'][0]['attributes']['POSITION'] +
          1,
      [t_node]);

}

rotateZ(theta) {
  var x;
  var y;
  var z;
  List node = [];
  List t_node = [];
  node = list_of_accessors[file_content_map['meshes'][0]['primitives'][0]
      ['attributes']['POSITION']];

  for (var n = 0; n < node.length; n++) {
    x = node[n][0];
    y = node[n][1];
    z = node[n][2];
    x = x * cos(theta) - y * sin(theta);
    y = y * cos(theta) + x * sin(theta);
    t_node.add([
      x, y, z
    ]);

    lista_de_offset_dx_dy_vertices.replaceRange(n, n + 1, [Offset(x, y)]);
  }
  list_of_accessors.replaceRange(
      file_content_map['meshes'][0]['primitives'][0]['attributes']['POSITION'],
      file_content_map['meshes'][0]['primitives'][0]['attributes']['POSITION'] +
          1,
      [t_node]);

}
