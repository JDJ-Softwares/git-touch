import 'package:flutter/material.dart';
import 'package:git_touch/models/auth.dart';
import 'package:git_touch/models/gitlab.dart';
import 'package:git_touch/scaffolds/refresh_stateful.dart';
import 'package:git_touch/utils/utils.dart';
import 'package:git_touch/widgets/action_entry.dart';
import 'package:git_touch/widgets/app_bar_title.dart';
import 'package:git_touch/widgets/blob_view.dart';
import 'package:provider/provider.dart';

class GitlabBlobScreen extends StatelessWidget {
  final int id;
  final String ref;
  final String path;
  GitlabBlobScreen(this.id, this.ref, {this.path});

  @override
  Widget build(BuildContext context) {
    return RefreshStatefulScaffold<GitlabBlob>(
      title: AppBarTitle(path ?? ''),
      fetchData: () async {
        final res = await Provider.of<AuthModel>(context).fetchGitlab(
            '/projects/$id/repository/files/${path.urlencode}?ref=$ref');
        return GitlabBlob.fromJson(res);
      },
      action: ActionEntry(iconData: Icons.settings, url: '/choose-code-theme'),
      bodyBuilder: (data, _) {
        return BlobView(path, base64Text: data.content);
      },
    );
  }
}
