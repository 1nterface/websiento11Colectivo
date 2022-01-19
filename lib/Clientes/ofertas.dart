import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:websiento11/Modelo/cajas_modelo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

class ofertas extends StatefulWidget {
  @override
  ofertasState createState() => ofertasState();
}

class ofertasState extends State<ofertas> {

  CollectionReference reflistaproduccion = FirebaseFirestore.instance.collection('Promociones');

  var category;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

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
              child: const Text('Cancelar'),
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

  FirebaseAuth auth = FirebaseAuth.instance;
  signOut() async {
    await auth.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
          onWillPop: () async {
            final value = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text('¿Deseas salir de la compra?'),
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
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                //Asi encontraremos los negocios por ciudad y sin problemas con la BD
                  stream: reflistaproduccion.where("id", isEqualTo: "promo").orderBy('folio', descending: false).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(!snapshot.hasData){
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    //reference.where("title", isEqualTo: 'UID').snapshots(),

                    else
                    {
                      return ListView(
                        children: snapshot.data!.docs.map((documents) {

                          //LAS VARIABLES QUE DELCARO AQUI HACEN EL BAD STATE!!!!!!!

                          return Card(
                            elevation: 7.0,
                            color: Colors.white,
                            child: Container(
                              height: 300,
                              width: 100,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.scaleDown,
                                    image: NetworkImage(documents["foto"])
                                ),
                                //borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                color: Colors.transparent,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
