import 'dart:async';
import 'dart:io';

//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:factura/model/itemModel.dart';

import 'package:dart_rut_validator/dart_rut_validator.dart';
import 'package:factura/Constantsset.dart';
import 'package:factura/share_prefs/preferencias_usuario.dart';
import 'package:dio/dio.dart';
import 'package:factura/folder_file_saver.dart';
import 'package:factura/providers/InfoProvider.dart';

import 'package:file_picker/file_picker.dart';

//import 'package:factura/widget/birthday_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class SettingsPage extends StatefulWidget {
  static final String routeName = 'settings';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String progress = "0";
  final urlVideo =
          'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      urlImage =
          'https://images.unsplash.com/photo-1576039716094-066beef36943?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80';
  Dio dio;

  InfoProvider info = InfoProvider();
  bool _isLoading = false;
  //FILE PICKER
  String _fileName;

  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType;
  TextEditingController _controller = new TextEditingController();

  //Item ite = new Item();
  //List<Item> _ite = [];

  String dropdownValue;
  TextEditingController _textController = TextEditingController();
  TextEditingController _textControllerEm = TextEditingController();
  TextEditingController _textControllernomb = TextEditingController();
  TextEditingController _textControllerrut = TextEditingController();
  TextEditingController _textControllertelef = TextEditingController();
  TextEditingController _textControllerDesc = TextEditingController();
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

  Future<Null> _selectDate(BuildContext context) async {
    DateTime _datePicker = await showDatePicker(
        context: context,
        initialDate: _date,
        currentDate: prefs.fecha,
        firstDate: DateTime(1947),
        lastDate: DateTime(2100));
    if (_datePicker != null && _datePicker != _date) {
      setState(() {
        _date = _datePicker;
        prefs.fecha = _datePicker.toString();
      });
    }
  }

  List<ListItem> _dropdownItems = [];

  /*final List<String> names = <String>[
    'Aby',
    'Aish',
  ];*/

  void addItemToList() {
    setState(() {
      _dropdownItems.insert(
          0, ListItem(_dropdownItems.length, _textControllerdata.text));
    });
  }

  /*_read() async {
    prefs = await PreferenciasUsuario.getInstance();
    setState(() {
      dropdownValue = prefs.getString(_key) ?? "one"; // get the value
    });
  }*/

  @override
  void initState() {
    super.initState();
    dio = Dio();
    //prefs.ultimaPagina = SettingsPage.routeName;
    //_genero = prefs.genero;
    //_colorSecundario = prefs.colorSecundario;
    //dropdownValue = prefs.combo;
    // _selectedItem = _dropdownMenuItems[0].value;
    _textControllernomb = new TextEditingController(text: prefs.nombre);
    _textController = new TextEditingController(text: prefs.apiKey);
    _textControllerEm = new TextEditingController(text: prefs.email);
    _textControllerrut = new TextEditingController(text: prefs.rut);
    _textControllertelef = new TextEditingController(text: prefs.telefono);
    _textControllerDesc = new TextEditingController(text: prefs.descripcion);
    _imagepath = prefs.image;
    //prefs.image = _imagepath;
    prefs.fecha;
    //prefs.fecha = (_date).toString();
    _controller.addListener(() => _extension = _controller.text);
    prefs.pathsii;
    //_imageFile = prefs.image;
    //_date = prefs.getFecha();
  }

  void _openFileExplorer() async {
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
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  /*_setSelectedRadio(int valor) async{

    prefs.genero = valor;
    _genero = valor;
    setState(() {
      
    });

  }*/

  /*DateTime _dateTime = DateTime.now();

  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        _textControllerdate = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    /*var json = JsonDecoder().convert(data.toString());
    _ite = (json).map<Item>((data) {
      return Item.fromJson(data);
    }).toList();
    dropdownValue = _ite[0].item.toString();*/
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
                onChanged: (value) {
                  prefs.apiKey = value;
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
                controller: _textControllerrut,
                //obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Rut',
                    helperText: 'Ingrese su Rut',
                    hintText: '156982320'),
                onChanged: (value) {
                  prefs.rut = value;
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
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-z A-Z á-ú Á-Ú]'))
                ],
                controller: _textControllerDesc,
                //obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Descripción',
                    helperText: 'Ingrese una descripción',
                    hintText: 'Venta de alcohol'),
                onChanged: (value) {
                  prefs.descripcion = value;
                },
              ),
            ),
            Center(
                child: new Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: new SingleChildScrollView(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: new DropdownButton(
                          hint: new Text('Cargar desde'),
                          value: _pickingType,
                          items: <DropdownMenuItem>[
                            new DropdownMenuItem(
                              child: new Text('Desde cualquier archivo'),
                              value: FileType.any,
                            ),
                          ],
                          onChanged: (value) => setState(() {
                                _pickingType = value;
                                if (_pickingType != FileType.custom) {
                                  _controller.text = _extension = '';
                                }
                              })),
                    ),
                    new ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: 100.0),
                      child: _pickingType == FileType.custom
                          ? new TextFormField(
                              maxLength: 15,
                              autovalidate: true,
                              controller: _controller,
                              decoration:
                                  InputDecoration(labelText: 'File extension'),
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                RegExp reg = new RegExp(r'[^a-zA-Z0-9]');
                                if (reg.hasMatch(value)) {
                                  _hasValidMime = false;
                                  return 'Invalid format';
                                }
                                _hasValidMime = true;
                              },
                            )
                          : new Container(),
                    ),
                    // new ConstrainedBox(
                    //   constraints: BoxConstraints.tightFor(width: 200.0),
                    //   child: new SwitchListTile.adaptive(
                    //     title: new Text('Pick multiple files',
                    //         textAlign: TextAlign.right),
                    //     onChanged: (bool value) =>
                    //         setState(() => _multiPick = value),
                    //     value: _multiPick,
                    //   ),
                    // ),

                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                      child: new RaisedButton(
                        onPressed: () => //_openFileExplorer(),
                            _saveFolderFileExt(),
                        child: new Text("Abrir archivos"),
                      ),
                    ),
                    new Builder(
                      builder: (BuildContext context) => _path != null ||
                              _paths != null
                          ? new Container(
                              padding: const EdgeInsets.only(bottom: 30.0),
                              height: MediaQuery.of(context).size.height * 0.50,
                              child: new Scrollbar(
                                  child: new ListView.separated(
                                itemCount: _paths != null && _paths.isNotEmpty
                                    ? _paths.length
                                    : 1,
                                itemBuilder: (BuildContext context, int index) {
                                  final bool isMultiPath =
                                      _paths != null && _paths.isNotEmpty;
                                  final String name = 'Archivo $index: ' +
                                      (isMultiPath
                                          ? _paths.keys.toList()[index]
                                          : _fileName ?? '...');
                                  final path = isMultiPath
                                      ? _paths.values.toList()[index].toString()
                                      : _path;
                                  final valor = path;
                                  //copyFileToNewFolder(fileToCopy);
                                  /*if (fileToCopy == null) {
                                    print('no');
                                  } else if (fileToCopy.isEmpty) {
                                    print('ya existe');
                                  } else {
                                    FolderFileSaver.saveFileToFolderExt(
                                            fileToCopy)
                                        .toString();
                                  }*/

                                  return new ListTile(
                                    title: new Text(
                                      name,
                                    ),
                                    subtitle: new Text(prefs.pathsii = valor),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        new Divider(),
                              )),
                            )
                          : new Container(),
                    ),
                  ],
                ),
              ),
            )),
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

  // Don't forget to check
  // device permission

  /*void copyFileToNewFolder(String path) async {
    setState(() {
      _isLoading = true;
    });
    // get your path from your device your device
    //'/storage/emulated/0/Download/CertificadoSII.pfx'
    final fileToCopy = path;
    try {
      await FolderFileSaver.saveFileToFolderExt(fileToCopy);
    } catch (e) {
      print(e);
    }

    setState(() {
      _isLoading = false;
    });
  }*/

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
      // Navigator.pushNamed(context, 'FacturaPage');
      Navigator.pushNamed(context, 'HomePage');
    }
  }
}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}
