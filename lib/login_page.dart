import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}
enum FormType {
  login,
  register
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  String _email;
  String _password;

  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }else {
      return false;
    }
  }

  void moveToRegister(){
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin(){
    setState(() {
      _formType = FormType.login;
    });
  }
  void validateAndSubmit() async{
    if(validateAndSave()){
      try{
        if(_formType == FormType.login){
          FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
          print('Signed in : ${user.uid}');
        }else {
          FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
          print('Registered user : ${user.uid}');
        }

      }catch(e){
        print('Error: $e');
      }

    }
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter login demo'),
      ),
      body: new Container(
        padding: EdgeInsets.all(10.0),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildInput() + buildSubmitButton()
          ),
        ),
      ),
    );
  }
  List<Widget> buildInput() {
    return[
      new TextFormField(
        decoration: new InputDecoration( labelText: 'Email'),
        validator: (value)=> value.isEmpty ? 'Email can\'t be empty':null,
        onSaved: (value)=> _email =value,
      ),
      new TextFormField(
        decoration: new InputDecoration( labelText: 'Password'),
        validator: (value)=> value.isEmpty ? 'Password can\'t be empty':null,
        onSaved: (value)=> _password =value,
      ),
    ];
  }

  List<Widget> buildSubmitButton(){
    if(_formType == FormType.login){
      return [
        new RaisedButton(
          color: Colors.blue,
          child: new Text('Login',style: new TextStyle(fontSize: 20.0),),
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text('Create an Account',style: new TextStyle(fontSize: 20.0),),
          onPressed: moveToRegister,
        )
      ];
    }else {
      return [
        new RaisedButton(
          color: Colors.blue,
          child: new Text('Create An Account',style: new TextStyle(fontSize: 20.0),),
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text('Have an account? login',style: new TextStyle(fontSize: 20.0),),
          onPressed: moveToLogin,
        )
      ];
    }
  }
}