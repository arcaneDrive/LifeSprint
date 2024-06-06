import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

import '../../../../app/utils/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Boxicons.bxs_map,
                              color: Color(ColorsValue().secondary),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("Hello {{-------}}",
                            style: TextStyle(
                              color: Color(ColorsValue().h5),
                              fontSize: 14,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                              image: AssetImage("assets/images/avtar.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 64,
                ),
                Text(
                  "Emergency help \n Needed?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      color: Color(ColorsValue().h1),
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(400),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: InkWell(
                      splashColor: Colors.black54,
                      onTap: () {
                        _showSOSForm(context);
                      },
                      child: Ink.image(
                        image: const AssetImage('assets/images/sos_button.png'),
                        height: 205,
                        width: 205,
                        fit: BoxFit.cover,
                        child: const Center(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Press the button to send SOS report",
                  style: TextStyle(
                    color: Color(ColorsValue().h5),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "or",
                  style: TextStyle(
                    color: Color(ColorsValue().h5),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Emergency call",
                  style: TextStyle(
                    color: Color(ColorsValue().secondary),
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSOSForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            title: const Text('Send report'),
            content: SOSForm(),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Send report'),
                onPressed: () {
                  // Handle form submission
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  
}

class SOSForm extends StatefulWidget {
  @override
  _SOSFormState createState() => _SOSFormState();
}

class _SOSFormState extends State<SOSForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _casualtiesController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DropdownButtonFormField<String>(
              value: 'yes',
              decoration: const InputDecoration(labelText: 'Any casualties'),
              items: ['yes', 'no'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _casualtiesController.text = newValue!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an option';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the location';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
