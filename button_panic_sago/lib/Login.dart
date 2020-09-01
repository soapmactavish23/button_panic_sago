import 'package:button_panic_sago/Cadastro.dart';
import 'package:button_panic_sago/Home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String idCliente;
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  _getFile() async{
    final prefs = await SharedPreferences.getInstance();
    idCliente = prefs.getString("idCliente");
    return idCliente;
  }

  _setFile(String id) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("idCliente", id);
  }

  _lerArquivo() async{
    try{
      final String id = await _getFile();
      if(id != null){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
      }
    }catch(e){
      return null;
    }
  }

  void _logar() async{
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if(email != "" && senha != ""){
      String url = "http://10.9.254.33/panicoSago/api/autentica_cliente.php?" +
          "login=" + email +
          "&password=" + senha;

      http.Response response = await http.get(url);
      Map<String, dynamic> retorno = json.decode(response.body);

      if(retorno['success'] != null){
        _setFile(retorno['idcliente'].toString());
        _showMyDialog("Sucesso" ,retorno['success'].toString());
        _lerArquivo();
      }else{
        _showMyDialog("Erro", retorno['error'].toString());
      }
    }else{
      _showMyDialog("Erro","Preencha todos os campos");
    }
  }

  Future<void> _showMyDialog(String titulo,String texto) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(texto),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _abrirCadastro(){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => Cadastro()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    _lerArquivo();
    return Scaffold(
      backgroundColor: Color(0xff034579),
      body: Container(
        padding: EdgeInsets.all(42),
        child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 32),
                    child: Image.asset("img/logo.png",),
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: "Digite seu Email"
                    ),
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white
                    ),
                    controller: _controllerEmail,
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Digite sua senha",
                    ),
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white
                    ),
                    controller: _controllerSenha,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(15),
                      onPressed: _logar,
                      child: Text(
                        "Entrar",
                        style: TextStyle(
                            fontSize: 20
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        onTap: _abrirCadastro,
                        child: Text(
                          "Não tem conta? Cadastre-se",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                  )
                ],
              ),
            ),
      ),
    );
  }
}


/*
Padding(
  padding: EdgeInsets.only(bottom: 32),
  child: Image.asset("img/logo.png"),
),
TextField(
  keyboardType: TextInputType.emailAddress,
  decoration: InputDecoration(
      labelText: "Digite seu Email"
  ),
  style: TextStyle(
      fontSize: 22,
      color: Colors.white
  ),
  controller: _controllerEmail,
),
TextField(
  obscureText: true,
  decoration: InputDecoration(
    labelText: "Digite sua senha",
  ),
  style: TextStyle(
      fontSize: 22,
      color: Colors.white
  ),
  controller: _controllerSenha,
),
Padding(
  padding: EdgeInsets.only(top: 10),
  child: RaisedButton(
    color: Colors.blue,
    textColor: Colors.white,
    padding: EdgeInsets.all(15),
    onPressed: _logar,
    child: Text(
      "Entrar",
      style: TextStyle(
          fontSize: 20
      ),
    ),
  ),
),
  Padding(
    padding: EdgeInsets.only(top: 10),
    child: GestureDetector(
      onTap: _abrirCadastro,
      child: Text(
        "Não tem conta? Cadastre-se",
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
  )
)
* */