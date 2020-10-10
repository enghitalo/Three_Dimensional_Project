import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'camera.dart';
import 'dart:io';
import 'dart:math';

List list_of_accessors = [];
var arquivo =
    'C:/Users/hital/Downloads/glTF-Sample-Models-master/2.0/SimpleSparseAccessor/glTF/SimpleSparseAccessor';

//Triangle Without Indices
//Triangle
//Animated Triangle
//Animated Morph Cube
//Animated Morph Sphere
//Simple Meshes
//Simple Morph
//simpleSparseAccessorStructure 2KB [buffer[ok],image[],sampler[]],[BufferView[ok],texture[]],[acessors[ok],material[]],[mesh[ok],camera[],skin[],animation[]],node[],scene[]
//Cameras
//Interpolation Test

//Box0 (1) 1BK mesh[ok]
//Box Interleaved
//Box Textured
//Box Textured NPOT
//Box Vertex Colors
//Duck
//2 Cylinder Engine
//Reciprocating Saw
//Gearbox Assy
//Buggy
//Box Animated //Rotation and Translation Animations. Start with this to test animations.
//Cesium Milk Truck
//Rigged Simple //Animations. Skins. Start with this to test skinning.
//Rigged Figure
//Cesium Man
//BrainStem
//Fox 118KB
//Virtual City
//Sponza

//Alpha Blend Mode Test
//Boom Box With Axes
//Metal Rough Spheres
//Metal Rough Spheres (Textureless)
//Morph Primitives Test
//Multi UV Test
//Normal Tangent Test
//Normal Tangent Mirror Test
//Orientation Test
//Texture Coordinate Test
//Texture Settings Test
//Vertex Color Test

var directory_gltf;
List directory_bin_path;
var escala = 1.0;

var file_content = File(directory_gltf.path).readAsStringSync();
var file_content_map = json.decode(file_content);
List<Offset> lista_de_offset_dx_dy_vertices = [];
List<Vertices> list_of_vertices = [];
List<int> indice = [];
List<Color> lista_de_cores_vertices = [Color(0xFFFF0000), Color(0xFFFF0000)];
bool whilePressedx = false;
bool whilePressedy = false;
bool whilePressedz = false;
// var chunks_accessor = [];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'title(MaterialApp)',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Title(MyHomePage)'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void initState() {
    super.initState();
    
    gltf_reader();
    Future.delayed(Duration.zero, () {
      directory_gltf = Directory('$arquivo.gltf');
      print(file_content_map);
      for (var i = 0; i < file_content_map['buffers'].length; i++) {
        print(i);
        directory_bin_path.add(Directory(
            arquivo.replaceRange(arquivo.lastIndexOf('/'), arquivo.length, '') +
                '/' +
                file_content_map['buffers'][i]['uri']));
      }

      // file_content_map['buffers'][0]['uri'];
    });
  }

  int _counter = 0;

  bool _buttonPressed = false;
  bool _loopActive = false;

  void _increaseCounterWhilePressed() async {
    //if (_loopActive) return;

    //_loopActive = true;

    while (_buttonPressed) {
      // do your thing
      _counter++;
      setState(() {
        if (whilePressedx) {
          rotateX(pi / 180);
        }
      });
      setState(() {
        if (whilePressedy) {
          rotateY(pi / 180);
        }
      });
      setState(() {
        if (whilePressedz) {
          rotateZ(pi / 180);
        }
      });

      await Future.delayed(Duration(milliseconds: 1));
    }

    //_loopActive = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
          ),
        ),
        child: Column(
          children: <Widget>[
            Text('data'),
            Text('data'),
            Text('data'),
            Text(_counter.toString()),
            Listener(
                onPointerDown: (details) {
                  _buttonPressed = true;
                  whilePressedx = true;
                  _increaseCounterWhilePressed();
                },
                onPointerUp: (details) {
                  _buttonPressed = false;
                  whilePressedx = false;
                },
                child: ButtonBar(
                  layoutBehavior: ButtonBarLayoutBehavior.padded,
                  mainAxisSize: MainAxisSize.max,
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      width: 90,
                      height: 35,
                      child: Text('X'),
                      color: Colors.grey[300],
                    ),
                  ],
                )),
            Listener(
              onPointerDown: (details) {
                _buttonPressed = true;
                whilePressedy = true;
                _increaseCounterWhilePressed();
              },
              onPointerUp: (details) {
                _buttonPressed = false;
                whilePressedy = false;
              },
              child: RaisedButton(
                onPressed: () {},
                child: Text('Y'),
                elevation: 5,
              ),
            ),
            Listener(
              onPointerDown: (details) {
                _buttonPressed = true;
                whilePressedz = true;
                _increaseCounterWhilePressed();
              },
              onPointerUp: (details) {
                _buttonPressed = false;
                whilePressedz = false;
              },
              child: RaisedButton(
                onPressed: () {},
                child: Text('Z'),
                elevation: 5,
              ),
            ),
            CustomPaint(
              willChange: true,
              painter: Three_Dimensional_Painter(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _counter++;

            gltf_reader();
            bin_reader();
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Three_Dimensional_Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    var path = Path();

    canvas.translate(size.height * .5, size.height * .5);
    escala = 100;
    canvas.scale(escala, -escala);

    paint.color = Colors.black;
    paint.strokeWidth = .01;
    paint.style = PaintingStyle.stroke;

    var paint_line = Paint();
    paint_line.color = Colors.black;
    paint_line.strokeWidth = 3;
    paint_line.style = PaintingStyle.stroke;

    for (var i = 0;
        i < file_content_map['meshes'][0]['primitives'].length;
        i++) {
      //Drawn
      // for (var j = 0; j < indice.length - 1; j++) {
      //   if (j == 0) {
      //     path.moveTo(0, 0);
      //   } else {
      //     path.lineTo(
      //         list_of_accessors[file_content_map['meshes'][0]['primitives'][0]
      //             ['attributes']['POSITION']][indice[i]][0],
      //         list_of_accessors[file_content_map['meshes'][0]['primitives'][0]
      //             ['attributes']['POSITION']][indice[i]][1]);

      //     // path.close();
      //     canvas.drawPath(path, paint);
      //   }

      //   // print(list_of_accessors[file_content_map['meshes'][0]['primitives'][0]
      //   //     ['attributes']['POSITION']][indice[1]]);
      // }
      //----------------------------------------------------------------

    }
    double d = 0.5;
// paint_line;
    paint_line.color.withOpacity(.5);
    canvas.drawVertices(
        Vertices(VertexMode.triangles, lista_de_offset_dx_dy_vertices,
            colors: lista_de_cores_vertices, indices: indice),
        BlendMode.darken,
        paint_line);

    canvas.drawVertices(
        Vertices(VertexMode.triangles, lista_de_offset_dx_dy_vertices,
            indices: indice),
        BlendMode.darken,
        paint_line);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint

    return true;
  }
}

Future<void> bin_reader() {
  print(arquivo.replaceRange(arquivo.lastIndexOf('/'), arquivo.length, '') +
      '/' +
      file_content_map['buffers'][0]['uri']);
  // chunks_accessor.clear();
  lista_de_offset_dx_dy_vertices.clear();
  lista_de_cores_vertices.clear();
  list_of_accessors.clear();
  // directory_bin_path.clear();

  // buffers
  // Future.delayed(Duration.zero, () {
  //   directory_gltf = Directory('$arquivo.gltf');
  //   for (var i = 0; i < file_content_map['buffers'].length; i++) {
  //     directory_bin_path.add(Directory(file_content_map['buffers'][i]['uri']));
  //   }
  //   // file_content_map['buffers'][0]['uri'];
  // });

  // BufferView
  List list_of_bufferviews = [];

  for (var i = 0; i < file_content_map['bufferViews'].length; i++) {
    print('i $i');
    print('file_content_map['
        'bufferViews'
        '][i]['
        'buffer'
        ']: ${directory_bin_path[0]}');

    Map content_to_offset = file_content_map['bufferViews'][i];

    list_of_bufferviews.add(File(
            directory_bin_path[file_content_map['bufferViews'][i]['buffer']]
                .path)
        .readAsBytesSync()
        .sublist(content_to_offset['byteOffset'],
            content_to_offset['byteOffset'] + content_to_offset['byteLength'])
        .buffer);
    print('bmn');
  }
  // print('list_of_bufferviews [concluido] valor: ${list_of_bufferviews} ');
  // -----------------------------------------------------------------------------------
  // -----------------------------------------------------------------------------------
  // Accessor
  Map<String, int> type_map = {
    'SCALAR': 1,
    'VEC2': 2,
    'VEC3': 3,
    'VEC4': 4,
    'MAT2': 4,
    'MAT3': 9,
    'MAT4': 16,
  };
  Map componentType_byte_size_map = {
    5120: 1,
    5121: 1,
    5122: 2,
    5123: 2,
    5125: 4,
    5126: 4,
  };
  for (var i = 0; i < file_content_map['accessors'].length; i++) {
// Declarando variáveis
    List t_sparse_list_of_accessors = [];
    List t_list_of_accessors = [];
    List t2_list_of_accessors = [];
    var a = file_content_map['accessors'][i];
    // print('a ${a}');
    int offset = 0;
    int count = 0;
    var sparse_offset = 0;
    var sparse_count = 0;
    var componentType = a['componentType'];
    var endereco_bufferView = a['bufferView'];
    var byteStride = 0;

// ----------------------------------------------------------------
//setando count e offset das fitas de bytes
    if (a.containsKey('byteOffset')) {
      offset = a['byteOffset'];
    }
    if (a.containsKey('count')) {
      count = a['count'] * type_map[a['type']];
    }
    if (a.containsKey('sparse')) {
      if (a['sparse']['values'].containsKey('byteOffset')) {
        sparse_offset = a['sparse']['values']['byteOffset'];
      }
      if (a['sparse'].containsKey('count')) {
        sparse_count = a['sparse']['count'];
      }
    }
// ---------------------------------------------------------------

    if (file_content_map['bufferViews'][endereco_bufferView]
        .containsKey('byteStride')) {
      byteStride =
          file_content_map['bufferViews'][endereco_bufferView]['byteStride'];
    } else {
      byteStride =
          type_map[a['type']] * componentType_byte_size_map[componentType];
    }
// ---------------------------------------------------------------
    list_of_accessors.add(
        list_of_bufferviews[endereco_bufferView].asUint8List(offset, count));
// ---------------------------------------------------------------
    print(list_of_accessors);
    //acessor offset       //ByteStride            //casas ocupadas

    var fita_de_bytes_preparada = list_of_bufferviews[endereco_bufferView]
        .asUint8List(offset)
        .buffer
        .asUint8List(0, byteStride)
        .buffer
        .asUint8List(0, type_map[a['type']]);

    // print('fita_de_bytes_preparada:  ${fita_de_bytes_preparada.buffer.asUint8List(288,24)}');

    var fita_de_bytes_sparse_preparada;
    if (a.containsKey('sparse')) {
      fita_de_bytes_sparse_preparada =
          list_of_bufferviews[a['sparse']['values']['bufferView']].asUint8List(
              sparse_offset, a['sparse']['count'] * type_map[a['type']]);
    }

    if (componentType == 5120) {
      t2_list_of_accessors
          .add(fita_de_bytes_preparada.buffer.asInt8List(offset, count));
      if (a.containsKey('sparse')) {
        t_sparse_list_of_accessors.add(fita_de_bytes_sparse_preparada.buffer
            .asInt8List(sparse_offset, sparse_count));
      }
    }
    if (componentType == 5121) {
      t2_list_of_accessors
          .add(fita_de_bytes_preparada.buffer.asUint8List(offset, count));
      if (a.containsKey('sparse')) {
        t_sparse_list_of_accessors.add(fita_de_bytes_sparse_preparada.buffer
            .asUint8List(sparse_offset, sparse_count));
      }
    }
    if (componentType == 5122) {
      t2_list_of_accessors
          .add(fita_de_bytes_preparada.buffer.asInt16List(offset, count));
      if (a.containsKey('sparse')) {
        t_sparse_list_of_accessors.add(fita_de_bytes_sparse_preparada.buffer
            .asInt16List(sparse_offset, sparse_count));
      }
    }
    if (componentType == 5123) {
      t2_list_of_accessors
          .add(fita_de_bytes_preparada.buffer.asUint16List(offset, count));
      if (a.containsKey('sparse')) {
        t_sparse_list_of_accessors.add(fita_de_bytes_sparse_preparada.buffer
            .asUint16List(sparse_offset, sparse_count));
      }
    }
    if (componentType == 5125) {
      t2_list_of_accessors
          .add(fita_de_bytes_preparada.buffer.asUint32List(offset, count));
      if (a.containsKey('sparse')) {
        t_sparse_list_of_accessors.add(fita_de_bytes_sparse_preparada.buffer
            .asUint32List(sparse_offset, sparse_count));
      }
    }
    if (componentType == 5126) {
      t2_list_of_accessors
          .add(fita_de_bytes_preparada.buffer.asFloat32List(offset, count));
      if (a.containsKey('sparse')) {
        t_sparse_list_of_accessors
            .add(fita_de_bytes_sparse_preparada.buffer.asFloat32List());
      }
    }
    print('t_sparse_list_of_accessors: ${t_sparse_list_of_accessors}');
    print('t2_list_of_accessors: ${t2_list_of_accessors}');

    // ---------------------------------------------------------------

    for (var j = 0;
        j < t2_list_of_accessors.last.length;
        j += type_map[a['type']]) {
      t_list_of_accessors
          .add(t2_list_of_accessors.last.sublist(j, j + type_map[a['type']]));
    }
    // ---------------------------------------------------------------
    t2_list_of_accessors = [];
// ---------------------------------------------------------------

    list_of_accessors.replaceRange(i, i + 1, [t_list_of_accessors]);
    // print('t_list_of_accessors.lenght: h ${t_list_of_accessors.length} ');
    // print('t_list_of_accessors: h ${list_of_accessors.last} ');
// ---------------------------------------------------------------

    var t_sparse_list_of_accessors_indice = [];

    // print('copa');
    if (a.containsKey('sparse')) {
      var count = 0;
      var offset_indices = 0;
      var componentType;
      // print('copa');
      if (a['sparse']['indices'].containsKey('byteOffset')) {
        offset_indices = a['sparse']['indices']['byteOffset'];
      }
      if (a['sparse'].containsKey('count')) {
        count = a['sparse']['count'];
      }
      // print('copa');
      if (a['sparse']['indices'].containsKey('componentType')) {
        componentType = a['sparse']['indices']['componentType'];
        // print('copa');
        if (componentType == 5120) {
          t_sparse_list_of_accessors_indice.add(
              list_of_bufferviews[a['sparse']['indices']['bufferView']]
                  .readAsBytesSync(offset_indices, count));
        }
        if (componentType == 5121) {
          t_sparse_list_of_accessors_indice.add(
              list_of_bufferviews[a['sparse']['indices']['bufferView']]
                  .asUint8List(offset_indices, count));
        }
        if (componentType == 5122) {
          t_sparse_list_of_accessors_indice.add(
              list_of_bufferviews[a['sparse']['indices']['bufferView']]
                  .asInt16List(offset_indices, count));
        }

        if (componentType == 5123) {
          t_sparse_list_of_accessors_indice.add(
              list_of_bufferviews[a['sparse']['indices']['bufferView']]
                  .asUint16List(offset_indices, count));
        }

        if (componentType == 5125) {
          t_sparse_list_of_accessors_indice.add(
              list_of_bufferviews[a['sparse']['indices']['bufferView']]
                  .asUint32List(offset_indices, count));
        }

        if (componentType == 5126) {
          t_sparse_list_of_accessors_indice.add(
              list_of_bufferviews[a['sparse']['indices']['bufferView']]
                  .asFloat32List(offset_indices, count));
        }
        print('copa');
      } else {
        t_sparse_list_of_accessors_indice.add(
            list_of_bufferviews[a['sparse']['indices']['bufferView']]
                .asUint16List(offset_indices, count));
      }
      print('copa');
      {
        var qualquer = t_sparse_list_of_accessors.last;
        print('t_sparse_list_of_accessors: ${t_sparse_list_of_accessors}');
        t_sparse_list_of_accessors.removeLast();
        for (var j = 0; j < qualquer.length; j += type_map[a['type']]) {
          t_sparse_list_of_accessors
              .add(qualquer.sublist(j, j + type_map[a['type']]));
        }

        // print('list_of_accessors lala: ${list_of_accessors}');
        var qualquer_valor = list_of_accessors.last;

        for (var j = 0;
            j < t_sparse_list_of_accessors_indice.last.length;
            j++) {
          qualquer_valor.replaceRange(
              t_sparse_list_of_accessors_indice.last[j],
              t_sparse_list_of_accessors_indice.last[j] + 1,
              [t_sparse_list_of_accessors[j]]);
        }

        list_of_accessors.replaceRange(i, i + 1, [qualquer_valor]);
        print('copa 7');
      }
      print('copa8: saiu do "if_acessor" ');
    }
    print('copa9: acessor [concluido]');
  }
  // ------------------------------------------------------------------------------------------------------------------------
  for (var i = 0;
      i <
          list_of_accessors[file_content_map['meshes'][0]['primitives'][0]
                  ['attributes']['POSITION']]
              .length;
      i++) {
    lista_de_offset_dx_dy_vertices.add(Offset(
        list_of_accessors[file_content_map['meshes'][0]['primitives'][0]
            ['attributes']['POSITION']][i][0],
        list_of_accessors[file_content_map['meshes'][0]['primitives'][0]
            ['attributes']['POSITION']][i][1]));

    lista_de_cores_vertices.add(Colors.red);
  }

  print('copa 9: saiu do código velho');
// ************************************************************************************************************************
  // print('list_of_accessors [falta algoritmo para byteStride] valor: ${list_of_accessors} ');
// ------------------------------------------------------------------------------------------------------------------------
// meshes

  list_of_vertices.clear();
  List list_of_meshes = [];
  var meshes_content = file_content_map['meshes'];
  var primitives_content;
  print('list_of_meshes [falta interpretar o que é targets]');
  print('list_of_meshes [falta interpretar o que é wights]');
  // file_content_map['meshes'][0]['primitives'][0];

  for (var i = 0; i < meshes_content.length; i++) {
    primitives_content = file_content_map['meshes'][i]['primitives'];

    for (var j = 0; j < primitives_content.length; j++) {
      //get mode                primitives_content['mode']
      //get indices             primitives_content['indices']
      //get material            primitives_content['material']
      //get atributes{POSITION} primitives_content['atributes'][POSITION]
      //get atributes{NORMAL}   primitives_content['atributes'][NORMAL]
      //get atributes{TANGENT}  primitives_content['atributes'][TANGENT]
      //get atributes{TEXCOORD} primitives_content['atributes'][TEXCOORD]

      indice = [];
      for (var k = 0;
          k < list_of_accessors[primitives_content[j]['indices']].length;
          k++) {
        indice.add(list_of_accessors[primitives_content[j]['indices']][k][0]);
      }

      print('e');
      list_of_vertices.add(Vertices(
          VertexMode.triangles, lista_de_offset_dx_dy_vertices,
          colors: lista_de_cores_vertices, indices: indice));
    }
  }

// ------------------------------------------------------------------------------------------------------------------------
  print('sete');
}

Future<void> gltf_reader() async {
  print(1);
  file_content = File(directory_gltf.path).readAsStringSync();
  file_content_map = json.decode(file_content);
  print(1);
  for (int i = 0; i < file_content_map['bufferViews'].length; i++) {
    file_content_map['bufferViews'][i].forEach((key, value) {
      // print('bufferViews key $i: ' + key.toString());
      // print('bufferViews value $i: ' + value.toString());
    });
  }
  print(1);
  // print("scene:       ${file_content_map['scene']}");
  // print("scenes:      ${file_content_map['scenes']}");
  // print("nodes:       ${file_content_map['nodes']}");
  // print("meshes:      ${file_content_map['meshes']}");
  // print("buffers:     ${file_content_map['buffers']}");
  //print("bufferViews: ${file_content_map['bufferViews']}");
  //print("accessors:   ${file_content_map['accessors'].length}");
  //print("asset:       ${file_content_map['asset']}");
  print(
      '-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------');
  for (int i = 0; i < file_content_map['accessors'].length; i++) {
    file_content_map['accessors'][i].forEach((key, value) {
      // print('accessors key: ' + key.toString());
      // print('accessors value: ' + value.toString());
    });
  }
  print(file_content_map);
  // print('lalaaallalaalalallallalaallallalaalal ${[lista_de_indices_vertices]}');
}
