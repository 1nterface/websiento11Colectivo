import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../authentication.dart';

/// Widget to capture and crop the image
class registro extends StatefulWidget {
  @override
  createState() => registroState();
}

class registroState extends State<registro> {
  /// Active image file
  String ciudad2 = "";

  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _correo = TextEditingController();
  final TextEditingController _contrasena = TextEditingController();
  final TextEditingController _calle = TextEditingController();
  final TextEditingController _colonia = TextEditingController();
  final TextEditingController _tel = TextEditingController();
  final TextEditingController _num = TextEditingController();

  void _mensajeFiltros (BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('Ingresa tus datos correctamente', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop(); //Te regresa a la pantalla anterior
              },
            ),
          ],
        );
      },
    );
  }

  Future _startUploadTask() async {

    AuthenticationHelper()
        .signUp(email: _correo.text, password: _contrasena.text)
        .then((result) {
      if (result == null) {
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        print("");
      }
    });


    var correo = _correo.text.toLowerCase();
    var contra = _contrasena.text.toLowerCase();

    var now = DateTime.now();

    final collRef = FirebaseFirestore.instance.collection('Clientes_Registro').doc(correo);

    //double costo = double.parse(_precio.text);

    String nombre = _nombre.text;

    collRef.set({
      'correo': correo,
      'telefono': _tel.text,
      'contraseña': contra,
      //'newid': docReference.documentID,
      'foto': "",
      'id': "123",
      //'colonia': _colonia.text,
      //'calle': _calle.text,
      //'numerocasa': _num.text,
      'nombre': _nombre.text,
      //'foto': url,
      'miembrodesde': DateFormat("dd-MM-yyyy").format(now),
    });

    //SE CREA LA COLECCION PARA QUE LAS NOTIFICACIONES EMPIECEN LEYENDO EN CERO
    FirebaseFirestore.instance.collection('Notificaciones').doc("Compras"+correo.toString()).set({'notificacion': "0"});
    FirebaseFirestore.instance.collection('Notificaciones').doc("Chat"+correo.toString()).set({'notificacion': '0'});
    FirebaseFirestore.instance.collection('Notificaciones').doc("Carrito"+correo.toString()).set({'notificacion': '0'});
    FirebaseFirestore.instance.collection('Notificaciones').doc("Promos").set({'notificacion': '0'});

    Navigator.of(context).pushNamedAndRemoveUntil('/clientes_login', (route) => false);

  }

  final _formKey = GlobalKey<FormState>();


  Widget categoria(BuildContext context){
    return DropdownButton<String>(
        hint: Text("Elige tu ciudad"),
        value: ciudad2,
        items: <String>["Morelia"].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
        onChanged: (newVal) {
          setState(() {
            ciudad2 = newVal!;
          });
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff6DA08E),
        title: Text('Registrate', style: TextStyle(color: Colors.white)),
      ),
      // Preview the image and crop it
      body: ListView(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(50)
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 5
                        )
                      ]
                  ),
                  child: TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Escribe el nombre';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                    controller: _nombre,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.person,
                        color: Color(0xff6DA08E),
                      ),
                      hintText: 'Nombre',
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                //colleccategoria(context),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(50)
                      ),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 5
                        )
                      ]
                  ),
                  child: TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Escribe el numero de celular';
                      }
                      return null;
                    },
                    controller: _tel,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.phone_android,
                        color: Color(0xff6DA08E),
                      ),
                      hintText: 'Numero de celular',
                    ),
                  ),
                ),
                SizedBox(height:20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(50)
                      ),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 5
                        )
                      ]
                  ),
                  child: TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Escribe el correo';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s")),
                    ],
                    textCapitalization: TextCapitalization.none,
                    controller: _correo,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.email,
                        color: Color(0xff6DA08E),
                      ),
                      hintText: 'Correo',
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(50)
                      ),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 5
                        )
                      ]
                  ),
                  child: TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Escribe la contraseña';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s"))
                    ],
                    controller: _contrasena,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.vpn_key,
                        color: Color(0xff6DA08E),
                      ),
                      hintText: 'Contraseña',
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top:30.0),
                  child: Container(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child:  OutlineButton(
                        onPressed: () async {

                          if (_formKey.currentState!.validate()) {
                            _startUploadTask();
                          }


                        },
                        child: SizedBox(
                          width: 300,
                          child: Text('Registrar informacion', textAlign: TextAlign.center,),
                        ),
                        borderSide: BorderSide(color: Colors.black),
                        shape: StadiumBorder(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.0,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
