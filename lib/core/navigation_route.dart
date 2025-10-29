enum NavigationRoute {
  mainRoute("/"),
  loginRoute("/login"),
  registerRoute("/register"),
  missionRoute("/mission");

  final String path;
  const NavigationRoute(this.path);
}
