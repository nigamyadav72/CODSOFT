import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'task.dart';

class AddEditTaskPage extends StatefulWidget {
  final Task? task;

  AddEditTaskPage({this.task});

  @override
  _AddEditTaskPageState createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tittleController;
  late TextEditingController _descriptionController;

  String _priority = 'Medium';
  DateTime? _dueDate;
  bool isEditMode = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEditMode = widget.task != null;

    _tittleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _priority = widget.task?.priority ?? 'Medium';
    _dueDate = widget.task?.dueDate;
  }

  @override
  void dispose() {
    _tittleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      Task task = Task(
        id: isEditMode ? widget.task!.id : DateTime.now().toString(),
        title: _tittleController.text,
        description: _descriptionController.text,
        priority: _priority,
        dueDate: _dueDate,
        isCompleted: isEditMode ? widget.task!.isCompleted : false,
        createdAt: isEditMode ? widget.task!.createdAt : DateTime.now(),
      );
      Navigator.pop(context, task);
    }
  }

  
}
