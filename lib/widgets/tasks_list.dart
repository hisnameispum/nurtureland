import 'package:flutter/material.dart';
import 'package:nurtureland/widgets/tasks_tile.dart';
import 'package:provider/provider.dart';
import 'package:nurtureland/models/task_data.dart';
import 'package:nurtureland/models/mypage.dart';

class TasksList extends StatefulWidget {
  final MyPage passedPage;
  TasksList(@required this.passedPage);

  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  MyPage receivedPage;
  int currentPage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    receivedPage = MyPage(widget.passedPage.getCurrentPage);
    currentPage = receivedPage.getCurrentPage;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            var task;
            if (currentPage == 0) {
              task = taskData.wealthTask[index];
            } else if (currentPage == 1) {
              task = taskData.wisdomTask[index];
            } else if (currentPage == 2) {
              task = taskData.loveTask[index];
            } else if (currentPage == 3) {
              task = taskData.healthTask[index];
            } else {
              task = taskData.happinessTask[index];
            }
            return Dismissible(
              background: Container(
                color: Colors.red,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        'Delete',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              key: Key(task.name),
              onDismissed: (direction) {
                // Remove the item from the data source.
                taskData.deleteTask(task);
              },
              child: TaskTile(
                taskTitle: task.name,
                isChecked: task.isDone,
                checkBoxCallback: (checkboxState) {
                  taskData.updateTask(task);
                },
              ),
            );
          },
          itemCount: taskData.taskCount(currentPage),
        );
      },
    );
  }
}
