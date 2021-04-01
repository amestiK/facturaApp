import 'dart:async';
import 'dart:io';

//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:factura/model/itemModel.dart';

import 'package:dart_rut_validator/dart_rut_validator.dart';
import 'package:factura/Constantsset.dart';
import 'package:factura/pages/print.dart';
import 'package:factura/providers/organizationProvider.dart';
import 'package:factura/share_prefs/preferencias_usuario.dart';
import 'package:dio/dio.dart';
import 'package:factura/folder_file_saver.dart';
import 'package:factura/providers/InfoProvider.dart';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import 'package:factura/widget/birthday_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'home_page.dart';

class SettingsPage extends StatefulWidget {
  static final String routeName = 'settings';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String progress = "0";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _fileName;
  List<PlatformFile> _paths;
  String _directoryPath;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;

  InfoProvider info = InfoProvider();
  OrgProvider org = OrgProvider();
  bool apiValid = false;
  bool _isLoading = false;
  //FILE PICKER

  String _path;

  bool _hasValidMime = false;

  TextEditingController _controller = new TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  signOut() async {
    await auth.signOut();
    Navigator.pushReplacementNamed(context, 'LoginPage');
  }

  //Item ite = new Item();
  //List<Item> _ite = [];

  String dropdownValue;
  TextEditingController _textController = TextEditingController();
  TextEditingController _textControllerEm = TextEditingController();
  TextEditingController _textControllernomb = TextEditingController();
  TextEditingController _textControllerrut = TextEditingController();
  TextEditingController _textControllertelef = TextEditingController();
  TextEditingController _textControllerDesc = TextEditingController();
  TextEditingController _textControllerFecha = TextEditingController();

  //TextEditingController _textControllerdate;
  TextEditingController _textControllerdata = TextEditingController();

  DateTime birthday;
  var selectedCurrency, selectedType;

  String _imagepath;
  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  final prefs = new PreferenciasUsuario();

  DateTime _date = new DateTime.now();

  //final formato = new DateFormat.yMMMMd('es_CL');

  Future<Null> _selectDate(BuildContext context) async {
    DateTime _datePicker = await showDatePicker(
        context: context,
        initialDate: _date,
        currentDate: _date,
        firstDate: DateTime(1947),
        lastDate: DateTime(2100));
    if (_datePicker != null && _datePicker != _date) {
      setState(() {
        _date = _datePicker;
        var date =
            "${_datePicker.toLocal().day}/${_datePicker.toLocal().month}/${_datePicker.toLocal().year}";
        _textControllerFecha.text = date;
        prefs.fecha = date;
      });
    }
  }

  List<ListItem> _dropdownItems = [];

  void addItemToList() {
    setState(() {
      _dropdownItems.insert(
          0, ListItem(_dropdownItems.length, _textControllerdata.text));
    });
  }

  @override
  void initState() {
    super.initState();
    //dio = Dio();
    //prefs.ultimaPagina = SettingsPage.routeName;
    //_genero = prefs.genero;
    //_colorSecundario = prefs.colorSecundario;
    //dropdownValue = prefs.combo;
    // _selectedItem = _dropdownMenuItems[0].value;
    _textControllerFecha = new TextEditingController(text: prefs.fecha);
    _textControllernomb = new TextEditingController(text: prefs.nombre);
    _textController = new TextEditingController(text: prefs.apiKey);
    _textControllerEm = new TextEditingController(text: prefs.email);
    _textControllerrut = new TextEditingController(text: prefs.rut);
    _textControllertelef = new TextEditingController(text: prefs.telefono);
    _textControllerDesc = new TextEditingController(text: prefs.descripcion);
    _imagepath = prefs.image;
    //prefs.image = _imagepath;
    //prefs.fecha;
    //prefs.fecha = (_date).toString();
    _controller.addListener(() => _extension = _controller.text);
    prefs.pathsii;
    //_imageFile = prefs.image;
    //_date = prefs.getFecha();
  }

  /*void _openFileExplorer() async {
    if (_pickingType != FileType.custom || _hasValidMime) {
      try {
        if (_multiPick) {
          _path = null;
          _paths = await FilePicker.getMultiFilePath(
            type: _pickingType,
          );
        } else {
          _paths = null;
          _path = await FilePicker.getFilePath(
            type: _pickingType,
          );
        }
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;

      setState(() {
        _fileName = _path != null
            ? _path.split('/').last
            : _paths != null
                ? _paths.keys.toString()
                : '...';
      });
    }
  }*/

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '')?.split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      _fileName = _paths != null ? _paths.map((e) => e.name).toString() : '...';
    });
  }

  void _clearCachedFiles() {
    FilePicker.platform.clearTemporaryFiles().then((result) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: result ? Colors.green : Colors.red,
          content: Text((result
              ? 'Temporary files removed with success.'
              : 'Failed to clean temporary files')),
        ),
      );
    });
  }

  void _selectFolder() {
    FilePicker.platform.getDirectoryPath().then((value) {
      setState(() => _directoryPath = value);
    });
  }

  //Widget
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var df = new DateFormat.yMMMd().format(_date);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Ajustes')),
        backgroundColor: Colors.deepPurple,
        actions: [
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return ConstantsSett.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 5,
            child: FloatingActionButton(
              backgroundColor: Colors.purple,
              child: Icon(Icons.print),
              onPressed: () async {
                final List<Map<String, dynamic>> data = [
                  {
                    'title': 'Produk 1',
                    'price': 10000,
                    'qty': 2,
                    'total_price': 20000,
                  },
                  {
                    'title': 'Produk 2',
                    'price': 20000,
                    'qty': 2,
                    'total_price': 40000,
                  },
                  {
                    'title': 'Produk 3',
                    'price': 12000,
                    'qty': 1,
                    'total_price': 12000,
                  },
                ];

                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Print(data)));
              },
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Center(
              //padding: EdgeInsets.all(10.0),
              child: Text('Configuración',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Center(
              child: Stack(
                children: <Widget>[
                  _imagepath != null
                      ? CircleAvatar(
                          backgroundImage: FileImage(File(_imagepath)),
                          radius: 80)
                      : CircleAvatar(
                          radius: 80.0,
                          backgroundImage: _imageFile != null
                              ? FileImage(File(prefs.image = _imageFile.path))
                              : AssetImage("assets/images.png"),
                        ),
                  Positioned(
                    bottom: 20.0,
                    right: 20.0,
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: ((builder) => bottomSheet()),
                        );
                      },
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.deepPurple,
                        size: 28.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp('[a-z A-Z á-ú Á-Ú 0-9]'))
                ],
                controller: _textController,
                //obscureText: true,
                decoration: InputDecoration(
                  labelText: 'ApiKey',
                  helperText: 'Ingrese apiKey',
                ),
                onChanged: (value) async {
                  prefs.apiKey = value;

                  print("Text $value");
                  var resp;

                  await org.cargarOrg().then((value) => resp = value);

                  if (value.length != 32) {
                    setState(() {
                      prefs.apiValid = false;
                    });
                    return;
                  } else if (resp != null) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Alerta'),
                              content: Text('La apiKey es válida!'),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Aceptar'))
                              ],
                            ));
                    setState(() {
                      prefs.apiValid = true;
                    });
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Alerta'),
                              content: Text(
                                  'La apiKey es inválida, pruebe ingresando otra.'),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Aceptar'))
                              ],
                            ));
                    setState(() {
                      prefs.apiValid = false;
                    });
                  }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp('[a-z A-Z á-ú Á-Ú 0-9 @ .]'))
                ],
                keyboardType: TextInputType.emailAddress,
                controller: _textControllerEm,
                //obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Email',
                  helperText: 'Ingrese Email',
                ),
                onChanged: (value) {
                  prefs.email = value;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-z A-Z á-ú Á-Ú]'))
                ],
                controller: _textControllernomb,
                //obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Nombre',
                    helperText: 'Ingrese Nombre',
                    hintText: "Juan"),
                onChanged: (value) {
                  prefs.nombre = value;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9-k]'))
                ],
                validator: RUTValidator().validator,
                controller: _textControllerrut,
                //obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Rut',
                    helperText: 'Ingrese su Rut',
                    hintText: '15698232-0',
                    counterText: ''),
                maxLength: 10,
                onChanged: (value) {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      RUTValidator.formatFromText(_textControllerrut.text);
                    });
                    prefs.rut = value;
                  } else {
                    prefs.rut = "";
                  }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[+0-9]'))
                ],
                controller: _textControllertelef,
                //obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Telefono',
                    helperText: 'Ingrese su Telefono',
                    hintText: '955635689'),
                onChanged: (value) {
                  prefs.telefono = value;
                },
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: _textControllerFecha,
                  showCursor: true,
                  readOnly: true,
                  onTap: () {
                    setState(() {
                      _selectDate(context);
                      prefs.fecha = (_date).toString();
                    });
                  },
                  decoration: InputDecoration(
                      hintText: (df.toString()),
                      helperText: 'Ingrese Fecha Nacimiento'),
                )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp('[a-z A-Z á-ú Á-Ú]'))
                  ],
                  controller: _textControllerDesc,
                  //obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Descripción',
                      helperText: 'Ingrese una descripción',
                      hintText: 'Venta de alcohol'),
                  onChanged: (value) {
                    if (value.length <= 15) {
                      prefs.descripcion = value;
                    } else {
                      prefs.descripcion = value.substring(0, 15);
                    }
                  }),
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      // child: DropdownButton(
                      //     // hint: Text('LOAD PATH FROM'),
                      //     // value: _pickingType,
                      //     // items: <DropdownMenuItem>[
                      //     //   DropdownMenuItem(
                      //     //     child: Text('FROM AUDIO'),
                      //     //     value: FileType.audio,
                      //     //   ),
                      //     //   DropdownMenuItem(
                      //     //     child: Text('FROM IMAGE'),
                      //     //     value: FileType.image,
                      //     //   ),
                      //     //   DropdownMenuItem(
                      //     //     child: Text('FROM VIDEO'),
                      //     //     value: FileType.video,
                      //     //   ),
                      //     //   DropdownMenuItem(
                      //     //     child: Text('FROM MEDIA'),
                      //     //     value: FileType.media,
                      //     //   ),
                      //     //   DropdownMenuItem(
                      //     //     child: Text('FROM ANY'),
                      //     //     value: FileType.any,
                      //     //   ),
                      //     //   DropdownMenuItem(
                      //     //     child: Text('CUSTOM FORMAT'),
                      //     //     value: FileType.custom,
                      //     //   ),
                      //     // ],
                      //     onChanged: (value) => setState(() {
                      //           _pickingType = value;
                      //           if (_pickingType != FileType.custom) {
                      //             _controller.text = _extension = '';
                      //           }
                      //         })),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(width: 100.0),
                      child: _pickingType == FileType.custom
                          ? TextFormField(
                              maxLength: 15,
                              autovalidate: true,
                              controller: _controller,
                              decoration:
                                  InputDecoration(labelText: 'File extension'),
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.none,
                            )
                          : const SizedBox(),
                    ),
                    // ConstrainedBox(
                    //   constraints: const BoxConstraints.tightFor(width: 200.0),
                    //   child: SwitchListTile.adaptive(
                    //     title: Text('Pick multiple files',
                    //         textAlign: TextAlign.right),
                    //     onChanged: (bool value) =>
                    //         setState(() => _multiPick = value),
                    //     value: _multiPick,
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                      child: Column(
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () => _openFileExplorer(),
                            child: Text("Abrir carpeta de archivos"),
                          ),
                          // RaisedButton(
                          //   onPressed: () => _selectFolder(),
                          //   child: Text("Pick folder"),
                          // ),
                          // RaisedButton(
                          //   onPressed: () => _clearCachedFiles(),
                          //   child: Text("Clear temporary files"),
                          // ),
                        ],
                      ),
                    ),
                    Builder(
                      builder: (BuildContext context) => _loadingPath
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: const CircularProgressIndicator(),
                            )
                          : _directoryPath != null
                              ? ListTile(
                                  title: Text('Ruta del directorio'),
                                  subtitle: Text(_directoryPath),
                                )
                              : _paths != null
                                  ? Container(
                                      padding:
                                          const EdgeInsets.only(bottom: 30.0),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.50,
                                      child: Scrollbar(
                                          child: ListView.separated(
                                        itemCount:
                                            _paths != null && _paths.isNotEmpty
                                                ? _paths.length
                                                : 1,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final bool isMultiPath =
                                              _paths != null &&
                                                  _paths.isNotEmpty;
                                          final String name =
                                              'Archivo $index: ' +
                                                  (isMultiPath
                                                      ? _paths
                                                          .map((e) => e.name)
                                                          .toList()[index]
                                                      : _fileName ?? '...');
                                          final path = _paths
                                              .map((e) => e.path)
                                              .toList()[index]
                                              .toString();

                                          return ListTile(
                                            title: Text(
                                              name,
                                            ),
                                            subtitle: Text(path),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                const Divider(),
                                      )),
                                    )
                                  : const SizedBox(),
                    ),
                  ],
                ),
              ),
            )),
            RaisedButton(
                child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 65.0, vertical: 15.0),
                    child: Text('Cerrar sesión')),
                color: Colors.deepPurple,
                textColor: Colors.white,
                onPressed: () {
                  signOut();
                })
          ],
        ),
      ),
    );
  }

  void _saveFolderFileExt() async {
    try {
      setState(() {
        _isLoading = false;
      });
      // if you want check permission user
      // use like that
      // if return 0 permission is PERMISSION_GRANTED
      // if return 1 permission is PERMISSION_IS_DENIED
      // if return 2 permission is PERMISSION_IS_DENIED with click don't ask again
      final resultPermission = await FolderFileSaver.requestPermission();

      // 2 permission is PERMISSION_IS_DENIED with click don't ask again
      if (resultPermission == 2) {
        // Do Something Info Here To User
        // await FolderFileSaver.openSetting;
      }

      // 1 permission is PERMISSION_IS_DENIED
      if (resultPermission == 1) {
        // Do Something Here
      }

      // 0 permission is PERMISSION_GRANTED
      if (resultPermission == 0) {
        _openFileExplorer();
        FolderFileSaver.saveFileToFolderExt(prefs.pathsii);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //Widget que nos despliega la opcion de elegir entre tomar una foto o seleccionar una foto de la galeria
  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Elegir foto",
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.camera),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                label: Text("Camara"),
              ),
              FlatButton.icon(
                icon: Icon(Icons.image),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                label: Text("Galeria de imagenes"),
              ),
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  void choiceAction(String choice) {
    if (choice == ConstantsSett.HomePage) {
      if (prefs.apiValid == false) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Alerta'),
                  content: Text('Debe ingresar una apiKey válida'),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok'))
                  ],
                ));
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Home()),
            (Route<dynamic> route) => false);
      }
    }
  }
}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}
