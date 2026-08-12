import 'package:contractor_app/core/constants/app_colors.dart';
import 'package:contractor_app/core/utils/responsive.dart';
import 'package:contractor_app/features/recruitment/data/models/job_model.dart';
import 'package:contractor_app/features/recruitment/data/services/recruitment_service.dart';
import 'package:flutter/material.dart';
import 'job_list_tile.dart';

class RecruitmentScreen extends StatefulWidget {
  const RecruitmentScreen({super.key});

  @override
  State<RecruitmentScreen> createState() => _RecruitmentScreenState();
}

class _RecruitmentScreenState extends State<RecruitmentScreen> {
  List<JobModel> _jobs = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final jobs = await RecruitmentService.instance.getPostedJobs();
      if (!mounted) return;
      setState(() => _jobs = jobs);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Could not load posted jobs.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _addJob() async {
    final payload = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const _PostJobDialog(),
    );
    if (payload == null) return;
    final job = await RecruitmentService.instance.postJob(payload);
    if (!mounted) return;
    setState(() => _jobs.insert(0, job));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Posted jobs')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addJob,
        icon: const Icon(Icons.add),
        label: const Text('Post job'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                      const SizedBox(height: 12),
                      Text(_error!),
                      const SizedBox(height: 12),
                      OutlinedButton(onPressed: _load, child: const Text('Retry')),
                    ],
                  ),
                )
              : _jobs.isEmpty
                  ? Center(
                      child: Text(
                        'No jobs posted yet — tap "Post job".',
                        style: theme.textTheme.bodySmall,
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.all(context.w(16)),
                      itemCount: _jobs.length,
                      separatorBuilder: (_, _) => SizedBox(height: context.h(10)),
                      itemBuilder: (context, index) =>
                          JobListTile(job: _jobs[index]),
                    ),
    );
  }
}

class _PostJobDialog extends StatefulWidget {
  const _PostJobDialog();

  @override
  State<_PostJobDialog> createState() => _PostJobDialogState();
}

class _PostJobDialogState extends State<_PostJobDialog> {
  final _title = TextEditingController();
  final _designation = TextEditingController();
  final _location = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _designation.dispose();
    _location.dispose();
    super.dispose();
  }

  void _submit() {
    if (_title.text.trim().isEmpty || _designation.text.trim().isEmpty) {
      setState(() => _error = 'Job title and designation are required.');
      return;
    }
    Navigator.of(context).pop({
      'title': _title.text.trim(),
      'designation': _designation.text.trim(),
      'location': _location.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Post a job'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _title,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Job title',
              hintText: 'e.g. Masons needed – Tower B slab work',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _designation,
            decoration: const InputDecoration(
              labelText: 'Designation',
              hintText: 'e.g. Mason',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _location,
            decoration: const InputDecoration(labelText: 'Location'),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(color: AppColors.error)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Post')),
      ],
    );
  }
}