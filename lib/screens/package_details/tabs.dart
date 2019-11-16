import 'package:dynamic_theme/dynamic_theme.dart';
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
      physics: NeverScrollableScrollPhysics(),
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

class AnalysisTab extends StatelessWidget {
  final AnalysisPackageTab packageTab;

  const AnalysisTab({Key key, this.packageTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(15),
      children: <Widget>[
        ScoreSlider(
          name: 'Popularity:',
          score: packageTab.popularity,
        ),
        ScoreSlider(
          name: 'Health:',
          score: packageTab.health,
        ),
        ScoreSlider(
          name: 'Maintenance:',
          score: packageTab.maintenance,
        ),
        ScoreSlider(
          name: 'Overall:',
          score: packageTab.overall,
        ),
        DependenciesSection(dependencies: packageTab.dependencies),
      ],
    );
  }
}

class ScoreSlider extends StatelessWidget {
  const ScoreSlider({
    @required this.name,
    @required this.score,
  })  : assert(name != null),
        assert(score != null);

  final String name;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(name),
        Expanded(
          child: Slider(
            value: score.toDouble(),
            onChanged: null,
            min: 0,
            max: 100,
          ),
        ),
        Text(score.toString())
      ],
    );
  }
}

class DependenciesSection extends StatelessWidget {
  const DependenciesSection({
    Key key,
    @required this.dependencies,
  }) : super(key: key);

  final List<BasicDependency> dependencies;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Dependencies",
            style: Theme.of(context).textTheme.headline,
          ),
        ),
        Card(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            height: MediaQuery.of(context).size.height / 3.5,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: dependencies.length,
              itemBuilder: (BuildContext context, int index) {
                final dependency = dependencies[index];
                return ListTile(
                  title: Text(dependency.name),
                  trailing: Text(
                    dependency.constraint?.toString() ??
                        dependency.resolved?.toString() ??
                        '',
                    style: Theme.of(context).primaryTextTheme.caption,
                  ),
                  onTap: () {},
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
