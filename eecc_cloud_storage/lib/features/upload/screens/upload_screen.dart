import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;
import '../../core/models/cloud_file.dart';
import '../../core/services/storage_orchestrator.dart';
import '../../core/utils/file_utils.dart';
import '../widgets/upload_progress_card.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _selectedFile;
  final Set<CloudProvider> _selectedProviders = {CloudProvider.googleDriveServiceAccount};

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.media);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  void _startUpload() {
    if (_selectedFile == null || _selectedProviders.isEmpty) return;
    
    final orchestrator = Provider.of<StorageOrchestrator>(context, listen: false);
    final fileName = FileUtils.generateArchiveName(
      date: DateTime.now(),
      type: 'Archive',
      originalExtension: p.extension(_selectedFile!.path)
    );
    
    orchestrator.uploadToSelected(
      _selectedFile!.path,
      fileName,
      FileUtils.getMimeType(_selectedFile!.path),
      _selectedFile!.lengthSync(),
      _selectedProviders.toList()
    );
  }

  @override
  Widget build(BuildContext context) {
    final orchestrator = Provider.watch<StorageOrchestrator>(context);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Uploader une archive')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.attach_file),
              label: const Text('Sélectionner un fichier'),
              onPressed: _pickFile,
            ),
            if (_selectedFile != null) ...[
              const SizedBox(height: 16),
              Text('Fichier : ${p.basename(_selectedFile!.path)}'),
              Text('Taille : ${FileUtils.formatFileSize(_selectedFile!.lengthSync())}'),
            ],
            const Divider(height: 32),
            const Text('Destinations :', style: TextStyle(fontWeight: FontWeight.bold)),
            ...CloudProvider.values.map((provider) => CheckboxListTile(
              title: Text(provider.toString().split('.').last),
              value: _selectedProviders.contains(provider),
              onChanged: (val) {
                setState(() {
                  if (val == true) _selectedProviders.add(provider);
                  else _selectedProviders.remove(provider);
                });
              },
            )),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _selectedFile != null && _selectedProviders.isNotEmpty ? _startUpload : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Uploader'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: orchestrator.activeUploads.length,
                itemBuilder: (context, index) {
                  final task = orchestrator.activeUploads[index];
                  return UploadProgressCard(task: task);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
