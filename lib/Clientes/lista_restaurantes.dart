import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:websiento11/Clientes/home.dart';
import 'package:websiento11/Modelo/cajas_modelo.dart';


class lista_restaurantes extends StatefulWidget {
  @override
  lista_restaurantesState createState() => lista_restaurantesState();
}

class lista_restaurantesState extends State<lista_restaurantes> {

  CollectionReference reflistadecarrito = FirebaseFirestore.instance.collection('Socios_Registro');

  Widget ejem (){
    Widget horizontalList1 = Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        height: 200.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Container(width: 160.0, color: Colors.red,),
            Container(width: 160.0, color: Colors.orange,),
            Container(width: 160.0, color: Colors.pink,),
            Container(width: 160.0, color: Colors.yellow,),
          ],
        )
    );
    return horizontalList1;
  }

  bool americana = false, italiana = false, sushi = false, mexicana = false, alitas = false, dish = false;


  var now = DateTime.now();
  FirebaseAuth auth = FirebaseAuth.instance;
  signOut() async {
    await auth.signOut();
  }

  DateTime startTime = DateTime(2018, 6, 23, 10, 30);
  DateTime endTime = DateTime(2018, 6, 23, 13, 00);

  DateTime currentTime = DateTime.now();

  DateTime current = DateTime.now();

  listaTodos(){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;
    return Expanded(
      child: StreamBuilder(
        //Asi encontraremos los negocios por ciudad y sin problemas con la BD
          stream: reflistadecarrito.where('id', isEqualTo: "123").snapshots(),
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

                    onTap: () async{

                      final prefs2 = await SharedPreferences.getInstance();
                      final correoresta = prefs2.getString('correoresta') ?? "";

                      //_sheetCarrito(context, foto, nombreProducto);
                      //   showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context, foto, nombreProducto, costo, descripcion, empresa, categoriap, newid, codigo),);
                      //_sheetComanda2(context, costo,  descripcion,  nombreProducto, foto);


                      //Navigator.of(context).pushNamed('/home');


                      await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correo"],documents["colonia"], documents["calle"], documents["empresa"], 0),0)
                      ),);


                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString('correoresta', documents["correo"]);
                      prefs.setString('empresa', documents["empresa"]);

                      final startTime = DateTime(2018, 6, 23, 10, 30);
                      final endTime = DateTime(2018, 6, 23, 13, 00);

                      final currentTime = DateTime.now();

                      if(currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {

                        print(currentTime);
                        print("hora");
                        // do something
                      }


                    },
                    child: Card(

                      elevation: 7.0,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom:60.0),
                            child: InkWell(
                              onTap: () async{

                                final prefs2 = await SharedPreferences.getInstance();
                                final correoresta = prefs2.getString('correoresta') ?? "";

                                //_sheetCarrito(context, foto, nombreProducto);
                                //   showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context, foto, nombreProducto, costo, descripcion, empresa, categoriap, newid, codigo),);
                                //_sheetComanda2(context, costo,  descripcion,  nombreProducto, foto);


                                //Navigator.of(context).pushNamed('/home');


                                await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                    home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correo"],documents["colonia"], documents["calle"], documents["empresa"], 0),0)
                                ),);


                                final prefs = await SharedPreferences.getInstance();
                                prefs.setString('correoresta', documents["correo"]);
                                prefs.setString('empresa', documents["empresa"]);

                                final startTime = DateTime(2018, 6, 23, 10, 30);
                                final endTime = DateTime(2018, 6, 23, 13, 00);

                                final currentTime = DateTime.now();

                                if(currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {

                                  print(currentTime);
                                  print("hora");
                                  // do something
                                }


                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Container(
                                  height: 250.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(documents["foto"]),
                                    ),
                                    //borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //Container(color: Colors.black12,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(documents["empresa"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.black45),),
                                      //height: 30,
                                      width: 200,
                                    ),
                                    //SizedBox(width: 5,),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      child:
                                      documents["negocio"] =="cerrado"?
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Color(0xff6DA08E)),)
                                          :
                                      current.hour >= documents["entrada"] && current.hour < documents["salida"]?
                                      Text("ABIERTO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.green[800]),)
                                          :
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Color(0xff6DA08E)),),
                                      width: 200,
                                    ),
                                    Container(
                                      child:
                                      documents["minutosSalida"] == null?
                                      Text(documents["entrada"].toString()+":00 a "+documents["minutosSalida"].toString()+":00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),)
                                          :
                                      Text(documents["entrada"].toString()+":00 a "+documents["salida"].toString()+":"+documents["minutosSalida"].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),),

                                      //height: 30,
                                      width: 100,
                                    ),
                                  ],
                                ),
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
    );
  }
  listaMariscos(){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;
    return Expanded(
      child: StreamBuilder(
        //Asi encontraremos los negocios por ciudad y sin problemas con la BD
          stream: reflistadecarrito.where('categoria', isEqualTo: "Mariscos").snapshots(),
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

                    onTap: () async{

                      final prefs2 = await SharedPreferences.getInstance();
                      final correoresta = prefs2.getString('correoresta') ?? "";

                      //_sheetCarrito(context, foto, nombreProducto);
                      //   showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context, foto, nombreProducto, costo, descripcion, empresa, categoriap, newid, codigo),);
                      //_sheetComanda2(context, costo,  descripcion,  nombreProducto, foto);


                      //Navigator.of(context).pushNamed('/home');


                      await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correo"],documents["colonia"], documents["calle"], documents["empresa"], 0),0)
                      ),);


                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString('correoresta', documents["correo"]);
                      prefs.setString('empresa', documents["empresa"]);

                      final startTime = DateTime(2018, 6, 23, 10, 30);
                      final endTime = DateTime(2018, 6, 23, 13, 00);

                      final currentTime = DateTime.now();

                      if(currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {

                        print(currentTime);
                        print("hora");
                        // do something
                      }


                    },
                    child: Card(

                      elevation: 7.0,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom:60.0),
                            child: InkWell(
                              onTap: () async{

                                //_sheetCarrito(context, foto, nombreProducto);
                                //   showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context, foto, nombreProducto, costo, descripcion, empresa, categoriap, newid, codigo),);
                                //_sheetComanda2(context, costo,  descripcion,  nombreProducto, foto);

                                final prefs = await SharedPreferences.getInstance();
                                prefs.setString('correoresta', documents["correoRestaurante"]);
                                prefs.setString('empresa', documents["empresa"]);

                                await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                    home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correoRestaurante"],documents["colonia"], documents["calle"], documents["newid"], 0),0)
                                ),);
                                //await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                //AGREGAR EL TOTAL POARA PASARLO A LA SIGUIENTE PANTALLA
                                //Carpitneria_Producto_Detalle(Cajas_Modelo(null, nombreProducto,fecha,folio,2,3,4,5,"","","e","f", newid, costoproducto))
                                //),);



                                final startTime = DateTime(2018, 6, 23, 10, 30);
                                final endTime = DateTime(2018, 6, 23, 13, 00);

                                final currentTime = DateTime.now();

                                if(currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {

                                  print(currentTime);
                                  print("hora");
                                  // do something
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Container(
                                  height: 350.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(documents["foto"]),
                                    ),
                                    //borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //Container(color: Colors.black12,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(documents["empresa"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.black45),),
                                      //height: 30,
                                      width: 300,
                                    ),
                                    //SizedBox(width: 5,),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      child:
                                      documents["negocio"] =="cerrado"?
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Color(0xff6DA08E)),)
                                          :
                                      current.hour >= documents["entrada"] && current.hour < documents["salida"]?
                                      Text("ABIERTO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.green[800]),)
                                          :
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Color(0xff6DA08E)),),
                                      width: 200,
                                    ),
                                    Container(
                                      child:
                                      documents["minutosSalida"] == null?
                                      Text(documents["entrada"].toString()+":00 a "+documents["minutosSalida"].toString()+":00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),)
                                          :
                                      Text(documents["entrada"].toString()+":00 a "+documents["salida"].toString()+":"+documents["minutosSalida"].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),),

                                      //height: 30,
                                      width: 100,
                                    ),
                                  ],
                                ),
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
    );
  }
  listaAmericana(){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;
    return Expanded(
      child: StreamBuilder(
        //Asi encontraremos los negocios por ciudad y sin problemas con la BD
          stream: reflistadecarrito.where('categoria', isEqualTo: "Americana").snapshots(),
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

                    onTap: () async{

                      final prefs2 = await SharedPreferences.getInstance();
                      final correoresta = prefs2.getString('correoresta') ?? "";

                      //_sheetCarrito(context, foto, nombreProducto);
                      //   showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context, foto, nombreProducto, costo, descripcion, empresa, categoriap, newid, codigo),);
                      //_sheetComanda2(context, costo,  descripcion,  nombreProducto, foto);


                      //Navigator.of(context).pushNamed('/home');


                      await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correo"],documents["colonia"], documents["calle"], documents["empresa"], 0),0)
                      ),);


                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString('correoresta', documents["correo"]);
                      prefs.setString('empresa', documents["empresa"]);

                      final startTime = DateTime(2018, 6, 23, 10, 30);
                      final endTime = DateTime(2018, 6, 23, 13, 00);

                      final currentTime = DateTime.now();

                      if(currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {

                        print(currentTime);
                        print("hora");
                        // do something
                      }


                    },
                    child: Card(

                      elevation: 7.0,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom:60.0),
                            child: InkWell(
                              onTap: () async{

                                //_sheetCarrito(context, foto, nombreProducto);
                                //   showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context, foto, nombreProducto, costo, descripcion, empresa, categoriap, newid, codigo),);
                                //_sheetComanda2(context, costo,  descripcion,  nombreProducto, foto);

                                final prefs = await SharedPreferences.getInstance();
                                prefs.setString('correoresta', documents["correoRestaurante"]);
                                prefs.setString('empresa', documents["empresa"]);

                                await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                    home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correoRestaurante"],documents["colonia"], documents["calle"], documents["newid"], 0),0)
                                ),);
                                //await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                //AGREGAR EL TOTAL POARA PASARLO A LA SIGUIENTE PANTALLA
                                //Carpitneria_Producto_Detalle(Cajas_Modelo(null, nombreProducto,fecha,folio,2,3,4,5,"","","e","f", newid, costoproducto))
                                //),);



                                final startTime = DateTime(2018, 6, 23, 10, 30);
                                final endTime = DateTime(2018, 6, 23, 13, 00);

                                final currentTime = DateTime.now();

                                if(currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {

                                  print(currentTime);
                                  print("hora");
                                  // do something
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Container(
                                  height: 350.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(documents["foto"]),
                                    ),
                                    //borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //Container(color: Colors.black12,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(documents["empresa"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.black45),),
                                      //height: 30,
                                      width: 300,
                                    ),
                                    //SizedBox(width: 5,),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      child:
                                      documents["negocio"] =="cerrado"?
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Color(0xff6DA08E)),)
                                          :
                                      current.hour >= documents["entrada"] && current.hour < documents["salida"]?
                                      Text("ABIERTO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.green[800]),)
                                          :
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Color(0xff6DA08E)),),
                                      width: 200,
                                    ),
                                    Container(
                                      child:
                                      documents["minutosSalida"] == null?
                                      Text(documents["entrada"].toString()+":00 a "+documents["minutosSalida"].toString()+":00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),)
                                          :
                                      Text(documents["entrada"].toString()+":00 a "+documents["salida"].toString()+":"+documents["minutosSalida"].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),),

                                      //height: 30,
                                      width: 100,
                                    ),
                                  ],
                                ),
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
    );
  }
  listaItaliana(){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;
    return Expanded(
      child: StreamBuilder(
        //Asi encontraremos los negocios por ciudad y sin problemas con la BD
          stream: reflistadecarrito.where('categoria', isEqualTo: "Italiana").snapshots(),
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

                    onTap: () async{

                      final prefs2 = await SharedPreferences.getInstance();
                      final correoresta = prefs2.getString('correoresta') ?? "";

                      //_sheetCarrito(context, foto, nombreProducto);
                      //   showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context, foto, nombreProducto, costo, descripcion, empresa, categoriap, newid, codigo),);
                      //_sheetComanda2(context, costo,  descripcion,  nombreProducto, foto);


                      //Navigator.of(context).pushNamed('/home');


                      await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correo"],documents["colonia"], documents["calle"], documents["empresa"], 0),0)
                      ),);


                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString('correoresta', documents["correo"]);
                      prefs.setString('empresa', documents["empresa"]);

                      final startTime = DateTime(2018, 6, 23, 10, 30);
                      final endTime = DateTime(2018, 6, 23, 13, 00);

                      final currentTime = DateTime.now();

                      if(currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {

                        print(currentTime);
                        print("hora");
                        // do something
                      }


                    },
                    child: Card(

                      elevation: 7.0,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom:60.0),
                            child: InkWell(
                              onTap: () async{

                                //_sheetCarrito(context, foto, nombreProducto);
                                //   showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context, foto, nombreProducto, costo, descripcion, empresa, categoriap, newid, codigo),);
                                //_sheetComanda2(context, costo,  descripcion,  nombreProducto, foto);

                                final prefs = await SharedPreferences.getInstance();
                                prefs.setString('correoresta', documents["correoRestaurante"]);
                                prefs.setString('empresa', documents["empresa"]);

                                await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                    home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correoRestaurante"],documents["colonia"], documents["calle"], documents["newid"], 0),0)
                                ),);
                                //await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                //AGREGAR EL TOTAL POARA PASARLO A LA SIGUIENTE PANTALLA
                                //Carpitneria_Producto_Detalle(Cajas_Modelo(null, nombreProducto,fecha,folio,2,3,4,5,"","","e","f", newid, costoproducto))
                                //),);



                                final startTime = DateTime(2018, 6, 23, 10, 30);
                                final endTime = DateTime(2018, 6, 23, 13, 00);

                                final currentTime = DateTime.now();

                                if(currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {

                                  print(currentTime);
                                  print("hora");
                                  // do something
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Container(
                                  height: 350.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(documents["foto"]),
                                    ),
                                    //borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //Container(color: Colors.black12,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(documents["empresa"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.black45),),
                                      //height: 30,
                                      width: 300,
                                    ),
                                    //SizedBox(width: 5,),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      child:
                                      documents["negocio"] =="cerrado"?
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Color(0xff6DA08E)),)
                                          :
                                      current.hour >= documents["entrada"] && current.hour < documents["salida"]?
                                      Text("ABIERTO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.green[800]),)
                                          :
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Color(0xff6DA08E)),),
                                      width: 200,
                                    ),
                                    Container(
                                      child:
                                      documents["minutosSalida"] == null?
                                      Text(documents["entrada"].toString()+":00 a "+documents["minutosSalida"].toString()+":00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),)
                                          :
                                      Text(documents["entrada"].toString()+":00 a "+documents["salida"].toString()+":"+documents["minutosSalida"].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),),

                                      //height: 30,
                                      width: 100,
                                    ),
                                  ],
                                ),
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
    );
  }
  listaSushi(){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;
    return Expanded(
      child: StreamBuilder(
        //Asi encontraremos los negocios por ciudad y sin problemas con la BD
          stream: reflistadecarrito.where('categoria', isEqualTo: "Sushi").snapshots(),
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

                    onTap: () async{

                      final prefs2 = await SharedPreferences.getInstance();
                      final correoresta = prefs2.getString('correoresta') ?? "";

                      //_sheetCarrito(context, foto, nombreProducto);
                      //   showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context, foto, nombreProducto, costo, descripcion, empresa, categoriap, newid, codigo),);
                      //_sheetComanda2(context, costo,  descripcion,  nombreProducto, foto);


                      //Navigator.of(context).pushNamed('/home');


                      await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correo"],documents["colonia"], documents["calle"], documents["empresa"], 0),0)
                      ),);


                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString('correoresta', documents["correo"]);
                      prefs.setString('empresa', documents["empresa"]);

                      final startTime = DateTime(2018, 6, 23, 10, 30);
                      final endTime = DateTime(2018, 6, 23, 13, 00);

                      final currentTime = DateTime.now();

                      if(currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {

                        print(currentTime);
                        print("hora");
                        // do something
                      }


                    },
                    child: Card(

                      elevation: 7.0,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom:60.0),
                            child: InkWell(
                              onTap: () async{

                                //_sheetCarrito(context, foto, nombreProducto);
                                //   showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context, foto, nombreProducto, costo, descripcion, empresa, categoriap, newid, codigo),);
                                //_sheetComanda2(context, costo,  descripcion,  nombreProducto, foto);

                                final prefs = await SharedPreferences.getInstance();
                                prefs.setString('correoresta', documents["correoRestaurante"]);
                                prefs.setString('empresa', documents["empresa"]);

                                await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                    home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correoRestaurante"],documents["colonia"], documents["calle"], documents["newid"], 0),0)
                                ),);
                                //await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                //AGREGAR EL TOTAL POARA PASARLO A LA SIGUIENTE PANTALLA
                                //Carpitneria_Producto_Detalle(Cajas_Modelo(null, nombreProducto,fecha,folio,2,3,4,5,"","","e","f", newid, costoproducto))
                                //),);



                                final startTime = DateTime(2018, 6, 23, 10, 30);
                                final endTime = DateTime(2018, 6, 23, 13, 00);

                                final currentTime = DateTime.now();

                                if(currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {

                                  print(currentTime);
                                  print("hora");
                                  // do something
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Container(
                                  height: 350.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(documents["foto"]),
                                    ),
                                    //borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //Container(color: Colors.black12,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(documents["empresa"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.black45),),
                                      //height: 30,
                                      width: 300,
                                    ),
                                    //SizedBox(width: 5,),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      child:
                                      documents["negocio"] =="cerrado"?
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Color(0xff6DA08E)),)
                                          :
                                      current.hour >= documents["entrada"] && current.hour < documents["salida"]?
                                      Text("ABIERTO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.green[800]),)
                                          :
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Color(0xff6DA08E)),),
                                      width: 200,
                                    ),
                                    Container(
                                      child:
                                      documents["minutosSalida"] == null?
                                      Text(documents["entrada"].toString()+":00 a "+documents["minutosSalida"].toString()+":00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),)
                                          :
                                      Text(documents["entrada"].toString()+":00 a "+documents["salida"].toString()+":"+documents["minutosSalida"].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),),

                                      //height: 30,
                                      width: 100,
                                    ),
                                  ],
                                ),
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
    );
  }
  listaMex(){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;
    return Expanded(
      child: StreamBuilder(
        //Asi encontraremos los negocios por ciudad y sin problemas con la BD
          stream: reflistadecarrito.where('categoria', isEqualTo: "Mexicana").snapshots(),
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

                    onTap: () async{

                      final prefs2 = await SharedPreferences.getInstance();
                      final correoresta = prefs2.getString('correoresta') ?? "";

                      //_sheetCarrito(context, foto, nombreProducto);
                      //   showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context, foto, nombreProducto, costo, descripcion, empresa, categoriap, newid, codigo),);
                      //_sheetComanda2(context, costo,  descripcion,  nombreProducto, foto);


                      //Navigator.of(context).pushNamed('/home');


                      await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correo"],documents["colonia"], documents["calle"], documents["empresa"], 0),0)
                      ),);


                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString('correoresta', documents["correo"]);
                      prefs.setString('empresa', documents["empresa"]);

                      final startTime = DateTime(2018, 6, 23, 10, 30);
                      final endTime = DateTime(2018, 6, 23, 13, 00);

                      final currentTime = DateTime.now();

                      if(currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {

                        print(currentTime);
                        print("hora");
                        // do something
                      }


                    },
                    child: Card(

                      elevation: 7.0,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom:60.0),
                            child: InkWell(
                              onTap: () async{

                                //_sheetCarrito(context, foto, nombreProducto);
                                //   showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context, foto, nombreProducto, costo, descripcion, empresa, categoriap, newid, codigo),);
                                //_sheetComanda2(context, costo,  descripcion,  nombreProducto, foto);

                                final prefs = await SharedPreferences.getInstance();
                                prefs.setString('correoresta', documents["correoRestaurante"]);
                                prefs.setString('empresa', documents["empresa"]);

                                await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                    home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correoRestaurante"],documents["colonia"], documents["calle"], documents["newid"], 0),0)
                                ),);
                                //await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                //AGREGAR EL TOTAL POARA PASARLO A LA SIGUIENTE PANTALLA
                                //Carpitneria_Producto_Detalle(Cajas_Modelo(null, nombreProducto,fecha,folio,2,3,4,5,"","","e","f", newid, costoproducto))
                                //),);



                                final startTime = DateTime(2018, 6, 23, 10, 30);
                                final endTime = DateTime(2018, 6, 23, 13, 00);

                                final currentTime = DateTime.now();

                                if(currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {

                                  print(currentTime);
                                  print("hora");
                                  // do something
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Container(
                                  height: 350.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(documents["foto"]),
                                    ),
                                    //borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //Container(color: Colors.black12,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(documents["empresa"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.black45),),
                                      //height: 30,
                                      width: 300,
                                    ),
                                    //SizedBox(width: 5,),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      child:
                                      documents["negocio"] =="cerrado"?
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Color(0xff6DA08E)),)
                                          :
                                      current.hour >= documents["entrada"] && current.hour < documents["salida"]?
                                      Text("ABIERTO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.green[800]),)
                                          :
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Color(0xff6DA08E)),),
                                      width: 200,
                                    ),
                                    Container(
                                      child:
                                      documents["minutosSalida"] == null?
                                      Text(documents["entrada"].toString()+":00 a "+documents["minutosSalida"].toString()+":00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),)
                                          :
                                      Text(documents["entrada"].toString()+":00 a "+documents["salida"].toString()+":"+documents["minutosSalida"].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),),

                                      //height: 30,
                                      width: 100,
                                    ),
                                  ],
                                ),
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
    );
  }
  listaChina(){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;
    return Expanded(
      child: StreamBuilder(
        //Asi encontraremos los negocios por ciudad y sin problemas con la BD
          stream: reflistadecarrito.where('categoria', isEqualTo: "China").snapshots(),
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

                    onTap: () async{

                      final prefs2 = await SharedPreferences.getInstance();
                      final correoresta = prefs2.getString('correoresta') ?? "";

                      //_sheetCarrito(context, foto, nombreProducto);
                      //   showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context, foto, nombreProducto, costo, descripcion, empresa, categoriap, newid, codigo),);
                      //_sheetComanda2(context, costo,  descripcion,  nombreProducto, foto);


                      //Navigator.of(context).pushNamed('/home');


                      await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correo"],documents["colonia"], documents["calle"], documents["empresa"], 0),0)
                      ),);


                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString('correoresta', documents["correo"]);
                      prefs.setString('empresa', documents["empresa"]);

                      final startTime = DateTime(2018, 6, 23, 10, 30);
                      final endTime = DateTime(2018, 6, 23, 13, 00);

                      final currentTime = DateTime.now();

                      if(currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {

                        print(currentTime);
                        print("hora");
                        // do something
                      }


                    },
                    child: Card(

                      elevation: 7.0,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom:60.0),
                            child: InkWell(
                              onTap: () async{

                                //_sheetCarrito(context, foto, nombreProducto);
                                //   showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context, foto, nombreProducto, costo, descripcion, empresa, categoriap, newid, codigo),);
                                //_sheetComanda2(context, costo,  descripcion,  nombreProducto, foto);

                                final prefs = await SharedPreferences.getInstance();
                                prefs.setString('correoresta', documents["correoRestaurante"]);
                                prefs.setString('empresa', documents["empresa"]);

                                await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                    home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correoRestaurante"],documents["colonia"], documents["calle"], documents["newid"], 0),0)
                                ),);
                                //await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                //AGREGAR EL TOTAL POARA PASARLO A LA SIGUIENTE PANTALLA
                                //Carpitneria_Producto_Detalle(Cajas_Modelo(null, nombreProducto,fecha,folio,2,3,4,5,"","","e","f", newid, costoproducto))
                                //),);



                                final startTime = DateTime(2018, 6, 23, 10, 30);
                                final endTime = DateTime(2018, 6, 23, 13, 00);

                                final currentTime = DateTime.now();

                                if(currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {

                                  print(currentTime);
                                  print("hora");
                                  // do something
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Container(
                                  height: 350.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(documents["foto"]),
                                    ),
                                    //borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //Container(color: Colors.black12,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(documents["empresa"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.black45),),
                                      //height: 30,
                                      width: 300,
                                    ),
                                    //SizedBox(width: 5,),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      child:
                                      documents["negocio"] =="cerrado"?
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.red[800]),)
                                          :
                                      current.hour >= documents["entrada"] && current.hour < documents["salida"]?
                                      Text("ABIERTO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.green[800]),)
                                          :
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.red[800]),),
                                      width: 200,
                                    ),
                                    Container(
                                      child:
                                      documents["minutosSalida"] == null?
                                      Text(documents["entrada"].toString()+":00 a "+documents["minutosSalida"].toString()+":00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),)
                                          :
                                      Text(documents["entrada"].toString()+":00 a "+documents["salida"].toString()+":"+documents["minutosSalida"].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),),

                                      //height: 30,
                                      width: 100,
                                    ),
                                  ],
                                ),
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
    );
  }

  void cerrarSesion (BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('¿Deseas cerrar sesion', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("No"),
              onPressed: () {

                Navigator.of(context).pop(); //Te regresa a la pantalla anterior
                //Navigator.of(context).pop(); //Te regresa a la pantalla anterior

              },
            ),

            FlatButton(
              child: Text("Si"),
              onPressed: () {

                signOut();
                Navigator.of(context).pushNamedAndRemoveUntil('/clientes_login', (route) => false);
                //Navigator.of(context).pop(); //Te regresa a la pantalla anterior
                //Navigator.of(context).pop(); //Te regresa a la pantalla anterior

              },
            ),
          ],
        );
      },
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
                content: Text('¿Deseas cerrar sesión?'),
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
        appBar: AppBar(
          centerTitle: true,
          title: Stack(
            children: [
               Center(
                child: Text("Bienvenido a Siento11 Colectivo"),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                children:[
                  InkWell(
                    onTap:(){
                      cerrarSesion(context);
                      },
                    child: Icon(Icons.exit_to_app, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: Color(0xff6DA08E),
        ),
        body: Column(
          children: [
            listaTodos()
          ],
        ),
      ),
    );
  }
}