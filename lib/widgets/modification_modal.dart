//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../assets/contents/models/finished_cocom.dart';

class ModifyModal extends StatefulWidget {
  final FinishedCocom fCocom;

  const ModifyModal({
    super.key,
    required this.fCocom,
  });

  @override
  State<ModifyModal> createState() => _ModifyModalState();
}

class _ModifyModalState extends State<ModifyModal> {
  final _inputformaters = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp(r'[0-9 :-]')),
    FilteringTextInputFormatter.deny(RegExp(r'[+*/(){}{}]')),
  ];
  final _formKey = GlobalKey<FormState>();
  String currentStartDate = '';
  String _enteredStartDate = '';
  String _enteredStartTime = '';
  String _enteredEndDate = '';
  String _enteredEndTime = '';

  bool _isSending = false;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
        widget.fCocom.startHour = '$_enteredStartDate $_enteredStartTime';
        widget.fCocom.endHour = '$_enteredEndDate $_enteredEndTime';
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Form(
          key: _formKey,
          child: Container(
            height: double.maxFinite,
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
                child: Column(
              children: [
                const Text(
                  'Modificar',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  inputFormatters: _inputformaters,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    label: Text('Fecha de inicio'),
                  ),
                  initialValue: widget.fCocom.startHour.substring(0, 10),
                  validator: (value) {
                    try {
                      DateFormat("yyyy-MM-dd").parse(value!);
                      print(value);
                    } catch (e) {
                      return 'Fecha invalida';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _enteredStartDate = newValue!;
                  },
                ),
                TextFormField(
                  inputFormatters: _inputformaters,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    label: Text('Hora de inicio'),
                  ),
                  initialValue: widget.fCocom.startHour.substring(11),
                  validator: (value) {
                    try {
                      DateFormat("hh:mm:ss").parse(value!);
                    } catch (e) {
                      return 'hora invalida';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _enteredStartTime = newValue!;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  inputFormatters: _inputformaters,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    label: Text('Fecha al terminar'),
                  ),
                  initialValue: widget.fCocom.endHour.substring(0, 10),
                  validator: (value) {
                    try {
                      DateFormat("yyyy-MM-dd").parse(value!);
                      print(value);
                    } catch (e) {
                      return 'Fecha invalida';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _enteredEndDate = newValue!;
                  },
                ),
                TextFormField(
                  inputFormatters: _inputformaters,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    label: Text('Hora al terminar'),
                  ),
                  initialValue: widget.fCocom.endHour.substring(11),
                  validator: (value) {
                    try {
                      DateFormat("hh:mm:ss").parse(value!);
                    } catch (e) {
                      return 'hora invalida';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _enteredEndTime = newValue!;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _isSending ? null : _saveItem,
                      child: _isSending
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(),
                            )
                          : const Text('Modify'),
                    ),
                    TextButton(
                      onPressed: _isSending
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            )),
          ),
        );
      },
    );
  }
}
