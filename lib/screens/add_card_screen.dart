import 'package:flutter/material.dart';
import 'package:mentcare/screens/card_auth.dart';

class AddCard extends StatelessWidget {
  AddCard({Key? key}) : super(key: key);

  static const String routeName = 'AddCard';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Text('Add Card'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      child: Text(
                        'Card Number',
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.all(10),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Align(
                                child: Text('Expiration Date',
                                    ),
                                alignment: Alignment.centerLeft,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.all(10),
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Align(
                                child: Text('CCV',
                                    ),
                                alignment: Alignment.centerLeft,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.all(10),
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Align(
                      child: Text('Country',
                          ),
                      alignment: Alignment.centerLeft,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(10),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    )
                  ],
                )),
            SizedBox(
              height:60,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, CardAuth.routeName),
                child: const Text('Verify Card'),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25))),
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor),
                    foregroundColor: MaterialStateProperty.all(Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
