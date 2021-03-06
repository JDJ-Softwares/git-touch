import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:git_touch/models/auth.dart';
import 'package:git_touch/models/notification.dart';
import 'package:git_touch/models/theme.dart';
import 'package:git_touch/screens/bb_explore.dart';
import 'package:git_touch/screens/bb_teams.dart';
import 'package:git_touch/screens/bb_user.dart';
import 'package:git_touch/screens/gitea_orgs.dart';
import 'package:git_touch/screens/gitea_user.dart';
import 'package:git_touch/screens/gitlab_explore.dart';
import 'package:git_touch/screens/gitlab_groups.dart';
import 'package:git_touch/screens/gitlab_project.dart';
import 'package:git_touch/screens/gitlab_todos.dart';
import 'package:git_touch/screens/gitlab_user.dart';
import 'package:git_touch/screens/login.dart';
import 'package:git_touch/screens/notification.dart';
import 'package:git_touch/screens/user.dart';
import 'package:git_touch/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:git_touch/screens/news.dart';
import 'package:git_touch/screens/search.dart';
import 'package:git_touch/screens/trending.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int active = 0;

  _buildScreen(int index) {
    // return GitlabProjectScreen(32221);
    // return IssuesScreen('flutter', 'flutter', isPullRequest: true);
    // return IssueScreen('reactjs', 'rfcs', 29);
    // return IssueScreen('reactjs', 'rfcs', 68, isPullRequest: true);
    // return Image.asset('images/spinner.webp', width: 32, height: 32);
    final auth = Provider.of<AuthModel>(context);

    switch (auth.activeAccount.platform) {
      case PlatformType.github:
        switch (index) {
          case 0:
            return NewsScreen();
          case 1:
            return NotificationScreen();
          case 2:
            return TrendingScreen();
          case 3:
            return SearchScreen();
          case 4:
            return UserScreen(null);
        }
        break;
      case PlatformType.gitlab:
        switch (index) {
          case 0:
            return GitlabExplore();
          case 1:
            return GitlabGroups();
          case 2:
            return GitlabUserScreen(null);
        }
        break;
      case PlatformType.bitbucket:
        switch (index) {
          case 0:
            return BbExploreScreen();
          case 1:
            return BbTeamsScreen();
          case 2:
            return BbUserScreen(null);
        }
        break;
      case PlatformType.gitea:
        switch (index) {
          case 0:
            return GiteaOrgsScreen();
          case 1:
            return GiteaUserScreen(null);
        }
        break;
    }
  }

  Widget _buildNotificationIcon(BuildContext context, bool isActive) {
    final theme = Provider.of<ThemeModel>(context);
    final iconData = Icons.notifications;
    int count = Provider.of<NotificationModel>(context).count;
    if (count == 0) {
      return Icon(iconData);
    }

    // String text = count > 99 ? '99+' : count.toString();
    return Stack(
      children: <Widget>[
        Icon(iconData),
        Positioned(
            right: -2,
            top: -2,
            child: Icon(Octicons.primitive_dot,
                color: theme.palette.primary, size: 14))
      ],
    );
  }

  List<BottomNavigationBarItem> get _navigationItems {
    switch (Provider.of<AuthModel>(context).activeAccount.platform) {
      case PlatformType.github:
        return [
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed),
            title: Text('News'),
          ),
          BottomNavigationBarItem(
            icon: _buildNotificationIcon(context, false),
            activeIcon: _buildNotificationIcon(context, true),
            title: Text('Notification'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.whatshot),
            title: Text('Trending'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            activeIcon: Icon(Icons.person),
            title: Text('Me'),
          ),
        ];
      case PlatformType.gitlab:
        return [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            title: Text('Explore'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            title: Text('Groups'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Me'),
          ),
        ];
      case PlatformType.bitbucket:
        return [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            title: Text('Explore'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            title: Text('Teams'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Me'),
          ),
        ];
      case PlatformType.gitea:
        return [
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            title: Text('Organizations'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Me'),
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);
    final auth = Provider.of<AuthModel>(context);
    if (auth.activeAccount == null) {
      return LoginScreen();
    }

    switch (theme.theme) {
      case AppThemeType.cupertino:
        return CupertinoTabScaffold(
          tabBar: CupertinoTabBar(items: _navigationItems),
          tabBuilder: (context, index) {
            return CupertinoTabView(builder: (context) {
              return _buildScreen(index);
            });
          },
        );
      default:
        return Scaffold(
          body: _buildScreen(active),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: theme.palette.primary,
            items: _navigationItems,
            currentIndex: active,
            type: BottomNavigationBarType.fixed,
            onTap: (int index) {
              setState(() {
                active = index;
              });
            },
          ),
        );
    }
  }
}
