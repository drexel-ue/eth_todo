import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class TodoListModel extends ChangeNotifier {
  List<Task> todos = [];
  bool isLoading = true;
  static const String _rpcUrl = String.fromEnvironment('RPC_URL');
  static const String _wsUrl = String.fromEnvironment('WS_URL');
  static const String _privateKey = String.fromEnvironment('PRIVATE_KEY');
  late final Web3Client _client;
  late final String _abiCode;
  late final EthereumAddress _contractAddress;
  late final Credentials _credentials;
  late final EthereumAddress _ownAddress;
  late final DeployedContract _contract;
  late final ContractFunction _taskCount;
  late final ContractFunction _todos;
  late final ContractFunction _create;
  late final ContractFunction _toggleComplete;
  late final ContractFunction _deleteTask;
  late final ContractFunction _updateTask;
  late final ContractEvent _taskCreatedEvent;
  late final ContractEvent _taskUpdatedEvent;
  late final ContractEvent _taskDeletedEvent;

  TodoListModel() {
    init();
  }

  Future<void> init() async {
    _client = Web3Client(
      _rpcUrl,
      Client(),
      socketConnector: () => IOWebSocketChannel.connect(_wsUrl).cast<String>(),
    );

    await Future.wait([_getAbi(), _getCredentials()]);
  }

  Future<void> _getAbi() async {
    String abiStringFile = await rootBundle.loadString('src/abis/TodoList.json');

    final abiJson = jsonDecode(abiStringFile);

    _abiCode = jsonEncode(abiJson['abi']);
    _contractAddress = EthereumAddress.fromHex(abiJson['networks']['5777']['address']);

    await _getDeployedContract();
  }

  Future<void> _getCredentials() async {
    _credentials = await _client.credentialsFromPrivateKey(_privateKey);
    _ownAddress = await _credentials.extractAddress();
  }

  Future<void> _getDeployedContract() async {
    _contract = DeployedContract(ContractAbi.fromJson(_abiCode, "TodoList"), _contractAddress);

    _taskCount = _contract.function('taskCount');
    _create = _contract.function('create');
    _todos = _contract.function('todos');
    _toggleComplete = _contract.function('toggleComplete');
    _deleteTask = _contract.function('deleteTask');
    _updateTask = _contract.function('updateTask');
    _taskCreatedEvent = _contract.event('TaskCreated');
    _taskUpdatedEvent = _contract.event('TaskUpdated');
    _taskDeletedEvent = _contract.event('TaskDeleted');

    await getTodos();
  }

  Future<void> getTodos() async {
    if (!isLoading) _setLoading();

    final response = await _client.call(contract: _contract, function: _taskCount, params: []);

    final BigInt totalTasks = response[0];

    todos.clear();
    for (int i = 0; i < totalTasks.toInt(); i++) {
      final temp = await _client.call(contract: _contract, function: _todos, params: [BigInt.from(i)]);

      if (!temp[3]) todos.add(Task(key: temp[0], name: temp[1], complete: temp[2]));
    }

    _unsetLoading();
  }

  Future<void> addTask(String _name) async {
    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(contract: _contract, function: _create, parameters: [_name]),
    );

    await getTodos();
  }

  Future<void> toggleComplete(BigInt _number) async {
    _setLoading();

    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(contract: _contract, function: _toggleComplete, parameters: [_number]),
    );

    await getTodos();
  }

  Future<void> deleteTask(BigInt _number) async {
    _setLoading();

    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(contract: _contract, function: _deleteTask, parameters: [_number]),
    );

    await getTodos();
  }

  Future<void> updateTask(BigInt _number, String _name) async {
    _setLoading();

    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(contract: _contract, function: _updateTask, parameters: [_number, _name]),
    );

    await getTodos();
  }

  _setLoading() {
    isLoading = true;
    notifyListeners();
  }

  _unsetLoading() {
    isLoading = false;
    notifyListeners();
  }
}

class Task {
  late final BigInt key;
  late final String name;
  late final bool complete;
  late final bool deleted;

  Task({required this.key, required this.name, required this.complete});

  @override
  String toString() => '''
  Task {
    key: $key
    name: $name
    complete: $complete
  }
  ''';
}
