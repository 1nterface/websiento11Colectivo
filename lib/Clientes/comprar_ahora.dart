import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:websiento11/Clientes/como_quieres_pagar.dart';
//import 'package:repartamos/Clientes/Como_Quieres_Pagar2.dart';
import 'package:websiento11/Modelo/agentes_modelo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:websiento11/Modelo/nota_modelo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class comprar_ahora extends StatefulWidget {


  final nota_modelo product;
  const comprar_ahora(this.product);

  @override
  _comprar_ahoraState createState() => _comprar_ahoraState();
}

class _comprar_ahoraState extends State<comprar_ahora> {

  bool _isChecked = false, _isChecked2 = false, _isChecked3 = false;
  List<String> text = ["Recoger en establecimiento"];
  List<String> text2 = ["A Domicilio"];
  List<String> textExpress = ["Pedido Express"];
  var category;

  final spinkit = SpinKitPulse(
    color: Colors.black,
    size: 30.0,);


  sucursal (String sucursaln) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('sucursal', (sucursaln));
  }

  Widget estadoPizza (BuildContext context){
    return StreamBuilder(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Ventas').doc(widget.product.newid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data! as Map<String, dynamic>;

            return userDocument['estadoh'] != "horneando"?
            Column(
              children: <Widget>[
                Icon(Icons.check, color: Color(0xff6DA08E), size: 35,),
                Text('Levantando pedido')
              ],
            )
                :
            Column(
              children: <Widget>[
                Icon(Icons.check, color: Colors.green[700], size: 35,),
                Text('Levantando pedido')
              ],
            );
          }
        }
    );
  }

  Widget telefono (BuildContext context){
    return StreamBuilder<DocumentSnapshot<Object?>>(
        stream: FirebaseFirestore.instance.collection('Socios_Registro').doc(widget.product.foto).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data!.data() as Map<String, dynamic>;

            return Column(
              children: [
                Text(userDocument["colonia"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(userDocument["calle"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                    Text(userDocument["numero"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                  ],
                ),
              ],
            );
          }
        }
    );
  }

  void aviso (BuildContext context) async {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('Elige una sucursal', style: TextStyle(color: Colors.black)),
          actions: <Widget>[

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

  late List<String> tipodepago = [""];
  var colonia, correoresta;

  Widget estadoPizzaa (BuildContext context){
    return StreamBuilder(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Ventas').doc(widget.product.newid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data! as Map<String, dynamic>;

            return userDocument['estadoh'] != "horneando"?
            Column(
              children: <Widget>[
                Icon(Icons.check, color: Colors.red[900], size: 35,),
                Text('Levantando pedido')
              ],
            )
                :
            Column(
              children: <Widget>[
                Icon(Icons.check, color: Colors.green[700], size: 35,),
                Text('Levantando pedido')
              ],
            );
          }
        }
    );
  }

  late double flete = 0.0;
  final TextEditingController _calle = TextEditingController();
  final TextEditingController _numext = TextEditingController();

  @override
  void initState() {
    print(widget.product.direccion);
    // TODO: implement initState
    super.initState();
  }

  //REVISAR ESTE WIDGET, PARECE QUE SI VA A FUNCIONAR SOLO AGREGANDO ALGUNAS COSAS
  Widget recoger (BuildContext context){
    return StreamBuilder<DocumentSnapshot<Object?>>(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Socios_Registro').doc(widget.product.foto).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data!.data() as Map<String, dynamic>;
            String prueba = userDocument["recoger"];

            return
              prueba == "si"?
              Column(
                children: text
                    .map((t) => CheckboxListTile(
                  title: Text(t),
                  value: _isChecked,
                  onChanged: (val) async {

                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString('servicio', text.toString());

                    setState(() {
                      print("no palomita");
                      _isChecked = val!;
                      if(_isChecked == true){
                        setState(() {
                          //_sheetCarrito(context);
                          print("palomita");
                          tipodepago = text;
                          _isChecked2 = false;
                          _isChecked3 = false;

                        });
                      }
                    });
                  },
                ))
                    .toList(),
              )
                  :
              Container();

          }
        }
    );
  }
  Widget adomi (BuildContext context){
    return StreamBuilder<DocumentSnapshot<Object?>>(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Socios_Registro').doc(widget.product.foto).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data!.data() as Map<String, dynamic>;

            String prueba = userDocument["adomi"];

            return
              prueba == "si"?
              Column(
                children: text2
                    .map((t) => CheckboxListTile(
                  title: Text(t),
                  value: _isChecked2,
                  onChanged: (val) async {


                    final prefs2 = await SharedPreferences.getInstance();
                    correoresta = prefs2.getString('correoresta') ?? "";

                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString('servicio', text2.toString());

                    setState(() {
                      _isChecked2 = val!;
                      if(_isChecked2 == true){
                        setState(()  {
                          tipodepago = text2;
                          _isChecked3 = false;
                          _isChecked = false;
                        });
                      }
                    });
                  },
                ))
                    .toList(),
              )
                  :
              Container();

          }
        }
    );
  }

  bool reelige = false;

  void fleteMsj (BuildContext context, String coloniaa) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(coloniaa+' es correcto?', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Si"),
              onPressed: () {

                setState(() {
                  reelige = true;
                });
                Navigator.of(context).pop(); //Te regresa a la pantalla anterior
              },
            ),
            FlatButton(
              child: Text("No"),
              onPressed: () {

                 Navigator.of(context).pop(); //Te regresa a la pantalla anterior
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff6DA08E),
        centerTitle: true,
        title: Text('Pago Siento11 Colectivo', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('¿Que opcion deseas?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),

                //YA REFLEJA LOS TIPOS DE SERVICIO
                //FALTA REGISTRARLOS LA PRIMERA VEZ Y AGREGARLO EN CONFIGURACION
                recoger(context),
                adomi(context),

                SizedBox(height: 20,),
                //Text('Elige tu sucursal mas cercana', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                //GUARDAR CON SHARED PREFERENCES Y BAJARLO AL FINAL EN CADA SETDATA

                //Text(widget.product.nombreAgente, style: TextStyle(fontSize: 25),),
                //Text('C.P. 21254, Islas Carolina 2269 - Valmar y San Pedro'),
                //Text('Coronado Residencial - ensenada, B.C.'),
                _isChecked != false?
                Column(
                  children: <Widget>[
                    telefono(context),
                  ],
                )
                    :
                _isChecked2 != false?
                Column(

                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("Colonia").where('correoNegocio',isEqualTo: widget.product.foto).snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return Text("Please wait");
                          var length = snapshot.data!.docs.length;
                          DocumentSnapshot ds = snapshot.data!.docs[length - 1];
                          return DropdownButton(
                            items: snapshot.data!.docs.map((
                                DocumentSnapshot document) {
                              return DropdownMenuItem(
                                value: document["colonia"],
                                child: Text(document["colonia"], style: TextStyle(fontSize: 17.0),),);
                            }).toList(),
                            value: colonia,
                            onChanged: (value) {

                              //print(value);
                              setState(() {
                                reelige == false;

                                colonia = value;

                                //mensaje para buscar el flete

                              });


                              FirebaseFirestore.instance.collection('Colonia').where('correoNegocio', isEqualTo: widget.product.foto).where("colonia", isEqualTo: colonia).snapshots().listen((data) async {
                                data.docs.forEach((doc) async {

                                  setState(() async {

                                    flete = doc['flete'];
                                    //var medida = doc['medida'];

                                    print("Flete "+flete.toString());
                                    //print("newidpropio "+newidpropio);

                                    final prefs = await SharedPreferences.getInstance();
                                    //prefs.setString('newidpropio', newidpropio);
                                    prefs.setDouble('flete', flete);

                                    reelige == false?
                                    fleteMsj(context, colonia)
                                        :
                                        print("Flete establecido");

                                  });
                                }); //METODO THANOS FOR EACH

                              });
                              print(colonia);

                            },
                            hint: Text("Colonia", style: TextStyle(fontSize: 18.0),),
                            style: TextStyle(color: Colors.black),
                          );
                        }
                    ),
                    SizedBox(height: 20,),
                    colonia == null?
                        Container()
                    :
                    Padding(
                      padding: const EdgeInsets.only(right: 45.0, left: 45.0),
                      child: Container(
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
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(Icons.text_rotation_none,
                              color: Colors.black,
                            ),
                            hintText: 'Calle',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    colonia == null?
                    Container()
                        :
                    Padding(
                      padding: const EdgeInsets.only(right: 65.0, left: 65.0),
                      child: Container(
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
                              return 'Ingresa el numero exterior';
                            }
                            return null;
                          },
                          controller: _numext,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(Icons.star,
                              color: Colors.black,
                            ),
                            hintText: 'Numero ext.',
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                    :
                Container(),
                SizedBox(height: 20,),
                Text('Subtotal', style: TextStyle(fontSize: 30),),
                Text("\$"+widget.product.totalNota.toString(), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                _isChecked2 == false?
                    Container()
                :
                Text('Servicio a Dom.', style: TextStyle(fontSize: 30),),
                flete == null?
                    Container()
                :
                _isChecked2 == false?
                Container()
                    :
                Text("\$"+flete.toString(), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),

                Padding(
                  padding: EdgeInsets.all(20),
                  child: SizedBox(
                    width: 400,
                    height: 50,
                    child: SizedBox(
                      child: RaisedButton(
                        color: Color(0xff6DA08E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        child: Text('Continuar', style: TextStyle(color: Colors.white,fontSize: 20.0),),
                        onPressed: () async {

                          print("Correo business "+widget.product.foto);

                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString('correoNegocio', widget.product.foto);
                          prefs.setDouble('flete', flete);

                          //category == null?
                          //aviso(context)
                          //:
                          final prefs2 = await SharedPreferences.getInstance();
                          final correoresta = prefs2.getString('correoresta') ?? "";

                          FirebaseFirestore.instance.collection('Tiempo').where('correoNegocio', isEqualTo: widget.product.foto).snapshots().listen((data) async {
                            data.docs.forEach((doc) async {
                              var tiempo, tiempor;
                              tiempo = doc['tiempo'];
                              tiempor = doc['tiempor'];

                              print("tiempo "+tiempo);

                              final prefs = await SharedPreferences.getInstance();
                              _isChecked == true?
                              prefs.setString('tiempo', tiempor)
                              :
                              prefs.setString('tiempo', tiempo);


                            }); //METODO THANOS FOR EACH

                          });

                          await Navigator.push(context, MaterialPageRoute(builder: (context) => como_quieres_pagar(nota_modelo("", widget.product.direccion, widget.product.folio,0, _calle.text, colonia, widget.product.totalNota, category,flete,0,widget.product.foto, _numext.text,tipodepago.toString()))),);

                          //Navigator.of(context).pushNamed("/como_quieres_pagar");

                        },
                      ),
                    ),
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FirestoreListViewCarrito extends StatelessWidget {

  final List<DocumentSnapshot> documentsconfircarrito;
  const FirestoreListViewCarrito({required this.documentsconfircarrito});

  void _borrarElemento (BuildContext context, String id) async {
    var category;
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('¿Borrar del carrito?', style: TextStyle(color: Colors.black)),
          actions: <Widget>[



            FlatButton(
              onPressed: (){

                Navigator.of(context).pop();

              },
              child: Text('Cancelar'),
            ),
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Si"),
              onPressed: () async {
                FirebaseFirestore.instance.collection('Carrito').doc(id).delete();

                QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Ventas').orderBy('folio').get();
                List<DocumentSnapshot> _myDocCount = _myDoc.docs;

                QuerySnapshot _myDocE = await FirebaseFirestore.instance.collection('Carrito').where('folio', isEqualTo: _myDocCount.length+1).get();
                List<DocumentSnapshot> _myDocCountE = _myDocE.docs;
                //print('Weed: '+ _myDocCountE.length.toString() +1.toString());
                print('hey');
                var total = _myDocCountE.length;
                FirebaseFirestore.instance.collection('Notificaciones').doc("Carrito").update({'notificacion': total.toString()});

                Navigator.of(context).pop(); //Te regresa a la pantalla anterior

              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: documentsconfircarrito.length,
      itemExtent: 70.0, //Altura de cada renglon de la lista
      itemBuilder: (BuildContext context, int index) {
        String nombreProducto = documentsconfircarrito[index]['nombreProducto'].toString();
        String foto = documentsconfircarrito[index]['foto'].toString();
        String correoProveedor = documentsconfircarrito[index]['correoProveedor'].toString();
        String rfc = documentsconfircarrito[index]['rfc'].toString();
        String fecha = documentsconfircarrito[index]['fecha'].toString();
        String newid = documentsconfircarrito[index]['newid'].toString();
        String cantidad = documentsconfircarrito[index]['cantidad'].toString();
        double total = documentsconfircarrito[index]['totalProducto'];


        return ListTile(
          title: Stack(
            children: <Widget>[
              InkWell(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(cantidad),
                        Text(nombreProducto, style: TextStyle(fontSize: 15.0),),
                        Text("\$"+total.toString()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            InkWell(
                              onTap: () async {

                                SharedPreferences preferences = await SharedPreferences.getInstance();
                                await preferences.remove('totalProducto');

                                Navigator.of(context).pop();

                                _borrarElemento(context, newid);
                              },
                              child: Icon(Icons.restore_from_trash, color: Color(0xff6DA08E)),
                            ),
                          ],
                        ),
                        //Text(telefonoProveedor),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          //onTap: (){

          //Firestore.instance.runTransaction((transaction) async {
          //DocumentSnapshot snapshot = await transaction.get(documentsconfir[index].reference);
          //Firestore.instance.collection('Citas').document(snapshot.documentID).updateData({'estado': 'VentaRealizada'});
          //});

          //Firestore.instance.runTransaction((transaction) async {
          //DocumentSnapshot snapshot = await transaction.get(documentsconfir[index].reference);
          //await transaction.delete(snapshot.reference);
          //});

          //_crearRegistro();
          //}
        );
      },
    );
  }
}
