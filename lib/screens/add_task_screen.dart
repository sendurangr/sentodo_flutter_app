import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentodo_app/models/task.dart';
import 'package:sentodo_app/services/app_utils.dart';

import '../providers/task_provider.dart';

class _ClearButton extends StatelessWidget {
  const _ClearButton({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => controller.clear(),
      );
}

class _DatePicker extends StatelessWidget {
  const _DatePicker({required this.onPressed});

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(Icons.calendar_today),
        onPressed: onPressed,
      );
}

enum Priority { low, medium, high }

class AddTaskScreen extends ConsumerStatefulWidget {
  final Task? task;

  const AddTaskScreen({super.key, this.task});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  DateTime _selectedDate = DateTime.now();
  Priority _selectedPriority = Priority.low;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _targetDateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _subtitleController.text = widget.task!.subtitle;
      _selectedDate = widget.task!.targetDate;
      _selectedPriority = Priority.values[widget.task!.priority];
      formatDate();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _targetDateController.dispose();
    super.dispose();
  }

  void formatDate() {
    _targetDateController.text = AppUtils.formatDateFull(_selectedDate);
  }

  bool isValidForm() {
    return _titleController.text.isNotEmpty &&
        _subtitleController.text.isNotEmpty &&
        _targetDateController.text.isNotEmpty;
  }

  void _addTask(BuildContext context) {
    if (!isValidForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields'),
        ),
      );
      return;
    }

    if (widget.task != null) {
      ref.read(provider).updateTask(
            Task(
              id: widget.task!.id,
              title: _titleController.text,
              isDone: false,
              subtitle: _subtitleController.text,
              targetDate: _selectedDate,
              createdDate: DateTime.now(),
              priority: _selectedPriority.index,
            ),
          );
    } else {
      ref.read(provider).addTask(
            Task(
              id: DateTime.now().toString(),
              title: _titleController.text,
              isDone: false,
              subtitle: _subtitleController.text,
              targetDate: _selectedDate,
              createdDate: DateTime.now(),
              priority: _selectedPriority.index,
            ),
          );
    }

    Navigator.of(context).pop();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        formatDate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  suffixIcon: _ClearButton(controller: _titleController),
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _subtitleController,
                minLines: 1,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  suffixIcon: _ClearButton(controller: _subtitleController),
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                readOnly: true,
                controller: _targetDateController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  suffixIcon: _DatePicker(onPressed: () => _pickDate(context)),
                  labelText: 'Target Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SegmentedButton<Priority>(
                segments: const <ButtonSegment<Priority>>[
                  ButtonSegment<Priority>(
                      value: Priority.low,
                      label: Text('Low'),
                      icon: Icon(Icons.hiking)),
                  ButtonSegment<Priority>(
                      value: Priority.medium,
                      label: Text('Medium'),
                      icon: Icon(Icons.directions_walk)),
                  ButtonSegment<Priority>(
                      value: Priority.high,
                      label: Text('High'),
                      icon: Icon(Icons.directions_run)),
                ],
                selected: <Priority>{_selectedPriority},
                onSelectionChanged: (Set<Priority> newSelection) {
                  setState(() {
                    _selectedPriority = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _addTask(context),
                  child: const Text('Add Task'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
