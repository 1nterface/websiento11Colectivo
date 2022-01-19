import 'dart:math';

import 'package:websiento11/Modelo/panel_pedido_modelo.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:websiento11/Modelo/cajas_modelo.dart';
import 'package:websiento11/Modelo/cajas_modelo.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class compras_detalle extends StatefulWidget {

  panel_pedido_modelo product;
  compras_detalle(this.product);

  @override
  compras_detalleState createState() => compras_detalleState();
}

class compras_detalleState extends State<compras_detalle> {

  CollectionReference reflistaproduccionotros = FirebaseFirestore.instance.collection('Insumos_Otros');
  CollectionReference reflistaproduccion = FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna');
  CollectionReference reflistacajasinsumos = FirebaseFirestore.instance.collection('Cajas_Insumos');
  CollectionReference reflistacajas = FirebaseFirestore.instance.collection('Cajas');
  CollectionReference reflistadecarrito = FirebaseFirestore.instance.collection('Ingredientes');
  CollectionReference reflistarepas = FirebaseFirestore.instance.collection('Repartidor_Registro');

  final TextEditingController _producto = TextEditingController();
  final TextEditingController _cantidad = TextEditingController();
  final TextEditingController _precio = TextEditingController();

  void _igualarACero (BuildContext context, String newid) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('¿Deseas igualar a cero el total?', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Si"),
              onPressed: () {

                FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(newid).update({
                  'totalNota': 0.0,
                  'estado3': 'PENDIENTE',
                  'concepto': '',
                });
                Navigator.of(context).pop(); //Te regresa a la pantalla anterior
                Navigator.of(context).pop(); //Te regresa a la pantalla anterior
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

  Widget total (BuildContext context){
    return StreamBuilder<DocumentSnapshot<Object?>>(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(widget.product.newid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

            int decimals = 2;
            num fac = pow(10, decimals);
            double costo = data["totalNota"];
            costo = (costo * fac).round() / fac;

            return Text('\$'+costo.toString(), style: TextStyle(color: Colors.black, fontSize: 40.0, fontWeight: FontWeight.bold),);

          }
        }
    );
  }
  Widget subtotal (BuildContext context){
    return StreamBuilder<DocumentSnapshot<Object?>>(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(widget.product.newid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data!.data() as Map<String, dynamic>;

            double resultadof = 0;
            double flete2 = userDocument["flete"];

            int decimals = 2;
            num fac = pow(10, decimals);
            double costo = userDocument["totalNota"];
            costo = (costo * fac).round() / fac;
            resultadof =  costo-flete2;

            return Text('\$'+costo.toString(), style: TextStyle(color: Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold),);

          }
        }
    );
  }
  Widget total4   (BuildContext context){
    return StreamBuilder<DocumentSnapshot<Object?>>(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(widget.product.newid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data!.data() as Map<String, dynamic>;

            int decimals = 2;
            num fac = pow(10, decimals);

            //HAY UN PEDO CON EL TOTAL DE LA NOTA, VERL QUE HACER
            // ENTRE RESCATE Y PEDIDO EN LINEA
            double costo = userDocument["totalNota"];
            costo = (costo * fac).round() / fac;

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                    onTap: (){
                      _igualarACero(context, widget.product.newid);
                    },
                    child: Text('\$'+costo.toString(), style: TextStyle(color: Colors.black, fontSize: 40.0, fontWeight: FontWeight.bold),)),
              ],
            );

          }
        }
    );
  }

  Future<int> pedidos (BuildContext context)async{

    var now = DateTime.now();

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;

    QuerySnapshot _myDoc2 = await FirebaseFirestore.instance.collection('Pedidos_Jimena').where('correopersonal', isEqualTo: correoPersonal).where("visto", isEqualTo: "si").get();
    List<DocumentSnapshot> _myDocCount2 = _myDoc2.docs;
    print("Notificacion: "+_myDocCount2.length.toString());

    FirebaseFirestore.instance.collection('Notificaciones').doc("Pedidos"+correoPersonal.toString()).update  ({'visto': "si"});

    return _myDocCount2.length;
    //CREO QUE AQUI VA LA CREACION DE UNA RUTA PARA EL REPARTIDOR POR NEGOCIO CON EL FOLIO



  }

  @override
  void initState() {
    // TODO: implement initState
    print(widget.product.estado);
    total(context);
    total4(context);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    total(context);
    total4(context);
    pedidos(context);

    super.dispose();
  }

  var category;
  final _formKey = GlobalKey<FormState>();

  Widget _buildAboutDialog(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          AlertDialog(
            title: Text("Agregar producto"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                        return 'Escribe el producto';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                    controller: _producto,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.phone_android,
                        color: Colors.black,
                      ),
                      hintText: 'Producto',
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
                        return 'Escribe la cantidad';
                      }
                      return null;
                    },
                    controller: _cantidad,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.add,
                        color: Colors.black,
                      ),
                      hintText: 'Cantidad',
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
                        return 'Escribe el precio';
                      }
                      return null;
                    },
                    controller: _precio,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.attach_money,
                        color: Colors.black,
                      ),
                      hintText: 'Precio',
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
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
                              child: Text('Agregar', style: TextStyle(color: Colors.white),),
                              onPressed: () async {

                                QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna').orderBy('folio').get();
                                List<DocumentSnapshot> _myDocCount = _myDoc.docs;

                                final collRef = FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna');
                                DocumentReference docReference = collRef.doc();

                                var now = DateTime.now();

                                double precio = double.parse(_precio.text);
                                int cantidad = int.parse(_cantidad.text);

                                double total = cantidad * precio;

                                docReference.set({
                                  'folio': widget.product.folio,
                                  'newid': docReference.id,
                                  'id': "987",
                                  'nombreProducto': _producto.text,
                                  'precio': precio,
                                  'cantidad': cantidad,
                                  'miembrodesde': DateFormat("dd-MM-yyyy").format(now),
                                  'total': total,
                                });

                                Navigator.pop(context);

                                _producto.clear();
                                _precio.clear();
                                _cantidad.clear();

                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    //Image.network(foto, height: 250,),
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

  bool ropa = true, zapatos = true, bolsas = true, filtro = false, filtro2 = false;

  Widget servicioADomi (BuildContext context){
    return StreamBuilder<DocumentSnapshot<Object?>>(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(widget.product.newid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data!.data() as Map<String, dynamic>;

            int decimals = 2;
            num fac = pow(10, decimals);
            double flete = userDocument["flete"];

            return Text('\$'+flete.toString(), style: TextStyle(color: Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold),);

          }
        }
    );
  }

  Future<void> _sheetCarrito(context) async {

    showModalBottomSheet(
        shape : RoundedRectangleBorder(
            borderRadius : BorderRadius.circular(30)
        ),
        context: context,
        builder: (BuildContext bc){
          return Stack(
            children: [
              StatefulBuilder(
                builder: (BuildContext context, setState) =>  Padding(
                  padding: const EdgeInsets.only(right:20.0, left: 20.0, top: 20.0, bottom: 30.0),
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 150.0, left: 150.0),
                          child: Container(

                            color: Colors.grey,
                            child: Column(
                              children: <Widget>[
                                Divider(color: Colors.grey[400], height: 5.0,),
                                //Divider(color: Colors.black26,),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height:10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              Text('Tu orden', style: TextStyle(color: Color(0xff6DA08E),fontSize: 35, fontWeight: FontWeight.bold)),
                              //Icon(Icons.cancel_outlined, color: Colors.purple[900],),
                            ]
                        ),
                        widget.product.estado == null?
                        Container()
                            :
                        Text("Ave. Rio Verde #1075", style: TextStyle(fontSize: 25, color: Colors.black)),
                        Text("Villa Verde", style: TextStyle(fontSize: 25, color: Colors.black)),
                        Padding(
                          padding: const EdgeInsets.only(right:20.0, left:20.0, top: 20.0, bottom: 20.0),
                          child: Column(
                            children: [
                              //Text(widget.product.codigoDeBarra, style: TextStyle(fontWeight: FontWeight.bold),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: [
                                  Text('Subtotal: ', style: TextStyle(color: Colors.black, fontSize: 20.0),),
                                  widget.product.nombreProveedor != "rescatesolicitado"?
                                  subtotal(context)
                                      :
                                  subtotal(context),
                                ],
                              ),
                              SizedBox(height:10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: [
                                  Text('Servicio A Dom.: ', style: TextStyle(color: Colors.black, fontSize: 20.0),),
                                  servicioADomi(context),                                ],
                              ),
                              SizedBox(height:12),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:[
                                    Text('Total: ', style: TextStyle(color: Colors.grey[500], fontSize: 40.0, fontWeight: FontWeight.bold),),
                                    widget.product.nombreProveedor != "rescatesolicitado"?
                                    totalbn(context)
                                        :
                                    totalbn(context),
                                  ]
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }
    );
  }


  bool _isChecked = false, _isChecked2 = false;
  List<String> text = ["Efectivo"];
  List<String> text2 = ["Tarjeta de Debito"];
  var tipodepago, category2;


  Widget totalbn (BuildContext context){
    return StreamBuilder<DocumentSnapshot<Object?>>(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(widget.product.newid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data!.data() as Map<String, dynamic>;

            int decimals = 2;
            num fac = pow(10, decimals);

            //HAY UN PEDO CON EL TOTAL DE LA NOTA, VERL QUE HACER
            // ENTRE RESCATE Y PEDIDO EN LINEA
            double flete2 = userDocument["flete"];
            double resultadof = 0;

            double costo = userDocument["totalNota"];
            costo = (costo * fac).round() / fac;
            resultadof = flete2 + costo;
            resultadof = (resultadof * fac).round() / fac;
            return Text('\$'+resultadof.toString(), style: TextStyle(color: Colors.black, fontSize: 40.0, fontWeight: FontWeight.bold),);

          }
        }
    );
  }

  Widget tiempos (BuildContext context){
    return StreamBuilder<DocumentSnapshot<Object?>>(
        stream: FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(widget.product.newid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

            String tiempo = data["estado3"];

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer),
                SizedBox(width: 5),
                Text(tiempo, style: TextStyle(color: Color(0xff6DA08E), fontSize: 15.0, fontWeight: FontWeight.bold),),
              ],
            );

          }
        }
    );
  }

  Widget _buildAboutDialoCam(BuildContext context, String foto) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.contain,
                image: NetworkImage(foto)
            ),
            //borderRadius: BorderRadius.all(Radius.circular(30.0)),
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              bottom: Radius.elliptical(
                  MediaQuery.of(context).size.width, 50.0)),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff6DA08E),
        title: Text("Orden #"+widget.product.folio.toString(), style: TextStyle(color: Colors.white),),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height:15),
                tiempos(context),
                Text("Tiempo de espera "+widget.product.foto+" min."),
                SizedBox(height:15),
                Expanded(
                  child: StreamBuilder(
                    //Asi encontraremos los negocios por ciudad y sin problemas con la BD
                      stream: reflistaproduccion.where('folio', isEqualTo: widget.product.folio).snapshots(),
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

                              double tot = documents["costo"];
                              //LAS VARIABLES QUE DELCARO AQUI HACEN EL BAD STATE!!!!!!!

                              return Card(
                                elevation: 1.0,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10, left: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:[
                                          Row(
                                              children:[
                                                Column(
                                                  children: [
                                                    InkWell(
                                                      onTap:(){
                                                        showDialog(context: context, builder: (BuildContext context) => _buildAboutDialoCam(context, documents["foto"]),);
                                                      },
                                                      child: Icon(Icons.image_outlined, size: 90, color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width:10),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children:[
                                                        SizedBox(height: 5),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children:[
                                                            SizedBox(
                                                              width: 150.0,
                                                              child: Text(
                                                                documents["nombreProducto"],
                                                                maxLines: 1,
                                                                overflow: TextOverflow.fade,
                                                                softWrap: false,
                                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 5),
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children:[
                                                              SizedBox(
                                                                  width: 150,
                                                                  child: Text("Cantidad : "+documents["cantidad"].toString(), textAlign: TextAlign.left, style: TextStyle(color: Colors.grey))),
                                                            ]
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ]
                                          ),
                                        ],
                                      ),

                                      Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children:[
                                            Text("\$"+documents["costo"].toString(), textAlign: TextAlign.left,style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                                          ]
                                      ),
                                    ],
                                  ),
                                ) ,
                              );
                            }).toList(),
                          );
                        }
                      }
                  ),
                ),

                //Image.network(widget.product.foto),
              ],
            ),
          ),
          //ACOMODAR BIEN LA LISTA DE INGREDIENTES
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                    child: SizedBox(
                      child: RaisedButton(
                        color: Color(0xff6DA08E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        child: Text('Ver Total', style: TextStyle(color: Colors.white),),
                        onPressed: () async {


                          _sheetCarrito(context);

                          //METODO THANOSCOLECCION PARA BORRAR TOODA UNA COLECCION CON UNA CONDICION Y CON UN BOTON
                          //Firestore.instance.collection('Carrito').where('id', isEqualTo: '987').getDocuments().then((snapshot) {
                          //for (DocumentSnapshot doc in snapshot.documents) {
                          //doc.reference.delete();
                          //print('borrado');
                          //}
                          //})

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
    );
  }
}

