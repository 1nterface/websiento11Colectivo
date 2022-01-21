import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:websiento11/Clientes/home.dart';
//import 'package:onelook/Clientes/Pago_Con_Tarjeta2_Oficial.dart';
//import 'package:onelook/Clientes/Pago_Efectivo_En_Oxxo2_Oficial.dart';
//import 'package:onelook/Clientes/Pago_Transferencia2_Oficial.dart';
import 'package:websiento11/Modelo/agentes_modelo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:websiento11/Modelo/cajas_modelo.dart';
import 'package:websiento11/Modelo/nota_modelo.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class como_quieres_pagar extends StatefulWidget {

  final nota_modelo product;
  const como_quieres_pagar(this.product);

  @override
  como_quieres_pagarState createState() => como_quieres_pagarState();
}

class como_quieres_pagarState extends State<como_quieres_pagar> {


  void _ventanaFlotante(BuildContext context){

    Alert(
        context: context,
        title: "Activa tu GPS para continuar",
        //content: Icon(Icons.location_on, size: 40, color: Colors.red[900],),
        buttons: [
          DialogButton(
            color: Colors.red[900],
            onPressed: () {
              //inputData();
              Navigator.pop(context);
            },
            child: Text("Salir", style: TextStyle(color: Colors.white, fontSize: 20),),
          )
        ]).show();
  }

  //METODO PARA CHECAR SI EL GPS ESTA PRENDIDO, SI NO, SALDRA UN MENSAJE PARA QUE LO ENCIENDAN Y CONTINUE LA COMPRA
  void checkServiceStatusEfectivo(BuildContext context) {
      terminarCompra(context);

  }

  void checkServiceStatusTarjeta(BuildContext context) {
    terminarCompraTar(context);

  }

  //METODO PARA CHECAR SI EL GPS ESTA PRENDIDO, SI NO, SALDRA UN MENSAJE PARA QUE LO ENCIENDAN Y CONTINUE LA COMPRA
  void checkServiceStatusSolicitar(BuildContext context, LocationPermissionLevel permissionLevel) {
    LocationPermissions().checkServiceStatus().then(( serviceStatus) {

      //OFICIAL
      //
      //AQUI ES DONDE TENGO QUE HACER LA CONDICION PARA QUE PRENDA EL GPS O CONTINUE CON LA ACCION
      print("Status real: "+serviceStatus.toString());
      serviceStatus.toString() == "ServiceStatus.disabled"?
      _ventanaFlotante(context)
          :
      terminarCompraTerminal(context);


    });
  }

  //METODO PARA CHECAR SI EL GPS ESTA PRENDIDO, SI NO, SALDRA UN MENSAJE PARA QUE LO ENCIENDAN Y CONTINUE LA COMPRA
  void checkServiceStatusPuntoPago(BuildContext context, LocationPermissionLevel permissionLevel) {
    LocationPermissions().checkServiceStatus().then(( serviceStatus) {

      //OFICIAL
      //
      //AQUI ES DONDE TENGO QUE HACER LA CONDICION PARA QUE PRENDA EL GPS O CONTINUE CON LA ACCION
      print("Status real: "+serviceStatus.toString());
      serviceStatus.toString() == "ServiceStatus.disabled"?
      _ventanaFlotante(context)
          :
      terminarCompraOxxo(context);


    });
  }

  //METODO PARA CHECAR SI EL GPS ESTA PRENDIDO, SI NO, SALDRA UN MENSAJE PARA QUE LO ENCIENDAN Y CONTINUE LA COMPRA
  void checkServiceStatusTransferencia(BuildContext context, LocationPermissionLevel permissionLevel) {
    LocationPermissions().checkServiceStatus().then(( serviceStatus) {

      //OFICIAL
      //
      //AQUI ES DONDE TENGO QUE HACER LA CONDICION PARA QUE PRENDA EL GPS O CONTINUE CON LA ACCION
      print("Status real: "+serviceStatus.toString());
      serviceStatus.toString() == "ServiceStatus.disabled"?
      _ventanaFlotante(context)
          :
      terminarCompraTransfer(context);


    });
  }

  //METODO PARA CHECAR SI EL GPS ESTA PRENDIDO, SI NO, SALDRA UN MENSAJE PARA QUE LO ENCIENDAN Y CONTINUE LA COMPRA
  void checkServiceStatusTarjetaDebito(BuildContext context) {
    LocationPermissions().checkServiceStatus().then(( serviceStatus) async {

      //OFICIAL
      //
      //AQUI ES DONDE TENGO QUE HACER LA CONDICION PARA QUE PRENDA EL GPS O CONTINUE CON LA ACCION
      print("Status real: "+serviceStatus.toString());
      serviceStatus.toString() == "ServiceStatus.disabled"?
      _ventanaFlotante(context)
          :
          print("pago con tarjeta segun");
      //await Navigator.push(context, MaterialPageRoute(builder: (context) => Pago_Con_Tarjeta2_Oficial(Nota_Modelo(null, "", 0,0,"","",widget.product.totalNota, "",0,0,"","",""))),);

    });
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
                  Tab(icon: Icon(Icons.monetization_on, color: Colors.brown,)),
                  Text("COMPRAS", style: TextStyle(color: Colors.brown),),
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
                      Tab(icon: Icon(Icons.monetization_on, color: Colors.brown,)),
                      Text("COMPRAS", style: TextStyle(color: Colors.brown),),
                    ],
                  ),

                ),
              );

          }
        }
    );
  }

  Future<int> comprasNotificacion (BuildContext context)async{

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;

    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Pedidos_Jimena').where('correopersonal', isEqualTo: correoPersonal).where('visto', isEqualTo: "no").get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    print("Esto quiero PAGAR RANCH: "+_myDocCount.length.toString());

    int total =   _myDocCount.length;
    FirebaseFirestore.instance.collection('Notificaciones').doc("Compras"+correoPersonal.toString()).set({'notificacion': total.toString()});
  return total;
  }

  Future<void> gps() async {
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //print(position.latitude.toDouble());
    //print(position.longitude.toDouble());
    var lat = position.latitude.toDouble();
    var lon = position.longitude.toDouble();
    print("Lat: "+lat.toString());
    print("Lon"+lon.toString());
  }
  void terminarCompraTransfer (BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('¿Deseas terminar tu compra?', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("No"),
              onPressed: () {

                Navigator.of(context).pop(); //Te regresa a la pantalla anterior

              },
            ),
            FlatButton(
              child: Text("Si"),
              onPressed: () async {

                //await Navigator.push(context, MaterialPageRoute(builder: (context) => Pago_Transferencia2_Oficial(Nota_Modelo(null, "", 0,0,"","",widget.product.totalNota, "",0,0,"","",""))),);

                //Navigator.of(context).pushNamed('/pago_transferencia');

                //gps();
                //final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

                QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Ventas').orderBy('folio').get();
                List<DocumentSnapshot> _myDocCount = _myDoc.docs;

                final collRef = FirebaseFirestore.instance.collection('Ventas');
                DocumentReference docReference = collRef.doc();

                var now = DateTime.now();

                final prefs4 = await SharedPreferences.getInstance();
                final servicio = prefs4.getString('servicio') ?? "";

                final FirebaseAuth auth = FirebaseAuth.instance;
                final User? user = auth.currentUser;
                final correoPersonal = user!.email;

                //print(position.latitude.toDouble());
                //print(position.longitude.toDouble());

                //SI ENCUENTRA EL CORREO DIRECTAMENTE, LEER WIDGET.PRODUCT.SUCURSAL
                //AL TOMAR AL SUCURSAL, YA PODEMOS USAR EL CORREO DEL NEGOCIO EN ENCARGADO_HOME
                FirebaseFirestore.instance.collection('Encargado_Registro').where('sucursal', isEqualTo: widget.product.sucursal).get().then((snapshot) async {
                  for (DocumentSnapshot doc in snapshot.docs) {

                    var correoNegocio = doc['correo'];

                    print("Correo Negocio: "+correoNegocio);

                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString('correoNegocio', correoNegocio);
                  }

                });


                //METODO THANOSCOLECCION PARA BORRAR TOODA UNA COLECCION CON UNA CONDICION Y CON UN BOTON
                //SOLO AUTENTIFICAR CORREO Y COLOCARLO AQUI
                FirebaseFirestore.instance.collection('Clientes_Registro').where('correo', isEqualTo: correoPersonal).get().then((snapshot) async {
                  for (DocumentSnapshot doc in snapshot.docs) {

                    var prueba = doc['calle'];
                    var nombre = doc['nombre'];
                    var tel = doc['telefono'];


                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString('prueba6', prueba);
                    prefs.setString('nombrecliente', nombre);
                    prefs.setString('tel', tel);

                    print(prueba);
                  }

                  final prefs5 = await SharedPreferences.getInstance();
                  final prueba = prefs5.getString('prueba6') ?? "";
                  final nombre = prefs5.getString('nombrecliente') ?? "";
                  //SharedPreferences paso #2
                  final totalreal = prefs5.getDouble('totalProducto') ?? "";
                  final sucursal = prefs4.getString('sucursal') ?? "";
                  final tel = prefs4.getString('tel') ?? "";

                  final FirebaseAuth auth = FirebaseAuth.instance;
                  final User? user = auth.currentUser;
                  final correoPersonal = user!.email;

                  final prefs7 = await SharedPreferences.getInstance();
                  final correoNegocio = prefs7.getString('correoNegocio') ?? "";

                  final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
                  //print(position.latitude.toDouble());
                  //print(position.longitude.toDouble());
                  var lat = position.latitude.toDouble();
                  var lon = position.longitude.toDouble();
                  print("Lat: "+lat.toString());
                  print("Lon"+lon.toString());

                  docReference.set({
                    'transitopendiente': "",
                    'encamino': "",
                    'ensitio': "",
                    'finalizo': "",
                    'tel': tel,
                    'concepto': "PAGO CON TARJERTA",
                    'estadoh': 'sinhornear',
                    'correoNegocio': correoNegocio,
                    'latitud': lat.toDouble(),
                    'longitud': lon.toDouble(),
                    'estadoefectivo': 'pagooxxo',
                    'estado3': 'PENDIENTE',
                    'correopersonal': correoPersonal,
                    'totalNota': totalreal,
                    'nombrecliente': nombre,
                    'direccion': prueba,
                    'servicio': servicio,
                    'estado': 'sinpagar',
                    'estado2': 'pedidoEnEspera',
                    'folio': _myDocCount.length+1,
                    'newid': docReference.id,
                    //'precioVenta': precio,
                    'foto': "prueba",
                    'id': "987",
                    'sucursal': widget.product.nombreProducto,
                    //'nombreProducto': nombreProducto,
                    //'foto': foto,
                    'miembrodesde': DateFormat("dd-MM-yyyy").format(now),
                    'repa': 'Nadie',

                    "categoria": "Nadie",
                    'tipodepago': widget.product.formadepago,
                  });

                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  await preferences.remove('prueba6');
                  await preferences.remove('nombrecliente');
                  await preferences.remove('servicio');
                  await preferences.remove('totalProducto');
                  await preferences.remove('correoNegocio');

                  //borrarSucursal();

                });

                //BLOQUE DE CODIGO PARA IGUALAR A CERO LA NOTIFICACION
                //QuerySnapshot _myDocE = await Firestore.instance.collection('Compras').where('folio', isEqualTo: _myDocCount.length+1).getDocuments();
                //List<DocumentSnapshot> _myDocCountE = _myDocE.documents;
                //print('Weed: '+ _myDocCountE.length.toString() +1.toString());
                //var total = _myDocCountE.length;
                //print("Este:"+total.toString());
                //Firestore.instance.collection('Notificaciones').document("Compras"+correoPersonal).updateData({'notificacion': "0"});
                //comprasNotificacion(context);

              },
            ),
          ],
        );
      },
    );
  }

  void terminarCompraOxxo (BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('¿Deseas terminar tu compra?', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            FlatButton(
              child: Text("No"),
              onPressed: () {

                Navigator.of(context).pop(); //Te regresa a la pantalla anterior

              },
            ),
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Si"),
              onPressed: () async {

                //await Navigator.push(context, MaterialPageRoute(builder: (context) => Pago_Efectivo_En_Oxxo2_Oficial(Nota_Modelo(null, "", 0,0,"","",widget.product.totalNota, "",0,0,"","",""))),);

                print("Total chilo: "+widget.product.totalNota.toString());
                //Navigator.of(context).pushNamed('/pago_efectivo_en_oxxo');

                //gps();
                //final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

                QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Ventas').orderBy('folio').get();
                List<DocumentSnapshot> _myDocCount = _myDoc.docs;

                final collRef = FirebaseFirestore.instance.collection('Ventas');
                DocumentReference docReference = collRef.doc();

                var now = DateTime.now();

                final prefs4 = await SharedPreferences.getInstance();
                final servicio = prefs4.getString('servicio') ?? "";

                final FirebaseAuth auth = FirebaseAuth.instance;
                final User? user = auth.currentUser;
                final correoPersonal = user!.email;

                //print(position.latitude.toDouble());
                //print(position.longitude.toDouble());

                //SI ENCUENTRA EL CORREO DIRECTAMENTE, LEER WIDGET.PRODUCT.SUCURSAL
                //AL TOMAR AL SUCURSAL, YA PODEMOS USAR EL CORREO DEL NEGOCIO EN ENCARGADO_HOME
                FirebaseFirestore.instance.collection('Encargado_Registro').where('sucursal', isEqualTo: widget.product.sucursal).get().then((snapshot) async {
                  for (DocumentSnapshot doc in snapshot.docs) {

                    var correoNegocio = doc['correo'];

                    print("Correo Negocio: "+correoNegocio);

                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString('correoNegocio', correoNegocio);
                  }

                });


                //METODO THANOSCOLECCION PARA BORRAR TOODA UNA COLECCION CON UNA CONDICION Y CON UN BOTON
                //SOLO AUTENTIFICAR CORREO Y COLOCARLO AQUI
                FirebaseFirestore.instance.collection('Clientes_Registro').where('correo', isEqualTo: correoPersonal).get().then((snapshot) async {
                  for (DocumentSnapshot doc in snapshot.docs) {

                    var prueba = doc['calle'];
                    var nombre = doc['nombre'];
                    var tel = doc['telefono'];


                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString('prueba6', prueba);
                    prefs.setString('nombrecliente', nombre);
                    prefs.setString('tel', tel);
                    print(prueba);
                  }

                  final prefs5 = await SharedPreferences.getInstance();
                  final prueba = prefs5.getString('prueba6') ?? "";
                  final nombre = prefs5.getString('nombrecliente') ?? "";
                  //SharedPreferences paso #2
                  final totalreal = prefs5.getDouble('totalProducto') ?? "";
                  final sucursal = prefs4.getString('sucursal') ?? "";
                  final tel = prefs4.getString('tel') ?? "";

                  final FirebaseAuth auth = FirebaseAuth.instance;
                  final User? user = auth.currentUser;
                  final correoPersonal = user!.email;

                  final prefs7 = await SharedPreferences.getInstance();
                  final correoNegocio = prefs7.getString('correoNegocio') ?? "";

                  final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
                  //print(position.latitude.toDouble());
                  //print(position.longitude.toDouble());
                  var lat = position.latitude.toDouble();
                  var lon = position.longitude.toDouble();
                  print("Lat: "+lat.toString());
                  print("Lon"+lon.toString());

                  docReference.set({
                    'transitopendiente': "",
                    'encamino': "",
                    'ensitio': "",
                    'finalizo': "",
                    'tel': tel,
                    'estadoc': 'acocina',
                    'concepto': "ENVIAR COMPROBANTE",
                    'estadoh': 'sinhornear',
                    'correoNegocio': correoNegocio,
                    'latitud': lat.toDouble(),
                    'longitud': lon.toDouble(),
                    'estadoefectivo': 'pagooxxo',
                    'estado3': 'PENDIENTE',
                    'correopersonal': correoPersonal,
                    'totalNota': totalreal,
                    'nombrecliente': nombre,
                    'direccion': prueba,
                    'servicio': servicio,
                    'estado': 'sinpagar',
                    'estado2': 'pedidoEnEspera',
                    'folio': _myDocCount.length+1,
                    'newid': docReference.id,
                    //'precioVenta': precio,
                    'foto': "prueba",
                    'id': "987",
                    'sucursal': sucursal,
                    //'nombreProducto': nombreProducto,
                    //'foto': foto,
                    'miembrodesde': DateFormat("dd-MM-yyyy").format(now),
                    'repa': 'Nadie',

                    'categoria': "Nadie",
                    'tipodepago': widget.product.formadepago,
                  });

                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  await preferences.remove('prueba6');
                  await preferences.remove('nombrecliente');
                  await preferences.remove('servicio');
                  await preferences.remove('totalProducto');

                  //comprasNotificacion(context);

                });

                //BLOQUE DE CODIGO PARA IGUALAR A CERO LA NOTIFICACION
                QuerySnapshot _myDocE = await FirebaseFirestore.instance.collection('Carrito').where('folio', isEqualTo: _myDocCount.length+1).get();
                List<DocumentSnapshot> _myDocCountE = _myDocE.docs;
                //print('Weed: '+ _myDocCountE.length.toString() +1.toString());
                var total = _myDocCountE.length;
                print("Este:"+total.toString());
                FirebaseFirestore.instance.collection('Notificaciones').doc("Carrito"+correoPersonal.toString()).update({'notificacion': "0"});

              },
            ),
          ],
        );
      },
    );
  }

  void terminarCompraTerminal (BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('¿Deseas terminar tu compra?', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            FlatButton(
              child: Text("No"),
              onPressed: () {

                Navigator.of(context).pop(); //Te regresa a la pantalla anterior

              },
            ),
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Si"),
              onPressed: () async {

                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();

                //gps();
                //final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

                QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Ventas').orderBy('folio').get();
                List<DocumentSnapshot> _myDocCount = _myDoc.docs;

                final collRef = FirebaseFirestore.instance.collection('Ventas');
                DocumentReference docReference = collRef.doc();

                var now = DateTime.now();

                final prefs4 = await SharedPreferences.getInstance();
                final servicio = prefs4.getString('servicio') ?? "";

                final FirebaseAuth auth = FirebaseAuth.instance;
                final User? user = auth.currentUser;
                final correoPersonal = user!.email;

                //print(position.latitude.toDouble());
                //print(position.longitude.toDouble());

                //SI ENCUENTRA EL CORREO DIRECTAMENTE, LEER WIDGET.PRODUCT.SUCURSAL
                //AL TOMAR AL SUCURSAL, YA PODEMOS USAR EL CORREO DEL NEGOCIO EN ENCARGADO_HOME
                FirebaseFirestore.instance.collection('Encargado_Registro').where('sucursal', isEqualTo: widget.product.sucursal).get().then((snapshot) async {
                  for (DocumentSnapshot doc in snapshot.docs) {

                    var correoNegocio = doc['correo'];

                    print("Correo Negocio: "+correoNegocio);

                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString('correoNegocio', correoNegocio);
                  }

                });


                //METODO THANOSCOLECCION PARA BORRAR TOODA UNA COLECCION CON UNA CONDICION Y CON UN BOTON
                //SOLO AUTENTIFICAR CORREO Y COLOCARLO AQUI
                FirebaseFirestore.instance.collection('Clientes_Registro').where('correo', isEqualTo: correoPersonal).get().then((snapshot) async {
                  for (DocumentSnapshot doc in snapshot.docs) {

                    var prueba = doc['calle'];
                    var nombre = doc['nombre'];
                    var tel = doc['telefono'];

                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString('prueba6', prueba);
                    var calle = doc['calle'];
                    var colonia = doc['colonia'];
                    prefs.setString('nombrecliente', nombre);
                    prefs.setString('tel', tel);
                    prefs.setString('colonia', colonia);
                    prefs.setString('calle', calle);
                    print(prueba);
                  }

                  final prefs5 = await SharedPreferences.getInstance();
                  final prueba = prefs5.getString('prueba6') ?? "";
                  final nombre = prefs5.getString('nombrecliente') ?? "";
                  final colonia = prefs5.getString('colonia') ?? "";
                  final calle = prefs5.getString('calle') ?? "";

                  //SharedPreferences paso #2
                  final totalreal = prefs5.getDouble('totalProducto') ?? "";
                  final sucursal = prefs4.getString('sucursal') ?? "";
                  final tel = prefs4.getString('tel') ?? "";

                  final FirebaseAuth auth = FirebaseAuth.instance;
                  final User? user = auth.currentUser;
                  final correoPersonal = user!.email;

                  final prefs7 = await SharedPreferences.getInstance();
                  final correoNegocio = prefs7.getString('correoNegocio') ?? "";

                  final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
                  //print(position.latitude.toDouble());
                  //print(position.longitude.toDouble());
                  var lat = position.latitude.toDouble();
                  var lon = position.longitude.toDouble();
                  print("Lat: "+lat.toString());
                  print("Lon"+lon.toString());

                  docReference.set({
                    'transitopendiente': "",
                    'encamino': "",
                    'ensitio': "",
                    'finalizo': "",
                    'calle': calle,
                    'colonia': colonia,
                    'tel': tel,
                    'estadoc': 'acocina',
                    'concepto': "POR PAGAR CON TARJETA",
                    'estadoh': 'sinhornear',
                    'correoNegocio': correoNegocio,
                    'latitud': lat.toDouble(),
                    'longitud': lon.toDouble(),
                    'estadoefectivo': 'enefectivo',
                    'estado3': 'PENDIENTE',
                    'correopersonal': correoPersonal,
                    'totalNota': totalreal,
                    'nombrecliente': nombre,
                    'direccion': prueba,
                    'servicio': servicio,
                    'estado': 'sinpagar',
                    'estado2': 'pedidoEnEspera',
                    'folio': _myDocCount.length+1,
                    'newid': docReference.id,
                    //'precioVenta': precio,
                    'foto': "prueba",
                    'id': "987",
                    'sucursal': sucursal,
                    //'nombreProducto': nombreProducto,
                    //'foto': foto,
                    'miembrodesde': DateFormat("dd-MM-yyyy").format(now),
                    "categoria": "Nadie",
                    'tipodepago': widget.product.formadepago,
                    'repa': "Nadie",

                  });

                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  await preferences.remove('prueba6');
                  await preferences.remove('nombrecliente');
                  await preferences.remove('servicio');
                  await preferences.remove('totalProducto');
                  await preferences.remove('calle');
                  await preferences.remove('colonia');
                  //comprasNotificacion(context);

                });

                //ARREGLARLO, HAY UN BUG EN DOCUMENTS.. 28 SEPT
                //BLOQUE DE CODIGO PARA IGUALAR A CERO LA NOTIFICACION
                //QuerySnapshot _myDocE = await Documents.instance.collection('Pedidos_Jimena_Interna').where('folio', isEqualTo: _myDocCount.length+1).get();
                //List<DocumentSnapshot> _myDocCountE = _myDocE.docs;
                //print('Weed: '+ _myDocCountE.length.toString() +1.toString());
                //var total = _myDocCountE.length;
                //print("Este:"+total.toString());
                //FirebaseFirestore.instance.collection('Notificaciones').doc("Carrito"+correoPersonal.toString()).update({'notificacion': "0"});

              },
            ),
          ],
        );
      },
    );
  }

  void terminarCompra (BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('¿Deseas finalizar tu compra?', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("No"),
              onPressed: () {

                Navigator.of(context).pop(); //Te regresa a la pantalla anterior

              },
            ),
            FlatButton(
              child: Text("Si"),
              onPressed: () async {


                //Navigator.of(context).pop();
                //Navigator.of(context).pop();
                //Navigator.of(context).pop();
                //Navigator.of(context).pop();

                //PASAR A HOME DE ESTA FORMA Y SI SE ACTUALIZA LA NOTIFICACION..PASAR VARIABLES NADAMAS PARA QUE SE
                //VEA EL TOTAL
                //Navigator.push(context, MaterialPageRoute(builder: (context) => home(cajas_modelo("","","",0,0,0,0,0,"","","","","",0),2)));

                //gps();
                final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

                QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Pedidos_Jimena').orderBy('folio').get();
                List<DocumentSnapshot> _myDocCount = _myDoc.docs;

                final collRef = FirebaseFirestore.instance.collection('Pedidos_Jimena');
                DocumentReference docReference = collRef.doc();

                var now = DateTime.now();

                final prefs4 = await SharedPreferences.getInstance();
                final servicio = prefs4.getString('servicio') ?? "";

                final FirebaseAuth auth = FirebaseAuth.instance;
                final User? user = auth.currentUser;
                final correoPersonal = user!.email;

                //print(position.latitude.toDouble());
                //print(position.longitude.toDouble());


                //METODO THANOSCOLECCION PARA BORRAR TOODA UNA COLECCION CON UNA CONDICION Y CON UN BOTON
                //SOLO AUTENTIFICAR CORREO Y COLOCARLO AQUI
                FirebaseFirestore.instance.collection('Clientes_Registro').where('correo', isEqualTo: correoPersonal).get().then((snapshot) async {
                  for (DocumentSnapshot doc in snapshot.docs) {

                    //var prueba = doc['calle'];
                    var nombre = doc['nombre'];
                    var tel = doc['telefono'];

                    final prefs = await SharedPreferences.getInstance();
                   // prefs.setString('prueba6', prueba);
                    prefs.setString('nombrecliente', nombre);
                    prefs.setString('tel', tel);
                    //print(prueba);
                  }

                  final prefs5 = await SharedPreferences.getInstance();
                  final prueba = prefs5.getString('prueba6') ?? "";
                  final nombre = prefs5.getString('nombrecliente') ?? "";
                  //SharedPreferences paso #2
                  final totalreal = prefs5.getDouble('totalProducto') ?? "";
                  final sucursal = prefs4.getString('sucursal') ?? "";
                  final tel = prefs4.getString('tel') ?? "";

                  final FirebaseAuth auth = FirebaseAuth.instance;
                  final User? user = auth.currentUser;
                  final correoPersonal = user!.email;

                  final prefs7 = await SharedPreferences.getInstance();
                  final correoNegocio = prefs7.getString('correoNegocio') ?? "";

                  final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
                  //print(position.latitude.toDouble());
                  //print(position.longitude.toDouble());
                  var lat = position.latitude.toDouble();
                  var lon = position.longitude.toDouble();
                  print("Lat: "+lat.toString());
                  print("Lon"+lon.toString());

                  final prefs2 = await SharedPreferences.getInstance();
                  final correoresta = prefs2.getString('correoresta') ?? "";
                  String tiempoo = prefs2.getString('tiempo') ?? "";
                  String tiempoor = prefs2.getString('tiempor') ?? "";
                  double flete = prefs2.getDouble('flete') ?? 0;
                  String empresa = prefs2.getString('empresa') ?? "";

                  DateTime now = DateTime.now();
                  String formattedDate = DateFormat('kk:mm:ss').format(now);

                  docReference.set({
                    'visto': 'no',
                    'empresa': widget.product.nombreProducto,
                    //'calle': widget.product.newid,
                    //'colonia': widget.product.direccion,
                    //'numext': widget.product.foto,
                    'flete': widget.product.latitud,
                    'tiempodeespera': tiempoo,
                    'tiempodeesperar': tiempoor,
                    'hora': formattedDate,
                    'tel': tel,
                    'estadoc': widget.product.formadepago=="[A Domicilio]"?'adomi':'recoger',
                    'concepto': "Efectivo",
                    'estadoh': 'sinhornear',
                    'correoNegocio': correoNegocio,
                    'latitud': lat.toDouble(),
                    'longitud': lon.toDouble(),
                    'estadoefectivo': 'enefectivo',
                    'estado3': widget.product.formadepago=="[A Domicilio]"?'PEDIDO A DOMICILIO':'PEDIDO A RECOGER',
                    'correopersonal': correoPersonal,
                    'totalNota': totalreal,
                    'nombrecliente': nombre,
                    'direccion': prueba,
                    'servicio': servicio,
                    'estado': 'sinpagar',
                    'estado2': 'pedidoEnEspera',
                    'folio': _myDocCount.length+1,
                    'newid': docReference.id,
                    //'precioVenta': precio,
                    'foto': "prueba",
                    'id': "987",
                    'sucursal': sucursal,
                    //'nombreProducto': nombreProducto,
                    //'foto': foto,
                    'repa': 'Nadie',
                    'miembrodesde': DateFormat("yyyy-MM-dd").format(now),
                  });

                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  await preferences.remove('prueba6');
                  await preferences.remove('nombrecliente');
                  await preferences.remove('servicio');
                  await preferences.remove('totalProducto');


                });

                //BLOQUE DE CODIGO PARA IGUALAR A CERO LA NOTIFICACION
                QuerySnapshot _myDocE = await FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna').where('folio', isEqualTo: _myDocCount.length+1).get();
                List<DocumentSnapshot> _myDocCountE = _myDocE.docs;
                //print('Weed: '+ _myDocCountE.length.toString() +1.toString());
                var total = _myDocCountE.length;
                print("Este:"+total.toString());
                FirebaseFirestore.instance.collection('Notificaciones').doc("Carrito"+correoPersonal.toString()).update({'notificacion': "0"});
                //comprasNotificacion(context);

                comprasNotificacion(context);

              },
            ),
          ],
        );
      },
    );
  }

  void terminarCompraTar (BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('¿Deseas finalizar tu compra?', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("No"),
              onPressed: () {

                Navigator.of(context).pop(); //Te regresa a la pantalla anterior

              },
            ),
            FlatButton(
              child: Text("Si"),
              onPressed: () async {

                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();

                //gps();
                final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

                QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Pedidos_Jimena').orderBy('folio').get();
                List<DocumentSnapshot> _myDocCount = _myDoc.docs;

                final collRef = FirebaseFirestore.instance.collection('Pedidos_Jimena');
                DocumentReference docReference = collRef.doc();

                var now = DateTime.now();

                final prefs4 = await SharedPreferences.getInstance();
                final servicio = prefs4.getString('servicio') ?? "";

                final FirebaseAuth auth = FirebaseAuth.instance;
                final User? user = auth.currentUser;
                final correoPersonal = user!.email;

                //print(position.latitude.toDouble());
                //print(position.longitude.toDouble());

                final prefs2 = await SharedPreferences.getInstance();
                final correoresta = prefs2.getString('correoresta') ?? "";


                //METODO THANOSCOLECCION PARA BORRAR TOODA UNA COLECCION CON UNA CONDICION Y CON UN BOTON
                //SOLO AUTENTIFICAR CORREO Y COLOCARLO AQUI
                FirebaseFirestore.instance.collection('Clientes_Registro').where('correo', isEqualTo: correoPersonal).get().then((snapshot) async {
                  for (DocumentSnapshot doc in snapshot.docs) {

                    //var prueba = doc['calle'];
                    var nombre = doc['nombre'];
                    var tel = doc['telefono'];

                    final prefs = await SharedPreferences.getInstance();
                    //prefs.setString('prueba6', prueba);
                    prefs.setString('nombrecliente', nombre);
                    prefs.setString('tel', tel);
                    //print(prueba);
                  }

                  final prefs5 = await SharedPreferences.getInstance();
                  final prueba = prefs5.getString('prueba6') ?? "";
                  final nombre = prefs5.getString('nombrecliente') ?? "";
                  //SharedPreferences paso #2
                  final totalreal = prefs5.getDouble('totalProducto') ?? "";
                  final sucursal = prefs4.getString('sucursal') ?? "";
                  final tel = prefs4.getString('tel') ?? "";

                  final FirebaseAuth auth = FirebaseAuth.instance;
                  final User? user = auth.currentUser;
                  final correoPersonal = user!.email;

                  final prefs7 = await SharedPreferences.getInstance();
                  final correoNegocio = prefs7.getString('correoNegocio') ?? "";

                  final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
                  //print(position.latitude.toDouble());
                  //print(position.longitude.toDouble());
                  var lat = position.latitude.toDouble();
                  var lon = position.longitude.toDouble();
                  print("Lat: "+lat.toString());
                  print("Lon"+lon.toString());

                  //PASAR POR PARAMETRO ESTA INFO..FLETE Y EMPRESA, NO JALA ASI CON SHARED..
                  final prefs2 = await SharedPreferences.getInstance();
                  final correoresta = prefs2.getString('correoresta') ?? "";
                  String tiempoo = prefs2.getString('tiempo') ?? "";
                  String empresa = prefs2.getString('empresa') ?? "";
                  double flete = prefs2.getDouble('flete') ?? 0;


                  DateTime now = DateTime.now();
                  String formattedDate = DateFormat('kk:mm:ss').format(now);

                  docReference.set({
                    'visto': 'no',
                    'empresa': widget.product.nombreProducto,
                    //'calle': widget.product.newid,
                    //'colonia': widget.product.direccion,
                    //'numext': widget.product.foto,
                    'flete': widget.product.latitud,
                    'tiempodeespera': tiempoo,
                    'hora': formattedDate,
                    'tel': tel,
                    'estadoc': widget.product.formadepago=="[A Domicilio]"?'adomi':'recoger',
                    'concepto': "Tarjeta de Debito",
                    'estadoh': 'sinhornear',
                    'correoNegocio': correoNegocio,
                    'latitud': lat.toDouble(),
                    'longitud': lon.toDouble(),
                    'estadoefectivo': 'contarjeta',
                    'estado3': widget.product.formadepago=="[A Domicilio]"?'PEDIDO A DOMICILIO':'PEDIDO A RECOGER',
                    'correopersonal': correoPersonal,
                    'totalNota': totalreal,
                    'nombrecliente': nombre,
                    'direccion': prueba,
                    'servicio': servicio,
                    'estado': 'sinpagar',
                    'estado2': 'pedidoEnEspera',
                    'folio': _myDocCount.length+1,
                    'newid': docReference.id,
                    //'precioVenta': precio,
                    'foto': "prueba",
                    'id': "987",
                    'sucursal': sucursal,
                    //'nombreProducto': nombreProducto,
                    //'foto': foto,
                    'repa': 'Nadie',
                    'miembrodesde': DateFormat("yyyy-MM-dd").format(now),
                  });

                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  await preferences.remove('prueba6');
                  await preferences.remove('nombrecliente');
                  await preferences.remove('servicio');
                  await preferences.remove('totalProducto');


                });

                //BLOQUE DE CODIGO PARA IGUALAR A CERO LA NOTIFICACION
                QuerySnapshot _myDocE = await FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna').where('folio', isEqualTo: _myDocCount.length+1).get();
                List<DocumentSnapshot> _myDocCountE = _myDocE.docs;
                //print('Weed: '+ _myDocCountE.length.toString() +1.toString());
                var total = _myDocCountE.length;
                print("Este:"+total.toString());
                FirebaseFirestore.instance.collection('Notificaciones').doc("Carrito"+correoPersonal.toString()).update({'notificacion': "0"});

                comprasNotificacion(context);

              },
            ),
          ],
        );
      },
    );
  }

  void borrar() async {
    final prefs4 = await SharedPreferences.getInstance();
    await prefs4.remove('empresa');
    await prefs4.remove('flete');
  }

  @override
  void dispose() {
    //borrarTipoDeServicio(context);
    borrar();
    // TODO: implement dispose
    comprasNotificaciones(context);
    comprasNotificacion(context);
    print("Salio y activo metodo");
    super.dispose();
  }

  void tiempo()async {

    final prefs2 = await SharedPreferences.getInstance();
    final correoresta = prefs2.getString('correoresta') ?? "";

    FirebaseFirestore.instance.collection('Tiempo').where('correoNegocio', isEqualTo: correoresta).snapshots().listen((data) async {
      data.docs.forEach((doc) async {
        var tiempo;
        tiempo = doc['tiempo'];

        print("tiempo "+tiempo);

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('tiempo', tiempo);


      }); //METODO THANOS FOR EACH

    });


  }

  void sha() async {
    final prefs2 = await SharedPreferences.getInstance();
    final correoresta = prefs2.getString('correoresta') ?? "";
    String tiempoo = prefs2.getString('tiempo') ?? "";
    String empresa = prefs2.getString('empresa') ?? "";
    double flete = prefs2.getDouble('flete') ?? 0;

  }

  @override
  void initState() {
    sha();
    // TODO: implement initState
    super.initState();
  }

  late List<String> tipodepago, pagopago;

  List<String> text = ["Recoger en establecimiento"];
  List<String> text2 = ["A Domicilio"];
  List<String> textefe = ["Efectivo"];
  List<String> texttar = ["Pago con tarjeta"];

  //CON ESTE WIDGET PUEDO HACER UNO PARA NOTIFICACIONES
  Widget efectivo (BuildContext context){
    return StreamBuilder<DocumentSnapshot<Object?>>(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Socios_Registro').doc(widget.product.tel).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data!.data() as Map<String, dynamic>;

            String prueba = userDocument["efectivo"];

            return
              prueba == "si"?
              InkWell(
                onTap: (){

                  checkServiceStatusEfectivo(context);

                },
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        //aqui
                        Row(
                          children: const <Widget>[
                            Icon(Icons.monetization_on, color: Colors.black,),
                            SizedBox(width: 10,),
                            Text('Efectivo', style: TextStyle(fontSize: 18),)
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios, size: 15, color: Colors.black,),
                      ],
                    ),
                  ),
                ),
              )
                  :
              Container();

          }
        }
    );
  }
  Widget tarjeta (BuildContext context){
    return StreamBuilder<DocumentSnapshot<Object?>>(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Socios_Registro').doc(widget.product.tel).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data!.data() as Map<String, dynamic>;

            String prueba = userDocument["tarjeta"];

            return
              prueba == "si"?
              InkWell(
                onTap: (){

                  checkServiceStatusTarjeta(context);

                },
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: const <Widget>[
                            Icon(Icons.credit_card, color: Colors.black,),
                            SizedBox(width: 10,),
                            Text('Solicitar terminal inalambrica', style: TextStyle(fontSize: 18),)
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios, size: 15, color: Colors.black,),
                      ],
                    ),
                  ),
                ),
              )
                  :
              Container();

          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff6DA08E),
        centerTitle: true,
        title: Text('Siento11 Colectivo', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20, right: 10, left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Text('¿Como quieres pagar?', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                        ],
                      ),
                      SizedBox(height: 20,),
                      efectivo(context),
                      tarjeta(context),
                    ],
                  ),
                )
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const <Widget>[
            ],
          ),
        ],
      ),
    );
  }
}