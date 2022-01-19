import 'dart:ui' as ui;
import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:websiento11/Clientes/comprar_ahora.dart';
import 'package:websiento11/Clientes/producto_detalle_zoom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:websiento11/Modelo/cajas_modelo.dart';
import 'package:websiento11/Modelo/nota_modelo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:websiento11/authentication.dart';
import 'package:toast/toast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class menu_cliente extends StatefulWidget {

  final String empresa, correoEmpresa, newid, colonia, calle, numero;
  final int entrada, salida;

  const menu_cliente(this.empresa, this.correoEmpresa, this.newid, this.colonia, this.calle, this.numero, this.entrada, this.salida,{Key? key}) : super(key: key);

  @override
  menu_clienteState createState() => menu_clienteState();
}

class menu_clienteState extends State<menu_cliente> {

  CollectionReference reflistaproduccion = FirebaseFirestore.instance.collection('Cajas');
  CollectionReference reflistadecarrito = FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna');
  CollectionReference reflistadeclientes = FirebaseFirestore.instance.collection('Clientes');
  CollectionReference reflistaextras = FirebaseFirestore.instance.collection('Extras');
  String? category, categorytalla, categorytacon;
  String? category2, category3;

  bool sesion = false;

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

  Future<void> promoNotificacion (BuildContext)async{
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Promociones').where('estado', isEqualTo: "sinver").get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    print("Esto quiero: "+_myDocCount.length.toString());

    QuerySnapshot _myDoc2 = await FirebaseFirestore.instance.collection('Promociones').where('estado', isEqualTo: "visto").get();
    List<DocumentSnapshot> _myDocCount2 = _myDoc2.docs;
    print("Esto quiero 2: "+_myDocCount2.length.toString());

    int total =   _myDocCount.length - _myDocCount2.length;
    FirebaseFirestore.instance.collection('Notificaciones').doc("Promos").set({'notificacion': total.toString()});

    print("Total: "+total.toString());
  }

  Future<int> comprasNotificacion (BuildContext context)async{

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;

    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Pedidos_Jimena').where('correopersonal', isEqualTo: correoPersonal).where('visto', isEqualTo: "no").get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    print("Esto quiero: "+_myDocCount.length.toString());

    int total =   _myDocCount.length;
    FirebaseFirestore.instance.collection('Notificaciones').doc("Compras"+correoPersonal.toString()).set({'notificacion': total.toString()});
    return total;
  }

  Widget notificacionesCarrito (BuildContext context){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;

    return StreamBuilder<DocumentSnapshot<Object?>>(
        stream: FirebaseFirestore.instance.collection('Notificaciones').doc("Carrito"+correoPersonal.toString()).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;


            return
              data['notificacion'] != "0"?

              Badge(
                position: BadgePosition(left: 30, bottom: 35),
                badgeColor: Colors.red[700],
                badgeContent: Text(data["notificacion"], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                child: FloatingActionButton(
                  onPressed: (){
                    _sheetCarrito(context);
                  },
                  backgroundColor: Color(0xff6DA08E),
                  child: Icon(Icons.add_shopping_cart, color: Colors.white,),
                ),
              )
                  :
              FloatingActionButton(
                onPressed: (){
                  _sheetCarrito(context);
                },
                backgroundColor: Color(0xff6DA08E),
                child: Icon(Icons.add_shopping_cart, color: Colors.white),
              );

          }
        }
    );
  }
  Widget notificacionesCarrito2 (BuildContext context){
    return FloatingActionButton(
      onPressed: (){
        _sheetCarrito(context);
      },
      backgroundColor: Color(0xff6DA08E),
      child: Icon(Icons.add_shopping_cart, color: Colors.white),
    );
  }

  int existencia = 0;

  void _borrarElemento (BuildContext context, String id, int cantidadaregresar, existencia, String newidproducto) async {
    var category;
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text('¿Borrar del carrito?', style: TextStyle(color: Colors.black)),
          actions: <Widget>[

            FlatButton(
              onPressed: (){

                Navigator.of(context).pop(); //Te regresa a la pantalla anterior

              },
              child: const Text('Cancelar'),
            ),
            // usually buttons at the bottom of the dialog
            // ignore: deprecated_member_use
            FlatButton(
              child: Text("Si"),
              onPressed: () async {

                int totale = existencia + cantidadaregresar;

                FirebaseFirestore.instance.collection('Cajas').doc(newidproducto).update({'existencia': totale});

                FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna').doc(id).delete();

                final FirebaseAuth auth = FirebaseAuth.instance;
                final User? user = auth.currentUser;
                final correoPersonal = user!.email;

                QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Pedidos_Jimena').orderBy('folio').get();
                List<DocumentSnapshot> _myDocCount = _myDoc.docs;

                QuerySnapshot _myDocE = await FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna').where('correocliente', isEqualTo: correoPersonal).where('folio', isEqualTo: _myDocCount.length+1).get();
                List<DocumentSnapshot> _myDocCountE = _myDocE.docs;
                //print('Weed: '+ _myDocCountE.length.toString() +1.toString());

                var total = _myDocCountE.length;

                FirebaseFirestore.instance.collection('Notificaciones').doc("Carrito"+correoPersonal.toString()).update({'notificacion': total.toString()});

                Navigator.of(context).pop(); //Te regresa a la pantalla anterior

              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _sheetCarrito(context) async {

    //BLOQUE DE CODIGO PARA OBTENER EL TOTAL

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;

    double total = 0;
    QuerySnapshot _myDoc2 = await FirebaseFirestore.instance.collection('Pedidos_Jimena').orderBy('folio').get();
    List<DocumentSnapshot> _myDocCount2 = _myDoc2.docs;

    FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna').where('correocliente', isEqualTo: correoPersonal ).where('folio', isEqualTo: _myDocCount2.length+1).snapshots().listen((data) async {
      data.docs.forEach((doc) async {
        //doc.reference.delete();
        //CREO QUE LA CLAVE ES MANDAR ESTEEste: TOTAL A PEDIDOS_INICIO
        final prefs4 = await SharedPreferences.getInstance();

        total = total + doc['totalProducto'];
        //total = total + doc['totalProducto'];
        print("Este total hay que hacerlo individual: "+total.toString());
        var fotocarrito = doc['foto'];
        //SharedPreferences paso #1
        final prefst = await SharedPreferences.getInstance();
        prefst.setDouble('totalProducto', total);
        prefst.setString('fotocarrito', fotocarrito);

        //IOSink sink = file.openWrite(mode: FileMode.writeOnlyAppend);

        //sink.add(utf8.encode(total.toString())); //Use newline as the delimiter
        //sink.writeln();
        //await sink.flush();
        //await sink.close();

      });
      //var now = new DateTime.now();
    });

    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Pedidos_Jimena').orderBy('folio').get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;

    //SharedPreferences paso #2
    final prefst = await SharedPreferences.getInstance();
    final totalreal = prefst.getDouble('totalProducto') ?? 0.0;

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Carrito de compra', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 20,),
                Container(
                  height: 30,
                  color: Colors.black12,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 15, left: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const <Widget>[
                            Text('Cantidad', style: TextStyle(fontSize:  15, fontWeight: FontWeight.bold),),
                            Text('Articulo', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                            Text('Total', style: TextStyle(fontSize:  15, fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child:StreamBuilder(
                    //Asi encontraremos los negocios por ciudad y sin problemas con la BD
                      stream: reflistadecarrito.where('correocliente', isEqualTo: correoPersonal).where("folio", isEqualTo: _myDocCount.length+1).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                        if (!snapshot.hasData) {
                          return Text("Loading..");
                        }
                        //reference.where("title", isEqualTo: 'UID').snapshots(),

                        else
                        {
                          return ListView(
                            children: snapshot.data!.docs.map((documents) {

                              //LAS VARIABLES QUE DELCARO AQUI HACEN EL BAD STATE!!!!!!!

                              return InkWell(
                                onTap: () async{

                                  print("ibai");
                                  //_sheetComanda2(context, costo,  descripcion,  nombreProducto, foto);


                                  //await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                  //AGREGAR EL TOTAL POARA PASARLO A LA SIGUIENTE PANTALLA
                                  //Carpitneria_Producto_Detalle(Cajas_Modelo(null, nombreProducto,fecha,folio,2,3,4,5,"","","e","f", newid, costoproducto))
                                  //),);

                                },
                                child: Card(
                                  child: Stack(
                                    children:[
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () async {

                                                  SharedPreferences preferences = await SharedPreferences.getInstance();
                                                  await preferences.remove('totalProducto');

                                                  Navigator.of(context).pop();

                                                  final String newid2 = documents["newid"];


                                                  print("ÄQUI PONER EXISTENCIA ACTUAL");

                                                  FirebaseFirestore.instance.collection('Cajas').where("nombreProducto", isEqualTo: documents["nombreProducto"]).snapshots().listen((data) async {
                                                    data.docs.forEach((doc) async {

                                                      int clave = doc['existencia'];

                                                      print("Existencia real "+clave.toString()+" Y cantidad a agregar "+documents["cantidad"].toString());

                                                      setState(() {
                                                        existencia = clave;
                                                      });
                                                    }); //METODO THANOS FOR EACH
                                                  });
                                                  _borrarElemento(context, newid2, documents["cantidad"], existencia, documents["newidproducto"]);

                                                },
                                                child: Icon(Icons.delete, color: Color(0xff6DA08E),),
                                              ),
                                              Text(documents["cantidad"].toString()),
                                              Column(
                                                  children: <Widget>[
                                                    Container(
                                                      width: 180,
                                                      child: Text(documents["nombreProducto"], style: TextStyle(fontSize: 15.0),),
                                                    ),
                                                    //Text(codigodebarra, style: TextStyle(fontSize: 12)),
                                                  ]
                                              ),
                                              Text("\$"+documents["totalProducto"].toString()),
                                              //Text(telefonoProveedor),

                                            ],
                                          ),
                                        ],
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
                ),
                Text('SUBTOTAL', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                Text(totalreal.toString(), style: TextStyle(fontSize: 25),),
                totalreal == 0.0?
                    Container()
                :
                Container(
                  child: SizedBox(
                    child: RaisedButton(
                      color: Color(0xff6DA08E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: Text('Pagar', style: TextStyle(color: Colors.white),),
                      onPressed: () async {

                        QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Pedidos_Jimena').orderBy('folio').get();
                        List<DocumentSnapshot> _myDocCount = _myDoc.docs;
                        int folio = _myDocCount.length;

                        final prefs4 = await SharedPreferences.getInstance();
                        final sucursal = prefs4.getString('sucursal') ?? "";
                        final servicio = prefs4.getString('servicio') ?? "";

                        await Navigator.push(context, MaterialPageRoute(builder: (context) => comprar_ahora(nota_modelo("", "", folio,0,"newid","Siento11 Colectivo", totalreal, "sucursal",0,0,servicio, "ventas.siento11@gmail.com",""))),);

                        print("Dr. House "+widget.empresa);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  void borrar(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('totalProducto');
    await preferences.remove('sucursal');
  }
  bool sesion2 = false;

  void correoPestana () async {

    final FirebaseAuth auth = FirebaseAuth.instance;
    if(FirebaseAuth.instance.currentUser?.email == null){
// not logged
      setState(() {
        sesion2 = false;
        print("Sin pestania $sesion");
      });

    } else {
// logged
      setState(() {
        sesion2 = true;
        print("Con pestania $sesion");
      });
    }
  }


  @override
  void initState() {
    correoPestana();
    print(widget.empresa);
    borrar(context);
    // TODO: implement initState
    //promoNotificacion(context);
    //comprasNotificacion(context);
    //comprasNotificacion(context);
    //notificacionesCarrito(context);
    super.initState();
  }


  FirebaseAuth auth = FirebaseAuth.instance;
  signOut() async {
    await auth.signOut();
  }

  @override
  void dispose() {
    //_borrarElemento(context);
    // TODO: implement dispose
    super.dispose();
  }

  CollectionReference reflistadeclientes1 = FirebaseFirestore.instance.collection('Clientes');

  bool ropa = true, zapatos = true, bolsas = true, filtroropa = false, filtrozap = false, filtrobolsa = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _cantidadDeProducto = TextEditingController();

  int _itemCount = 1;

  void _exitencia (BuildContext context) async {
    var category;
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text('La cantidad es mayor al inventario', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            FlatButton(
              onPressed: (){

                Navigator.of(context).pop(); //Te regresa a la pantalla anterior

              },
              child: const Text('Ok'),
            ),
            // usually buttons at the bottom of the dialog
            // ignore: deprecated_member_use
          ],
        );
      },
    );
  }

   TextEditingController _emailController = TextEditingController();
   TextEditingController _passwordController = TextEditingController();
  Future<void> inicioSesion() async {
    // marked async
    AuthenticationHelper()
        .signIn(email: _emailController.text, password: _passwordController.text)
        .then((result) {
      if (result == null) {

        Navigator.of(context).pop();

        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => home(cajas_modelo("","","",0,0,0,0,0,"","","","","",0))));
        Toast.show("¡Has iniciado sesion!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);

      } else {
        Toast.show("Contraseña incorrecta!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
      }
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

  void agregarACarrito(BuildContext context, String foto, String nombreProducto, double costo, String descripcion, String empresa, String categoriap, String newid, String codigo, int existencia) async {
    int totale = 0;

    //VA  ASER ESTE, HACERLO AL DESPERTAR, SUBIRLO RAPIDO Y COBRAR AL ALAN.
    totale = existencia - _itemCount;

    totale < 0?
    _exitencia(context)
        :
    FirebaseFirestore.instance.collection('Cajas').doc(newid).update({
      'existencia': totale,
    });

    setState(() {
      comprasNotificaciones(context);
      comprasNotificaciones2(context);
      notificacionesCarrito2(context);
      notificacionesCarrito(context);
    });

    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Pedidos_Jimena').orderBy('folio').get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;

    final collRef = FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna');
    DocumentReference docReference = collRef.doc();

    var now = new DateTime.now();

    //double precio = double.parse(_precio.text);

    double resultado = _itemCount * costo;

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user2 = auth.currentUser;
    final correoPersonal = user2!.email;

    totale < 0?
    _exitencia(context)
        :
    docReference.set({
      'costo': costo,
      'codigo': codigo,
      //'tipo': tipo,
      'correocliente': correoPersonal,
      'descripcion': descripcion,
      'totalProducto': resultado,
      'cantidad': _itemCount,
      'folio': _myDocCount.length+1,
      'newid': docReference.id,
      //'precioVenta': precio,
      'foto': foto,
      'id': "987",
      'nombreProducto': nombreProducto,
      'foto': foto,
      'miembrodesde': DateFormat("dd-MM-yyyy").format(now),
      'newidproducto': newid,
    });
    //countDocuments();
    //Navigator.of(context).pop();
    _cantidadDeProducto.clear();
    totale < 0?
    print("No hay tanto inventario")
        :
    Toast.show("¡Agregado exitosamente!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);

    Navigator.of(context).pop();

    //BLOQUE DE CODIGO PARA NOTIFICACION PARA COMPRAS EN CARRITO
    QuerySnapshot _myDocE = await FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna').where('correocliente', isEqualTo: correoPersonal).where('folio', isEqualTo: _myDocCount.length+1).get();
    List<DocumentSnapshot> _myDocCountE = _myDocE.docs;
    //print('Weed: '+ _myDocCountE.length.toString() +1.toString());
    var total = _myDocCountE.length;

    FirebaseFirestore.instance.collection('Notificaciones').doc("Carrito"+correoPersonal.toString()).update({
      'notificacion': total.toString(),
      'correo': correoPersonal,
    });

    //AQUI VA UPDATE DE LA EXISTENCIA Y LA LOGICA

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('totalProducto');

    _itemCount = 1;

  }

  //final String imageUrl = "https://www.elcarrocolombiano.com/wp-content/uploads/2019/01/20190122-MPM-ERELIS-AUTO-DEPORTIVO-MAS-BARATO-01.jpg";

  Widget hola (String foto){

    ui.platformViewRegistry.registerViewFactory(
      foto,
          (int viewId) => ImageElement()..src = foto,
    );
    return HtmlElementView(
      viewType: foto,
    );
  }

  Widget _buildAboutDialog(BuildContext context, String foto, String nombreProducto, double costo, String descripcion, String empresa, String categoriap, String newid, String codigo, int existencia) {
    return StatefulBuilder(
      builder: (BuildContext context, setState) =>  ListView(
        children: <Widget>[
          AlertDialog(
            title: Row(children:[Text(empresa, style:TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black))]),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.end,

              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {

                        await Navigator.push(context, MaterialPageRoute(builder: (context) => producto_detalle_zoom(cajas_modelo("", nombreProducto,"fecha",0,2,3,4,5,descripcion, empresa,foto,"f", newid, costo))),);

                        print("Precio: "+costo.toString());

                        ui.platformViewRegistry.registerViewFactory(
                          foto,
                              (int viewId) => ImageElement()..src = foto,
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: HtmlElementView(viewType: foto), //PONER A
                      ),
                    ),
                  ],
                ),
                SizedBox(height:10),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 200.0,
                          child: Text(
                            nombreProducto,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25.0),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(descripcion,style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Existencia "+existencia.toString()),
                      ],
                    ),
                    SizedBox(height:10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('\$$costo', style: TextStyle(fontSize: 25, color: Colors.red[300], fontStyle: FontStyle.italic),),
                      ],
                    ),
                    SizedBox(height:5),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //spinnerMedida(newid),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:[
                              InkWell(
                                onTap:(){

                                  setState(()=>_itemCount--);

                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text('-', style: TextStyle(fontSize: 25, color: Colors.white))
                                      //Text("ID"+folio.toString(), style: TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xff6DA08E)),
                                ),
                              ),
                              SizedBox(width:10),
                              Text(_itemCount.toString(), style: TextStyle(fontSize: 25, color: Colors.black),),
                              SizedBox(width:10),
                              InkWell(
                                onTap:(){

                                  setState(()=>_itemCount++);

                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text('+', style: TextStyle(fontSize: 25, color: Colors.white))
                                      //Text("ID"+folio.toString(), style: TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xff6DA08E)),
                                ),
                              ),                            ]
                        )
                      ],
                    ),
                  ],
                ),

                //MEDIDAS
                //AQUI HACER LA CONDICION DE SUBCATEGORIA PARA MOSTRAR MEDIDAS O NUMEROS O NADA
                //AL MOMENTO DE COBRAR
                //medidaNumero(context, newid),
                SizedBox(height: 20.0,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          child: SizedBox(
                            child: RaisedButton(
                              color: Color(0xff6DA08E),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              child: Text('Agregar a carrito', style: TextStyle(color: Colors.white),),
                              onPressed: () async {

                                final FirebaseAuth auth = FirebaseAuth.instance;

                                if(FirebaseAuth.instance.currentUser?.uid == null){
                                // not logged
                                  Alert(
                                      context: context,
                                      title: "Inicio de sesion",
                                      content: Column(
                                        children: <Widget>[
                                          TextFormField(
                                            controller: _emailController,
                                            decoration: InputDecoration(
                                              icon: Icon(Icons.account_circle, color: Color(0xff6DA08E)),
                                              labelText: 'Correo',
                                            ),
                                          ),
                                          TextFormField(
                                            controller: _passwordController,

                                            obscureText: true,
                                            decoration: InputDecoration(
                                              icon: Icon(Icons.lock, color: Color(0xff6DA08E)),
                                              labelText: 'Contrasena',
                                            ),
                                          ),
                                        ],
                                      ),
                                      buttons: [
                                        DialogButton(
                                          onPressed: () {

                                            initState();

                                            inicioSesion();

                                            setState(() {
                                              comprasNotificaciones(context);
                                              comprasNotificaciones2(context);
                                              sesion = true;
                                            });

                                          },
                                          child: Text(
                                            "Entrar",
                                            style: TextStyle(color: Colors.white, fontSize: 20),
                                          ),
                                          color: Color(0xff6DA08E),

                                        ),
                                        DialogButton(
                                          onPressed: () {

                                            Navigator.of(context).pushNamed('/registro');

                                          },
                                          child: Text(
                                            "Registrarme",
                                            style: TextStyle(color: Colors.white, fontSize: 20),
                                          ),
                                          color: Color(0xff6DA08E),
                                        )
                                      ]).show();
                                } else {
                              // logged
                                  agregarACarrito(context, foto, nombreProducto, costo, descripcion, empresa, categoriap, newid, codigo, existencia);
                                  print("Con pestania");

                                }

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


                  setState(() {

                    //medida = null;

                  });

                  Navigator.of(context).pop();
                },
                textColor: Colors.black,
                child: const Text('Salir'),
              ),
            ],
          ),
        ],
      ),
    );
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

                      //signOut();
                      //Navigator.of(context).pushNamed("/clientes_login");
                      Navigator.of(context).pushNamedAndRemoveUntil('/clientes_login', (route) => false);

                    },
                  ),
                ],
              );
            }
        );

        return value == true;
      },
      child: Scaffold(
        floatingActionButton:
        FirebaseAuth.instance.currentUser?.email == null?
        notificacionesCarrito2(context)
        :
        notificacionesCarrito(context),
          body: StreamBuilder(
            stream: reflistaproduccion.where('id', isEqualTo:  "978").orderBy('categoria', descending: false).orderBy('nombreProducto', descending: false).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if (!snapshot.hasData) {
                return Text("Loading..");
              }
              //reference.where("title", isEqualTo: 'UID').snapshots(),

              else
              {
                return ListView(
                  children: snapshot.data!.docs.map((documents) {

                    //LAS VARIABLES QUE DELCARO AQUI HACEN EL BAD STATE!!!!!!!

                    return
                      documents["existencia"] <= 0?
                          Container()
                      :
                      InkWell(
                      onTap: () async{

                        var foto = documents["foto"];
                        var newid = documents["newid"];

                        showDialog(context: context, builder: (BuildContext context) =>  _buildAboutDialog(context,  documents["foto"],  documents["nombreProducto"],  documents["costoProducto"],  documents["descripcion"],  "",  "",  documents["newid"],"", documents["existencia"]));

                        FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(newid).update({
                          'visto': 'si',
                          'estado': 'Recibido',
                        });

                      },
                      child: Card(
                        child: Row(
                          children:[
                            Row(
                                children:[
                                  Container(
                                    width: 200.0,
                                    height: 150.0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: HtmlElementView(viewType: documents['foto']), //PONER A
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left:20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(documents["nombreProducto"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.black45),),
                                              //height: 30,
                                              width: 100,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(documents["descripcion"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black26),),
                                              //height: 30,
                                              width: 100,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text("Existencia "+documents["existencia"].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black26),),
                                              //height: 30,
                                              width: 100,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              child: Text("\$"+documents["costoProducto"].toString(), style: TextStyle(color: Color(0xff6DA08E), fontSize: 25),),
                                              //height: 30,
                                              width: 100,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                ]
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            }
        ),
      ),
    );
  }
}

//ABRIR BAJAFOOD PARA IMPLEMENTAR BOTON DE CARRITO D COMPRASS Y CONTINUA CO EL PROCESO