pragma solidity ^0.5.0;

contract TodoList {
    uint256 public taskCount = 0;

    struct Task {
        uint256 key;
        string name;
        bool complete;
        bool deleted;
    }

    mapping(uint256 => Task) public todos;

    event TaskCreated(string name, uint256 number);

    event TaskUpdated(string name, uint256 number, bool value);

    event TaskDeleted(uint256 number);

    constructor() public {
        create("First Task");
        create("Second Task");
        create("Third Task");
    }

    function create(string memory _name) public {
        todos[taskCount++] = Task(taskCount, _name, false, false);
        emit TaskCreated(_name, taskCount - 1);
    }

    function toggleComplete(uint256 _number) public {
        Task memory task = todos[_number];
        task.complete = !task.complete;
        todos[_number] = task;
        emit TaskUpdated(task.name, _number, task.complete);
    }

    function deleteTask(uint256 _number) public {
        Task memory task = todos[_number];
        task.deleted = true;
        todos[_number] = task;
        emit TaskDeleted(_number);
    }

    function updateTask(uint256 _number, string memory _name) public {
        Task memory task = todos[_number];
        task.name = _name;
        todos[_number] = task;
        emit TaskUpdated(task.name, _number, task.complete);
    }
}
