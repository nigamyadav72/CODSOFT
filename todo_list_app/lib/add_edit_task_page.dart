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

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF7C6FDC),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F7FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: Text(
          isEditMode ? 'Edit Task' : 'New Task',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Task Title',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _tittleController,
                  decoration: InputDecoration(
                    hintText: 'Enter task title',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.edit, color: Color(0xFF7C6FDC)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a code';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),

                // description field
                Text(
                  'Description (Optional)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter task description',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 24),

                //priority selection
                Text(
                  'Priority',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    _buildPriorityChip('High', Colors.red),
                    SizedBox(width: 8),
                    _buildPriorityChip('Medium', Colors.orange),
                    SizedBox(width: 8),
                    _buildPriorityChip('Low', Colors.green),
                  ],
                ),
                SizedBox(height: 24),

                //Due Date
                Text(
                  'Due Date (Optional)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: _selectDueDate,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Color(0xFF7C6FDC)),
                        SizedBox(width: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityChip(String priority, Color color) {
    bool isSelected = _priority == priority;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _priority = priority;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : Colors.grey,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
