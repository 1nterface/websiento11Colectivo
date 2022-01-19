import 'dart:math';
import 'package:websiento11/Clientes/compras_detalles.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:websiento11/Modelo/panel_pedido_modelo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:shared_preferences/shared_preferences.dart';

class compras extends StatefulWidget {
  @override
  comprasState createState() => comprasState();
}

class comprasState extends State<compras> {

  bool sesion = false;

  CollectionReference reflistaproduccion = FirebaseFirestore.instance.collection('Pedidos_Jimena');

  Future<void> pedidos (BuildContext context)async{

    var now = DateTime.now();

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;

    QuerySnapshot _myDoc2 = await FirebaseFirestore.instance.collection('Pedidos_Jimena').where('correopersonal', isEqualTo: correoPersonal).where("visto", isEqualTo: "no").get();
    List<DocumentSnapshot> _myDocCount2 = _myDoc2.docs;
    print("Notificacion: "+_myDocCount2.length.toString());

    FirebaseFirestore.instance.collection('Notificaciones').doc("Pedidos"+correoPersonal.toString()).set  ({'notificacion': _myDocCount2.length.toString()});
  }

  var category;
  //FOLIO, NOMBRE, CELULAR, COLONIA, CALLE, NUMERO
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _celular = TextEditingController();
  final TextEditingController _colonia = TextEditingController();
  final TextEditingController _calle = TextEditingController();
  final TextEditingController _numero = TextEditingController();

  void t(){
    Future.delayed(Duration(seconds: 5), () {
      print(" This line is execute after 5 seconds");
    });
  }

  @override
  void initState() {
    correo();
    // TODO: implement initState
    pedidos(context);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget altaRescate(BuildContext context) {
    return ListView(
      children: <Widget>[
        AlertDialog(
          title: const Text('Alta de Rescate'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(50)
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.red,
                          blurRadius: 5
                      )
                    ]
                ),
                child: TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Ingresa el nombre';
                    }
                    return null;
                  },
                  controller: _nombre,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.phone_android,
                      color: Color(0xff6DA08E),
                    ),
                    hintText: 'Nombre del cliente',
                  ),
                ),
              ),
              SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("Servicios").snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Text("Please wait");
                    var length = snapshot.data!.docs.length;
                    DocumentSnapshot ds = snapshot.data!.docs[length - 1];
                    return DropdownButton(
                      items: snapshot.data!.docs.map((
                          DocumentSnapshot document) {
                        return DropdownMenuItem(
                          value: document["servicio"],
                          child: Text(document["servicio"], style: TextStyle(fontSize: 17.0),),);
                      }).toList(),
                      value: category,
                      onChanged: (value) {
                        //print(value);
                        setState(() {
                          category = value;
                        });

                      },
                      hint: Text("Tipo de rescate", style: TextStyle(fontSize: 18.0),),
                      style: TextStyle(color: Colors.black),
                    );
                  }
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(50)
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.red,
                          blurRadius: 5
                      )
                    ]
                ),
                child: TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Ingresa el numero celular';
                    }
                    return null;
                  },
                  controller: _celular,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.phone_android,
                      color: Colors.red[900],
                    ),
                    hintText: 'Celular',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(50)
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.red,
                          blurRadius: 5
                      )
                    ]
                ),
                child: TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Ingresa la calle';
                    }
                    return null;
                  },
                  controller: _calle,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.phone_android,
                      color: Colors.red,
                    ),
                    hintText: 'Calle',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(50)
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.red,
                          blurRadius: 5
                      )
                    ]
                ),
                child: TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Ingresa la colonia';
                    }
                    return null;
                  },
                  controller: _colonia,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.phone_android,
                      color: Color(0xff6DA08E),
                    ),
                    hintText: 'Colonia',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(50)
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.red,
                          blurRadius: 5
                      )
                    ]
                ),
                child: TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Ingresa el numero de casa';
                    }
                    return null;
                  },
                  controller: _numero,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.phone_android,
                      color: Color(0xff6DA08E),
                    ),
                    hintText: 'Numero',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child:  OutlineButton(
                    onPressed: () async {

                      QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Pedidos_Jimena').orderBy('folio').get();
                      List<DocumentSnapshot> _myDocCount = _myDoc.docs;

                      final collRef = FirebaseFirestore.instance.collection('Pedidos_Jimena');
                      DocumentReference docReference = collRef.doc();

                      DateTime now = DateTime.now();
                      String formattedDate = DateFormat('kk:mm:ss').format(now);

                      int celular = int.parse(_celular.text);
                      int numero = int.parse(_numero.text);


                      docReference.set({

                        //AWEBO ABRIR VENTANA PARA PREGUNTAR
                        // SPINNER TIPO DE RESCATE, NOMBRE DE CLIENTE, DIRECCION, CELULAR
                        // TAMBIEN REVISAR POR QUE AL ASIGNAR UN RESCATE, VUELVES A ENTRAR A VER
                        // LA NOTA Y TE APARECE LA NOTA DE PEDIDO..QUITAR ESO POR QUE NO SIRVE.
                        'hora': formattedDate,
                        'calle': _calle.text,
                        'concepto': "",
                        'colonia': _colonia.text,
                        'numero': numero,
                        'celular': celular,
                        'servicio': category,
                        'folio': _myDocCount.length+1,
                        'newid': docReference.id,
                        'id': "987",
                        'nombreProducto': _myDocCount.length+1,
                        'nombrecliente': _nombre.text,
                        'miembrodesde': DateFormat("dd-MM-yyyy").format(now),
                        'repartidor': 'Nadie',
                        'estado': 'rescatesolicitado',
                        'estado3': 'PEDIDO LOCAL',
                        'estado2': 'pedidoEnEspera',
                        'totalNota': 0.00,
                        'tipodepago': "Ninguno",
                        'transitopendiente': "",
                        'encamino': "",
                        'ensitio': "",
                        'finalizo': "",
                        'visto': "no",
                      });

                      _calle.clear();
                      _colonia.clear();
                      _nombre.clear();
                      _celular.clear();
                      _numero.clear();

                      pedidos(context);

                      Navigator.pop(context);
                      Navigator.pop(context);

                    },
                    child: SizedBox(
                      width: 300,
                      child: Text('Guardar RESCATE', textAlign: TextAlign.center,),
                    ),
                    borderSide: BorderSide(color: Colors.red),
                    shape: StadiumBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {

                Navigator.of(context).pop();

              },
              textColor: Theme.of(context).primaryColor,
              child: const Text('Salir'),
            ),
          ],
        ),
      ],
    );
  }

  var colonia;

  Widget coloniaSpinner(BuildContext context){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        StatefulBuilder(
          builder: (BuildContext context, setState) =>  GestureDetector(
            onTap: (){
              (context as Element).markNeedsBuild();
            },
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("Colonia").where('correoNegocio', isEqualTo: correo ).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  var length = snapshot.data!.docs.length;
                  DocumentSnapshot ds = snapshot.data!.docs[length - 1];
                  return DropdownButton(
                    items: snapshot.data!.docs.map((
                        DocumentSnapshot document) {
                      return DropdownMenuItem(
                        value: document["colonia"],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(document["colonia"]),
                            //Icon(Icons.arrow_right),
                            //new Text(document.data["existencia"].toString(), style: TextStyle(fontSize: 17.0, color: Colors.green[800]),),
                          ],
                        ),
                      );
                    }).toList(),
                    value: colonia,
                    onChanged: (value) {
                      //print(value);
                      setState(() {
                        colonia = value;

                        print(colonia);

                      });

                      FirebaseFirestore.instance.collection('Colonia').where('colonia', isEqualTo: colonia).snapshots().listen((data) async {
                        data.docs.forEach((doc) async {

                          double flete = doc['flete'];

                          print("Flete "+flete.toString());

                          final prefs = await SharedPreferences.getInstance();
                          prefs.setDouble('flete', flete);


                        }); //METODO THANOS FOR EACH

                      });

                    },
                    hint: Text("Colonia", style: TextStyle(fontSize: 18.0),),
                    style: TextStyle(color: Colors.black),
                  );
                }
            ),
          ),
        ),
        //Text('Medidas: 5A'),
      ],
    );

  }

  Widget altaNuevaNota(BuildContext context, String tiempo) {
    return ListView(
      children: <Widget>[
        AlertDialog(
          title: const Text('Alta de Nuevo Pedido'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: const BoxDecoration(
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
                      return 'Ingresa el nombre';
                    }
                    return null;
                  },
                  controller: _nombre,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.person,
                      color: Colors.purple[900],
                    ),
                    hintText: 'Nombre del cliente',
                  ),
                ),
              ),

              SizedBox(height: 20),
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
                      return 'Ingresa el numero celular';
                    }
                    return null;
                  },
                  controller: _celular,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.phone_android,
                      color: Colors.purple[900],
                    ),
                    hintText: 'Celular',
                  ),
                ),
              ),
              SizedBox(height: 20),
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
                      return 'Ingresa la calle';
                    }
                    return null;
                  },
                  controller: _calle,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.text_rotation_none,
                      color: Colors.purple[900],
                    ),
                    hintText: 'Calle',
                  ),
                ),
              ),
              SizedBox(height: 20),
              coloniaSpinner(context),
              SizedBox(height: 20),
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
                      return 'Ingresa el numero de casa';
                    }
                    return null;
                  },
                  controller: _numero,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.house,
                      color: Colors.purple[900],
                    ),
                    hintText: 'Numero',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child:  OutlineButton(
                    onPressed: () async {

                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final User? user = auth.currentUser;
                      final correoPersonal = user!.email;

                      QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Pedidos_Jimena').orderBy('folio').get();
                      List<DocumentSnapshot> _myDocCount = _myDoc.docs;

                      final collRef = FirebaseFirestore.instance.collection('Pedidos_Jimena');
                      DocumentReference docReference = collRef.doc();

                      DateTime now = DateTime.now();
                      String formattedDate = DateFormat('kk:mm:ss').format(now);

                      int celular = int.parse(_celular.text);
                      int numero = int.parse(_numero.text);

                      final prefs = await SharedPreferences.getInstance();
                      String nombreempresa = prefs.getString('nombreempresa') ?? "";
                      Object flete = prefs.getDouble('flete') ?? "";
                      String tiempoo = prefs.getString('tiempo') ?? "";
                      String coloniaNegocio = prefs.getString('coloniaNegocio') ?? "";
                      String calleNegocio = prefs.getString('calleNegocio') ?? "";
                      String numextNegocio = prefs.getString('numextNegocio') ?? "";

                      docReference.set({
                        "numextNegocio":numextNegocio,
                        "coloniaNegocio":coloniaNegocio,
                        "calleNegocio": calleNegocio,
                        'nombreempresa': nombreempresa,
                        'tiempodeespera': tiempoo,
                        'flete': flete,
                        'visto': "no",
                        'correoNegocio': correoPersonal,
                        'hora': formattedDate,
                        'calle': _calle.text,
                        'colonia': colonia,
                        'concepto': "",
                        'numero': numero,
                        'celular': celular,
                        'folio': _myDocCount.length+1,
                        'newid': docReference.id,
                        'id': "987",
                        'nombrecliente': _nombre.text,
                        'nombreProducto': _myDocCount.length+1,
                        'miembrodesde': DateFormat("yyyy-MM-dd").format(now),
                        'repartidor': 'Nadie',
                        'estado': 'enlinea',
                        'estado2': 'PENDIENTERESTA',
                        'estado3': 'PEDIDO A DOMICILIO',
                        'totalNota': 0.00,
                        'total': 0.00,
                        'tipodepago': "Ninguno",
                        'transitopendiente': "",
                        'encamino': "",
                        'ensitio': "",
                        'finalizo': "",
                        'estadoc': "local",
                      });

                      pedidos(context);

                      Navigator.pop(context);

                    },
                    child: SizedBox(
                      width: 300,
                      child: Text('Aceptar', textAlign: TextAlign.center,),
                    ),
                    borderSide: BorderSide(color: Colors.purple),
                    shape: StadiumBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {

                Navigator.of(context).pop();

              },
              textColor: Theme.of(context).primaryColor,
              child: Text('Salir', style: TextStyle(color: Colors.purple[900])),
            ),
          ],
        ),
      ],
    );
  }

  var now = DateTime.now();

  FirebaseAuth auth = FirebaseAuth.instance;
  signOut() async {
    await auth.signOut();
  }


  final _formKey3 = GlobalKey<FormState>();
  final TextEditingController _cantidad6 = TextEditingController();
  final TextEditingController _cantidadr = TextEditingController();

  Widget tiempoDeEspera (BuildContext context){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Tiempo').doc(correo.toString()+"espera").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data! as Map<String, dynamic>;

            String tiempo = userDocument["tiempo"];

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer),
                Text('Tiempo a dom.: '+tiempo+" min.", style: TextStyle(color: Color(0xff6DA08E), fontSize: 15.0, fontWeight: FontWeight.bold),),
              ],
            );

          }
        }
    );
  }
  Widget tiempoDeEsperaR (BuildContext context){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Tiempo').doc(correo.toString()+"espera").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data! as Map<String, dynamic>;

            String tiempo = userDocument["tiempor"];

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer),
                Text('Tiempo de recoleccion: '+tiempo+" min.", style: TextStyle(color: Color(0xff6DA08E), fontSize: 15.0, fontWeight: FontWeight.bold),),
              ],
            );

          }
        }
    );
  }

  Widget _buildAboutDialogTi(BuildContext context) {
    return Form(
      key: _formKey3,
      child: Column(
        children: <Widget>[
          AlertDialog(
            title: Text("Modificar tiempo de espera"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                tiempoDeEspera(context),
                Container(
                  color: Colors.black,
                  child: Column(
                    children: const <Widget>[
                      Divider(color: Colors.white10, height: 10.0,),
                      //Divider(color: Colors.black26,),
                    ],
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
                        return 'Escribe el nuevo tiempo de espera';
                      }
                      return null;
                    },
                    controller: _cantidad6,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.add,
                        color: Colors.black,
                      ),
                      hintText: 'Entrega a domicilio',
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          child: SizedBox(
                            child: RaisedButton(
                              color: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              child: Text('Modificar', style: TextStyle(color: Colors.white),),
                              onPressed: () async {

                                final FirebaseAuth auth = FirebaseAuth.instance;
                                final User? user = auth.currentUser;
                                final correo = user!.email;

                                FirebaseFirestore.instance.collection('Tiempo').doc(correo.toString()+"espera").update({
                                  'tiempo': _cantidad6.text,
                                });

                                Toast.show("¡Tiempo de espera modificado!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                                //await Navigator.push(context, MaterialPageRoute(builder: (context) => Carpinteria_Producto_Detalle(Cajas_Modelo(null, nombreProducto,fecha,folio,2,3, precio,5,"","",foto,descripcion, newid, costoproducto))),);
                                Navigator.pop(context);

                                _cantidad6.clear();

                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.0,),
                tiempoDeEsperaR(context),
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
                        return 'Escribe el nuevo tiempo de espera';
                      }
                      return null;
                    },
                    controller: _cantidadr,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.add,
                        color: Colors.black,
                      ),
                      hintText: 'Tiempo recoleccion',
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          child: SizedBox(
                            child: RaisedButton(
                              color: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              child: Text('Modificar', style: TextStyle(color: Colors.white),),
                              onPressed: () async {

                                final FirebaseAuth auth = FirebaseAuth.instance;
                                final User? user = auth.currentUser;
                                final correo = user!.email;

                                FirebaseFirestore.instance.collection('Tiempo').doc(correo.toString()+"espera").update({
                                  'tiempor': _cantidadr.text,
                                });

                                Toast.show("¡Tiempo de espera modificado!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                                //await Navigator.push(context, MaterialPageRoute(builder: (context) => Carpinteria_Producto_Detalle(Cajas_Modelo(null, nombreProducto,fecha,folio,2,3, precio,5,"","",foto,descripcion, newid, costoproducto))),);
                                Navigator.pop(context);

                                _cantidadr.clear();

                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                textColor: Theme.of(context).primaryColor,
                child: const Text('Salir'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _tiempoRecorrido(context, estado3, pendiente, transitopendiente, encamino, ensitio, finalizo, hora) async {

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(right:50),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 20,),
                          estado3 != "PENDIENTE"?
                          Icon(Icons.check_circle_rounded, size: 20, color: Colors.grey,)
                              :
                          Icon(Icons.radio_button_checked_rounded, size: 35, color: Colors.green[800],),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 20,),

                          estado3 != "TRANSITO PENDIENTE"?
                          transitopendiente != ""?
                          Icon(Icons.check_circle_rounded, size: 20, color: Colors.grey,)
                              :
                          Icon(Icons.radio_button_unchecked, size: 20, color: Colors.grey,)
                              :
                          Icon(Icons.radio_button_checked_rounded, size: 35, color: Colors.green[800],),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 12,),

                          estado3 != "EN CAMINO"?
                          encamino != ""?
                          Icon(Icons.check_circle_rounded, size: 20, color: Colors.grey,)
                              :
                          Icon(Icons.radio_button_unchecked, size: 20, color: Colors.grey,)
                              :
                          Icon(Icons.radio_button_checked_rounded, size: 35, color: Colors.green[800],),                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 20,),
                          estado3 != "EN SITIO"?
                          ensitio != ""?
                          Icon(Icons.check_circle_rounded, size: 20, color: Colors.grey,)
                              :
                          Icon(Icons.radio_button_unchecked, size: 20, color: Colors.grey,)
                              :
                          Icon(Icons.radio_button_checked_rounded, size: 35, color: Colors.green[800],),                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 20,),
                          estado3 != "FINALIZO"?
                          finalizo != ""?
                          Icon(Icons.check_circle_rounded, size: 20, color: Colors.grey,)
                              :
                          Icon(Icons.radio_button_unchecked, size: 20, color: Colors.grey,)
                              :
                          Icon(Icons.radio_button_checked_rounded, size: 35, color: Colors.green[800],),                        ],
                      ),
                    ],
                  ),
                ),
                //Icon(Icons.radio_button_checked_rounded, size: 35, color: Colors.green[800],),
                //Icon(Icons.radio_button_unchecked, size: 20, color: Colors.grey,),
                Padding(
                  padding: const EdgeInsets.only(left:60.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          estado3 != "PENDIENTE"?
                          Text('Pedido generado', style: TextStyle(color: Colors.grey),)
                              :
                          Text('Pedido generado', style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold),),
                          SizedBox(width: 20,),
                          Text(hora),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          estado3 != "TRANSITO PENDIENTE"?
                          Text('Transito pendiente', style: TextStyle(color: Colors.grey),)
                              :
                          Text('Transito pendiente', style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold),),
                          SizedBox(width: 20,),
                          Text(transitopendiente),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          estado3 != "EN CAMINO"?
                          Text('En camino', style: TextStyle(color: Colors.grey),)
                              :
                          Text('En camino', style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold),),
                          SizedBox(width: 20,),
                          Text(encamino)
                        ],
                      ),
                      SizedBox(height: 10,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          estado3 != "EN SITIO"?
                          Text('En sitio', style: TextStyle(color: Colors.grey),)
                              :
                          Text('En sitio', style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold),),
                          SizedBox(width: 20,),
                          Text(ensitio)
                        ],
                      ),
                      SizedBox(height: 10,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          estado3 != "FINALIZO SERVICIO"?
                          Text('Finalizo', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),)
                              :
                          Text('Finalizo', style: TextStyle(color: Color(0xff6DA08E), fontWeight: FontWeight.bold),),
                          SizedBox(width: 20,),
                          Text(finalizo),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
  Future<void> _sheetRepas(context, newid, nombrerepa) async {
    void _borrarElemento (BuildContext context, String newid) {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text('¿Deseas borrar este servicio?', style: TextStyle(color: Colors.black)),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                child: Text("Si"),
                onPressed: () {
                  Navigator.of(context).pop(); //Te regresa a la pantalla anterior

                  FirebaseFirestore.instance.collection('Servicios').doc(newid).delete();

                },
              ),
            ],
          );
        },
      );
    }

    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text('R E P A R T I D O R E S', style: TextStyle(fontSize: 25, color: Colors.purple[900]),),
                    ]
                ),

                Expanded(
                  child: StreamBuilder(
                    //Asi encontraremos los negocios por ciudad y sin problemas con la BD
                      stream: reflistarepas.where('id', isEqualTo: '123').orderBy('nombre', descending: false).snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text("Loading..");
                        }
                        //reference.where("title", isEqualTo: 'UID').snapshots(),

                        else
                        {
                          Map<String, dynamic> documents = snapshot.data! as Map<String, dynamic>;
                          String cantidad = documents['cantidad'].toString();
                          String fecha = documents['miembrodesde'].toString();
                          String nombre = documents['nombre'].toString();
                          double costo = documents['costoProducto'];
                          String newid = documents['newid'].toString();
                          String colonia = documents['colonia'].toString();
                          String calle = documents['calle'].toString();
                          int numero = documents['numeroext'];
                          int celular = documents['celular'];
                          String correorepa = documents['correo'].toString();
                          String estado = documents['estado'].toString();
                          String tipodepago = documents['tipodepago'].toString();
                          String mesa = documents['servicio'];
                          return ListTile(
                              tileColor: Colors.white,
                              title: Card(
                                color: Colors.white,
                                elevation: 7.0,
                                child: Column(
                                  children: <Widget>[

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 50,
                                          width: 60,
                                          child: Icon(Icons.home, color: Colors.purple[900], size: 35,),
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(nombre, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.purple[900]),),
                                            //Text(costo.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              onLongPress: (){

                                _borrarElemento(context, newid);
                              },

                              onTap: () async{

                                //NO SE SI ESTE BIEN ESTE NEWID, DECIA NEWIDPEDIDO ANTERIORMENTE
                                FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(newid).update({
                                  'correorepa': correorepa,
                                  'nombrerepa': nombre,
                                });

                                Toast.show("¡Agregado exitosamente!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);

                                Navigator.of(context).pop(); //Te regresa a la pantalla anterior


                              }
                          );
                        }
                      }
                  ),
                ),
                //total(context),
              ],
            ),
          );
        }
    );
  }
  CollectionReference reflistarepas = FirebaseFirestore.instance.collection('Repartidor_Registro');

  listaPedidos(){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;
    return Expanded(
      child: StreamBuilder(
        //Asi encontraremos los negocios por ciudad y sin problemas con la BD
          stream: reflistaproduccion.where("correopersonal", isEqualTo: correo).orderBy('folio', descending: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if (!snapshot.hasData) {
              return Text("Loading..");
            }
            //reference.where("title", isEqualTo: 'UID').snapshots(),

            else
            {
              //ESTE SI FUNCIONA, VOLVER A HACER TODO COM ESTE WIDGET
              return ListView(
                children: snapshot.data!.docs.map((documents) {

                  //LAS VARIABLES QUE DELCARO AQUI HACEN EL BAD STATE!!!!!!!

                  return InkWell(
                    onLongPress: (){

                      print("lista pedidos");

                      documents["estadoc"] == "adomi"?
                      _sheetRepas(context, documents["newid"], documents["repa"])
                          :
                      print("a recoger");
                      //PONER SHEET REPAS PARA ASIGNAR UNO Y LISTO!
                      //_borrarElemento(context, newid);

                    },
                    onTap: () async{

                      await Navigator.push(context, MaterialPageRoute(builder: (context) => compras_detalle(panel_pedido_modelo("", documents["nombrecliente"],documents["empresa"],documents["folio"],2,0, 0,0, documents["concepto"], documents["estado3"], documents["tiempodeespera"], documents["miembrodesde"],documents["newid"], documents["totalNota"], "calle", "v",0, documents["tel"], documents["estadoc"], "prueba"))),);

                      FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(documents["newid"]).update({'visto': 'si'});

                    },
                    child: Card(
                      elevation: 1.0,
                      color:
                      documents["visto"] == "no"?
                      Colors.white
                          :
                      Colors.white,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 5, left: 5,bottom: 5, top:5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                  child: Icon(Icons.arrow_forward, color: Colors.white, size: 25,),
                                                  onTap:(){
                                                    _tiempoRecorrido(context, documents["estado3"], documents["pendiente"], documents["transitopendiente"], documents["encamino"], documents["ensitio"], documents["finalizo"], documents["hora"]);
                                                  }
                                              ),
                                              //Text("ID"+folio.toString(), style: TextStyle(color: Colors.white)),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                              documents["repa"] == "Nadie"?
                                              Color(0xff6DA08E)
                                                  :
                                              Colors.green[700]

                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(
                                                width: 120,
                                                child: Text('Pedido #'+documents["folio"].toString(), textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),)),

                                            SizedBox(
                                                width: 120,
                                                child: Text(documents["estado3"], textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xff6DA08E)),)),

                                          ],
                                        ),
                                        SizedBox(width: 10),
                                        SizedBox(
                                          width: 120.0,
                                          child: Column(
                                            children: [
                                              Text(documents["concepto"],
                                                  maxLines: 1,
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false,
                                                  style: TextStyle(color:Color(0xff6DA08E))),
                                              SizedBox(height: 10,),
                                              Text("Tiempo "+documents["tiempodeespera"].toString()+" | "+documents["hora"],
                                                  maxLines: 1,
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false,
                                                  style: TextStyle(color:Colors.grey)),
                                              documents["repa"] == "Nadie"?
                                              Container()
                                                  :
                                              Text(documents["repa"], style: TextStyle(color:Color(0xff6DA08E)), maxLines: 1, overflow: TextOverflow.fade, softWrap: false),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    //
                                    // InkWell(
                                    //onTap: (){

                                    //  _tiempoRecorrido(context, estado3, pendiente, transitopendiente, encamino, ensitio, finalizo, hora);

                                    //},
                                    //child: Icon(Icons.timer)
                                    //),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          }
      ),
    );
  }


  void correo () async {

    final FirebaseAuth auth = FirebaseAuth.instance;
    if(FirebaseAuth.instance.currentUser?.email == null){
// not logged
    setState(() {
      sesion = false;
      print("Sin pestania $sesion");
    });

    } else {
// logged
      setState(() {
        sesion = true;
        print("Con pestania $sesion");
      });
    }
  }

  var tiempo, empresa, coloniaNegocio, calleNegocio;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('¿Deseas cerrar la sesión?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text('Si'),
                    onPressed: () {

                      signOut();
                      Navigator.of(context).pushNamed("/clientes_login");
                    },
                  ),
                ],
              );
            }
        );

        return value == true;
      },
      child: Scaffold(
        //),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20.0,),

              sesion == true?
              listaPedidos()
              :
                  Container(),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}

class OnelookLogoBarra extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    AssetImage assetImage = AssetImage('images/siento11.png');
    Image image = Image(image: assetImage, height: 33,);
    return Padding(
      padding: EdgeInsets.only(top:5),
      child: Container(child: image,),
    );
  }
}
