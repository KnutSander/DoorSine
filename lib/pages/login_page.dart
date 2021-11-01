import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 01/11/2021

class LoginPage extends StatelessWidget{
  LoginPage({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Email'
                      ),
                      validator: (String? value){
                        if(value == null || value.isEmpty){
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Password'
                      ),
                      validator: (String? value){
                        if(value == null || value.isEmpty){
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () {
                              if(_formKey.currentState!.validate()){
                                //TODO: Log the person in
                              }
                            },
                            child: const Text('Log in')
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                //TODO: Open create new user page
                              },
                              child: const Text('Create account')
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  
}