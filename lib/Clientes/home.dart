import 'package:badges/badges.dart';
import 'package:websiento11/Modelo/cajas_modelo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:websiento11/Clientes/menu_cliente.dart' as menu;
import 'package:websiento11/Clientes/ofertas.dart' as ofertas;
import 'package:websiento11/Clientes/compras.dart' as compras;
import 'package:location_permissions/location_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class home extends StatefulWidget {

  int selectedPage;

  cajas_modelo product;
  home(this.product, this.selectedPage);

  @override
  homeState createState() => homeState();
}

class homeState extends State<home> with SingleTickerProviderStateMixin {

  late int selectedPage;

  late TabController controller;

  Future<void> comprasNotificacion (BuildContext context)async{

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;

    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Pedidos_Jimena').where('correopersonal', isEqualTo: correoPersonal).where('visto', isEqualTo: "si").get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    print("Esto quiero: "+_myDocCount.length.toString());

    QuerySnapshot _myDoc2 = await FirebaseFirestore.instance.collection('Pedidos_Jimena').where('correopersonal', isEqualTo: correoPersonal).where('visto', isEqualTo: "no").get();
    List<DocumentSnapshot> _myDocCount2 = _myDoc2.docs;
    print("Esto quiero: "+_myDocCount2.length.toString());

    int total =   _myDocCount.length - _myDocCount2.length;
    FirebaseFirestore.instance.collection('Notificaciones').doc("Compras"+correoPersonal.toString()).set({'notificacion': total.toString()});
  }

  void correo () async {

    final FirebaseAuth auth = FirebaseAuth.instance;
    if(FirebaseAuth.instance.currentUser?.uid == null){
// not logged
      print("Sin pestania");
    } else {
// logged
      print("Con pestania");

    }
  }

  @override
  void initState() {

    selectedPage = 0;
    correo();
    print("NOMBRE EMPRESA PARA PASAR A MENU CLIENTES: "+widget.product.nombreProducto);

    //comprasNotificaciones(context);
    //promosNotificaciones(context);
    // TODO: implement initState
    controller = TabController(length: 7, vsync: this);
    super.initState();
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  signOut() async {
    await auth.signOut();
  }

  @override
  void dispose() {
    signOut();
    // TODO: implement dispose
    //signOut();
    controller.dispose();
  }

  CollectionReference promo = FirebaseFirestore.instance.collection('Notificaciones');

  Widget promosNotificaciones (BuildContext context){
    return FutureBuilder<DocumentSnapshot>(
      future: promo.doc("Promos").get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return
            data["notificacion"] == "0"?
            Column(
              children: [
                Tab(icon: Icon(Icons.announcement, color: Colors.white,)),
                Text("OFERTAS", style: TextStyle(color: Colors.white),),
              ],
            )
                :
            Badge(
              position: BadgePosition(left: 40),
              badgeColor: Colors.red[700],
              badgeContent: Text(data["notificacion"], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white), ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Column(
                  children: [
                    Tab(icon: Icon(Icons.announcement, color: Colors.white,)),
                    Text("OFERTAS", style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
            );
        }

        return Text("loading");
      },
    );
  }

  Widget comprasNotificaciones (BuildContext context){

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;

    return StreamBuilder<DocumentSnapshot<Object?>>(
        stream: FirebaseFirestore.instance.collection('Notificaciones').doc("Compras"+correoPersonal.toString()).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;


            return
              data["notificacion"] == "0"?
              Column(
                children: const [
                  Tab(icon: Icon(Icons.monetization_on, color: Colors.white,)),
                  Text("COMPRAS", style: TextStyle(color: Colors.white),),
                ],
              )
                  :
              Badge(
                position: BadgePosition(left: 40),
                badgeColor: Colors.white,
                badgeContent: Text(data["notificacion"], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red), ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Column(
                    children: [
                      Tab(icon: Icon(Icons.monetization_on, color: Colors.white,)),
                      Text("COMPRAS", style: TextStyle(color: Colors.white),),
                    ],
                  ),

                ),
              );

          }
        }
    );
  }

  Widget comprasNotificaciones2 (BuildContext context){

    return Column(
      children: const [
        Tab(icon: Icon(Icons.monetization_on, color: Colors.white,)),
        Text("COMPRAS", style: TextStyle(color: Colors.white),),
      ],
    );
  }

  var now = DateTime.now();



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex:selectedPage,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xff6DA08E),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Siento11 Colectivo", style: const TextStyle(color: Colors.white),),
              InkWell(
                  onTap:(){

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog
                        return AlertDialog(
                          title: Text('¿Deseas cerrar sesion?', style: TextStyle(color: Colors.black)),
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
                                Navigator.of(context).pushNamedAndRemoveUntil('/clientes_login', (route) => false);
                                signOut();
                              },
                            ),
                          ],
                        );
                      },
                    );

                    //_tiempoRecorrido(context, documents["estado3"], documents["pendiente"], documents["transitopendiente"], documents["encamino"], documents["ensitio"], documents["finalizo"], documents["hora"]);
                  },
                child: Icon(Icons.exit_to_app),
              ),
            ],
          ),
          bottom: TabBar(
            isScrollable: true,
            controller: controller,
            tabs: <Widget>[
              Column(
                children: [
                  Tab(icon: Icon(Icons.home, color: Colors.white,)),
                  Text("CATALOGO", style: TextStyle(color: Colors.white),),
                  Text("CATALOGO", style: TextStyle(color: Colors.white),),
                  Text("CATALOGO", style: TextStyle(color: Colors.white),),
                  Text("CATALOGO", style: TextStyle(color: Colors.white),),
                  Text("CATALOGO", style: TextStyle(color: Colors.white),),
                ],
              ),
              //Tab(icon: Icon(Icons.chat), text: "CHAT",),
              promosNotificaciones(context),
              FirebaseAuth.instance.currentUser?.email == null?
              comprasNotificaciones2(context)
              :
              comprasNotificaciones(context),
            ],
          ),
        ),
        body: TabBarView(
          controller: controller,
          children: <Widget>[
            //proveedor.Menu_Clientes2(),
            menu.menu_cliente(widget.product.nombreProducto, widget.product.nombreProveedor, widget.product.newid, widget.product.foto, widget.product.estado, widget.product.codigoDeBarra, widget.product.maximo, widget.product.minimo),
            ofertas.ofertas(),
            compras.compras(),
            compras.compras(),
            compras.compras(),
            compras.compras(),
            compras.compras(),
            //acreedores.Mis_Compras2(),
            //empleados.Pagos_Clientes(),
          ],
        ),
      ),
    );
  }
}

