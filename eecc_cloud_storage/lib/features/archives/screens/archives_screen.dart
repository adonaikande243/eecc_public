import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/cloud_file.dart';
import '../../core/services/storage_orchestrator.dart';
import '../widgets/archive_card.dart';

class ArchivesScreen extends StatefulWidget {
  const ArchivesScreen({super.key});

  @override
  State<ArchivesScreen> createState() => _ArchivesScreenState();
}

class _ArchivesScreenState extends State<ArchivesScreen> {
  bool _isLoading = false;
  List<CloudFile> _files = [];

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    setState(() => _isLoading = true);
    final orchestrator = Provider.of<StorageOrchestrator>(context, listen: false);
    try {
      final f1 = await orchestrator.googleServiceAccount.listFiles();
      final f2 = await orchestrator.googleOAuth.listFiles();
      final f3 = await orchestrator.oneDrive1.listFiles();
      final f4 = await orchestrator.oneDrive2.listFiles();
      
      setState(() {
        _files = [...f1, ...f2, ...f3, ...f4];
        _files.sort((a, b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
      });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Archives EECC'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Tous'),
              Tab(text: 'Drive'),
              Tab(text: 'OneDrive 1'),
              Tab(text: 'OneDrive 2'),
            ],
          ),
          actions: [
            IconButton(icon: const Icon(Icons.settings), onPressed: () => Navigator.pushNamed(context, '/auth/google')),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildList(_files),
                  _buildList(_files.where((f) => f.provider == CloudProvider.googleDriveServiceAccount || f.provider == CloudProvider.googleDriveOAuth).toList()),
                  _buildList(_files.where((f) => f.provider == CloudProvider.oneDrive1).toList()),
                  _buildList(_files.where((f) => f.provider == CloudProvider.oneDrive2).toList()),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/upload'),
          child: const Icon(Icons.cloud_upload),
        ),
      ),
    );
  }

  Widget _buildList(List<CloudFile> files) {
    if (files.isEmpty) return const Center(child: Text("Aucune archive trouvée."));
    return RefreshIndicator(
      onRefresh: _loadFiles,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: files.length,
        itemBuilder: (context, index) => ArchiveCard(file: files[index]),
      ),
    );
  }
}
