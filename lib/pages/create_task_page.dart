import 'package:dio_to_do_list/models/list_model.dart';
import 'package:dio_to_do_list/repository/list_repository.dart';
import 'package:flutter/material.dart';

class CreateTaskPage extends StatefulWidget {
  final ListModel? toDo;

  const CreateTaskPage({
    super.key,
    this.toDo,
  });

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    if (widget.toDo != null) {
      _titleController.text = widget.toDo!.title ?? '';
      _descriptionController.text = widget.toDo!.description ?? '';
    }

    // Add listener to the title controller
    _titleController.addListener(_updateButtonState);
    _updateButtonState(); // Ensure button state is initialized correctly
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _titleController.text.trim().isNotEmpty;
    });
  }

  Future<void> _saveTask() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O título é obrigatório')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.toDo != null) {
        // Edit existing task
        await ListRepository().editList(ListModel(
          objectId: widget.toDo!.objectId,
          title: title,
          description: description,
        ));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarefa editada com sucesso!')),
        );
      } else {
        // Create new task
        await ListRepository().postList(ListModel(
          title: title,
          description: description,
        ));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarefa criada com sucesso!')),
        );
      }
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar tarefa: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.removeListener(_updateButtonState); // Clean up listener
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.toDo != null ? 'Editar tarefa' : 'Criar tarefa'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título (obrigatório)'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição (opcional)'),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _isButtonEnabled ? _saveTask : null,
              child: Text(widget.toDo != null
                  ? 'Salvar alterações'
                  : 'Criar tarefa'),
            ),
          ],
        ),
      ),
    );
  }
}
