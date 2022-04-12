import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:thor_devkit_dart/utils.dart';

class Contract {
  late Map contractMeta;

  Contract(this.contractMeta);

  static Contract fromJsonString(String jsonString) {
    return Contract(json.decode(jsonString));
  }

  ///get contract from json file located at [path]
  static Contract fromFilePath(String path) {
    //get file from path
    File data = File(path);
    //read file content as string
    String jsonString = data.readAsStringSync();

    return Contract(json.decode(jsonString));
  }

//TODO: frag reni about contrct format
  ///Get the smart contract Name or null
  String? getContractName() {
    //old style json
    if (contractMeta["contractName"] != null) {
      return contractMeta['contractName'];
    }

    //new style json

    if (contractMeta['metadata'] != null) {}
    var m = json.decode(contractMeta["metadata"]);

    if (m['settings'] != null && m['settings']['compilationTarget'] != null) {
      List keys = m["settings"]["compilationTarget"].keys.toList();

      return m["settings"]["compilationTarget"][keys[0]];
    }

    //if there is no name return null
    return null;
  }

  ///Get bytecode of this contract
  Uint8List getBytecode() {
    return hexToBytes(contractMeta['bytecode']);
  }

  ///Get list of ABIs of this contract
  List<Map> getAbis() {
    return contractMeta['abi'];
  }

  ///Get ABI by [name]. Throws exception if no abi with this name exists for this contract
  Map getAbi(String name) {
    var abis = getAbis();
    List<Map> temp = [];
    for (var item in abis) {
      if (item['name'] == name) {
        temp.add(item);
      }
    }
    //it should not be possible for multiple ABIs to have the same name
    assert(temp.length < 2);

    //throw exception if ABI with this name was not found
    if (temp.isEmpty) {
      throw Exception('ABI with name $name was not found');
    }
    return temp[0];
  }

  



}
