//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:websiento11/admin_inicio.dart';
import 'package:websiento11/Clientes/clientes_login.dart';
import 'package:websiento11/Clientes/menu_cliente.dart';
import 'package:websiento11/Clientes/home.dart';
import 'package:websiento11/Clientes/lista_restaurantes.dart';
import 'package:websiento11/Clientes/registro.dart';
import 'package:websiento11/Modelo/cajas_modelo.dart';
import 'package:websiento11/Modelo/nota_modelo.dart';
import 'package:websiento11/olvidecontra.dart';

import 'Modelo/panel_pedido_modelo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  setPathUrlStrategy();
  // Initialize a new Firebase App instance
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  const MyApp({Key key}) : super(key: key);
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.black,
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder> {
        '/olvide_contra': (BuildContext context) => olvidecontra(),//

        '/clientes_login': (BuildContext context) => clientes_login(),
        '/registro': (BuildContext context) => registro(),
        '/home': (BuildContext context) => home(cajas_modelo("","","",0,0,0,0,0,"","","","","",0),0),
        '/lista_restaurantes': (BuildContext context) => lista_restaurantes(),

      },
      title: 'Siento11 Colectivo',
      theme: ThemeData(

      ),
      home:
      home(cajas_modelo("","","",0,0, 0, 0, 0, "", "", "", "", "", 0),0),
      //clientes_login(),
      //menu_cliente("","","","","","",0,0),
      // <--- App Clientes


    );
  }
}
