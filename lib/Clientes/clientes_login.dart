import 'dart:async';
import 'package:flutter/services.dart';
import 'package:websiento11/Clientes/home.dart';
import 'package:websiento11/Clientes/menu_cliente.dart';
import 'package:websiento11/Modelo/cajas_modelo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:websiento11/authentication.dart';
import 'package:websiento11/Clientes/lista_restaurantes.dart';
import 'package:toast/toast.dart';

class clientes_login extends StatefulWidget {

  var data;
  clientes_login({this.data});
  @override
  clientes_loginState createState() => clientes_loginState();
}

class clientes_loginState extends State<clientes_login> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  clientes_loginState();

  void getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.latitude.toDouble());
    print(position.longitude.toDouble());
  }

  Future<void> inicioSesion() async {
    // marked async
    AuthenticationHelper()
        .signIn(email: _emailController.text, password: _passwordController.text)
        .then((result) {
      if (result == null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => home(cajas_modelo("","","",0,0,0,0,0,"","","","","",0), 0)));
      } else {
        Toast.show("Contraseña incorrecta!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
      }
    });
  }


  @override
  void initState() {
    getCurrentLocation();
    // TODO: implement initState
    super.initState();
  }


  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> num ()async{
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Ventas').where('estado2', isEqualTo: "pedidofinalizado").get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    print("Esto quiero: "+_myDocCount.length.toString());

    FirebaseFirestore.instance.collection('VentaN').doc("123").update({'notificacion': _myDocCount.length.toString()});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('¿Deseas cerrar la App?'),
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

                      //signOut();
                      Navigator.of(context).pop(true);
                      //        Navigator.pop(context); calar esta
                    },
                  ),
                ],
              );
            }
        );

        return value == true;
      },
      child: Scaffold(


        appBar: AppBar(
            backgroundColor: Color(0xff6DA08E),
            centerTitle: true,
            title: const Text("Bienvenidos", style: TextStyle(color: Colors.white))
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                SizedBox(height: 20.0,),
                //Objeto de fondo blanco con login
                Stack(
                  children: <Widget>[
                    Container(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: OnelookLogo(),
                            ),
                            //SizedBox(height: 20.0,),
                            Padding(
                              padding: EdgeInsets.only(top: 10, right: 35.0, left: 35.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(50)
                                    ),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xff6DA08E),
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
                                    FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s"))
                                  ],
                                  controller: _emailController,
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
                            ),
                            SizedBox(height: 30.0,),
                            Padding(
                              padding: EdgeInsets.only(right: 30.0, left: 30.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(50)
                                    ),
                                    color: Colors.white,
                                    boxShadow:  [
                                      BoxShadow(
                                          color: Color(0xff6DA08E)                                 ,
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
                                  obscureText: true,
                                  controller: _passwordController,
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
                            ),
                            SizedBox(height: 30.0,),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 470, //Posicion de boton ENTRAR en la pantalla
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child:  OutlineButton(
                            onPressed: () async {

                              if (_formKey.currentState!.validate()) {
                                inicioSesion();
                              }
                              //num();

                            },
                            child: SizedBox(
                              width: 300,
                              child: Text('ENTRAR', textAlign: TextAlign.center,),
                            ),
                            borderSide: BorderSide(color: Colors.black,
                            ),
                            shape: StadiumBorder(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 405,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: (){

                                Navigator.of(context).pushNamed('/olvide_contra');

                              },
                              child: Text('¿Olvidaste tu contraseña?', style: TextStyle(color: Colors.black54),),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 460,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            //SignInButton(
                            //Buttons.Facebook,
                            //mini: true,
                            //onPressed: () {},
                            //),
                            //SignInButton(
                            //Buttons.Google,
                            //mini: true,
                            //onPressed: () {},
                            //),
                          ],
                        ),
                      ),
                    ),
                    //Forma para colocar otro widget a lado de otro
                    SizedBox(
                      height: 520, //Posicion de altura de texto
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center, //Aqui se indica la posicion en la pantalla
                        children: <Widget>[
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text('¿Aun no tienes cuenta?', style: TextStyle(color: Colors.black54)),
                          ),
                          //De esta manera separamos los dos textos en la misma fila
                          Padding(
                            padding: EdgeInsets.all(5.0),
                          ),
                          //Forma para colocar otro widget a lado de otro
                          Container(
                            child: Row(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.bottomRight, //Aqui se indica la posicion en la pantalla
                                  //Widget para hacer click en un texto
                                  child: InkWell( //Con este widget le podemos dar click a cualquier texto y crear una accion
                                    child: Text('REGISTRARME', style: TextStyle(color: Color(0xff6DA08E), fontSize: 20, fontWeight: FontWeight.bold),),
                                    onTap: (){

                                      Navigator.of(context).pushNamed('/registro');

                                      //_createNewProduct(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }





//Mejor practica para pasar a otra pantalla con POJO
//Metodo para crear registros en Firebase Database Real Time
//void _createNewProduct(BuildContext context)async {
//await Navigator.push(context,         //Se dejan espacios vacios, para cuando presionemos crear
//Nos lleve todoo en blanco, y el null es para la llave unica del PUSH
//MaterialPageRoute(builder: (context) => Socio_Registro(Socios_Modelo(null, '', '', ''))),
//);
//}


}

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

class OnelookLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    AssetImage assetImage = AssetImage('images/siento11.png');
    Image image = Image(image: assetImage, width: 200,);
    return Container(child: image,);
  }
}

class ArcClipper extends CustomClipper<Path> {
  ArcClipper(this.height);

  ///The height of the arc
  final double height;

  @override
  Path getClip(Size size) => _getBottomPath(size);

  Path _getBottomPath(Size size) {
    return Path()
      ..lineTo(0.0, size.height - height)
    //Adds a quadratic bezier segment that curves from the current point
    //to the given point (x2,y2), using the control point (x1,y1).
      ..quadraticBezierTo(
          size.width / 4, size.height, size.width / 2, size.height)
      ..quadraticBezierTo(
          size.width * 3 / 4, size.height, size.width, size.height - height)
      ..lineTo(size.width, 0.0)
      ..close();
  }

  @override
  bool shouldReclip(ArcClipper oldClipper) => height != oldClipper.height;
}