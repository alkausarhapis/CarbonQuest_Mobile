enum NavigationRoute {
  mainRoute("/"),
  loginRoute("/login"),
  registerRoute("/register");

  final String path;
  const NavigationRoute(this.path);
}
