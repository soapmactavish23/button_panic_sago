import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void _enviarLocalizacaoUsuario(){
    print("Localizacao");
  }

  _getFile() async{
    final prefs = await SharedPreferences.getInstance();
    String idCliente = prefs.getString("idCliente");
    return idCliente;
  }

  _lerArquivo() async{
    try{
      final String id = await _getFile();
      if(id == null){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      }
    }catch(e){
      return null;
    }
  }

  void _sair() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("idCliente");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    _lerArquivo();

    return Scaffold(
      backgroundColor: Color(0xff034579),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Panic Sago"),
        backgroundColor: Color(0xff03142f),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close, color: Colors.white,),
            onPressed: _sair,
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset("img/logo.png"),
              RaisedButton(
                child: Text(
                  "ALERTAR!",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white
                  ),
                ),
                color: Colors.red,
                padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                onPressed: _enviarLocalizacaoUsuario,
              )
            ],
          ),
        ),
      ),
    );
  }
}
