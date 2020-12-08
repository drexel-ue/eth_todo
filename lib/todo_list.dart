import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/todo_list_model.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  late final TextEditingController _newTaskController;
  late final TextEditingController _updateTaskController;

  @override
  void initState() {
    _newTaskController = TextEditingController();
    _updateTaskController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _newTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TodoList'),
      ),
      body: Consumer<TodoListModel>(
        builder: (BuildContext context, TodoListModel model, _) {
          return model.isLoading
              ? Center(child: CircularProgressIndicator.adaptive())
              : Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: RefreshIndicator(
                        onRefresh: () async => model.getTodos(),
                        child: ListView.builder(
                          itemCount: model.todos.length,
                          itemBuilder: (BuildContext context, int index) => Dismissible(
                            key: Key(model.todos[index].toString()),
                            background: Container(
                              color: Colors.blue,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(Icons.edit, color: Colors.white),
                            ),
                            secondaryBackground: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              child: Icon(Icons.delete_forever, color: Colors.white),
                            ),
                            confirmDismiss: (DismissDirection direction) async => showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                final delete = direction == DismissDirection.endToStart;

                                return AlertDialog(
                                  title: Text(delete ? 'Delete Task?' : 'Update Task?'),
                                  content: delete
                                      ? Text('Are you sure?')
                                      : TextField(
                                          controller: _updateTaskController,
                                          maxLines: 4,
                                        ),
                                  actions: [
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                      child: Text('CANCEL'),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context, delete);
                                        if (!delete) model.updateTask(model.todos[index].key, _updateTaskController.text);
                                      },
                                      child: Text(delete ? 'DELETE' : 'UPDATE'),
                                    ),
                                  ],
                                );
                              },
                            ),
                            onDismissed: (DismissDirection direction) => model.deleteTask(model.todos[index].key),
                            child: CheckboxListTile(
                              value: model.todos[index].complete,
                              title: Text(model.todos[index].name),
                              onChanged: (_) => model.toggleComplete(model.todos[index].key),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: TextField(
                              controller: _newTaskController,
                            ),
                          ),
                          Expanded(
                            child: RaisedButton(
                              onPressed: () => model.addTask(_newTaskController.text).whenComplete(() => _newTaskController.clear()),
                              child: Text('ADD'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
