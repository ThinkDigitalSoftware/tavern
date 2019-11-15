import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/widgets/html_view.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionsTab extends StatelessWidget {
  final List<Version> versions;

  const VersionsTab({Key key, this.versions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (versions == null) {
      return Center(
        child: Text('No content'),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: versions.length,
      itemBuilder: (context, index) {
        var version = versions[index];
        return Card(
          child: ListTile(
            title: Text('${version.semanticVersion.toString()}'),
            subtitle: Text('Uploaded: ${version.uploadedDate}'),
            onTap: () => launch(version.documentationUrl),
          ),
        );
      },
    );
  }
}

class InstallingTab extends StatelessWidget {
  final InstallingPackageTab packageTab;

  const InstallingTab({Key key, this.packageTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (packageTab == null) {
      return Center(
        child: Text('No content'),
      );
    }
    return HtmlView(html: packageTab.content);
  }
}

class ExampleTab extends StatelessWidget {
  final ExamplePackageTab packageTab;

  const ExampleTab({Key key, this.packageTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (packageTab == null) {
      return Center(
        child: Text('No content'),
      );
    }
    return HtmlView(html: packageTab.content);
  }
}

class ChangelogTab extends StatelessWidget {
  final ChangelogPackageTab packageTab;

  const ChangelogTab({Key key, this.packageTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (packageTab == null) {
      return Center(
        child: Text('No content'),
      );
    }
    return Column(
      children: <Widget>[
        Expanded(
          child: HtmlView(
            html: packageTab.content,
          ),
        ),
      ],
    );
  }
}

class ReadmeTab extends StatelessWidget {
  final ReadMePackageTab packageTab;

  const ReadmeTab({Key key, this.packageTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (packageTab == null) {
      return Center(
        child: Text('No content'),
      );
    }
    return HtmlView(html: packageTab.content);
  }
}

class AboutTab extends StatelessWidget {
  final FullPackage package;

  const AboutTab({Key key, this.package}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: ListView(
        children: <Widget>[
          Text(package.description),
          Text('Author: ${package.author ?? "No author listed"}'),
          if (package.uploaders?.isNotEmpty ?? false) Text('Uploaders:'),
          for (String uploader in package?.uploaders ?? [])
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(uploader),
                FlatButton.icon(
                  icon: Icon(Icons.mail_outline),
                  label: Text('Email'),
                  onPressed: () => launch('mailto:$uploader'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class ErrorReport extends StatelessWidget {
  final AsyncSnapshot snapshot;

  const ErrorReport({Key key, this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            snapshot.error.toString(),
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              'This error was unexpected. Please file an issue on our GitHub repository so we can fix it.'),
        ),
        RaisedButton.icon(
          icon: Icon(GroovinMaterialIcons.github_circle),
          label: Text('File Issue'),
          onPressed: () {
            //TODO: launch new issue page for our repo, pass in error if possible
          },
        ),
      ],
    );
  }
}
