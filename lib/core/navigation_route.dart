enum NavigationRoute {
  mainRoute("/"),
  loginRoute("/login"),
  registerRoute("/register"),
  quizRoot("/quiz"),
  quizQuestion("/quiz_question");

  final String path;
  const NavigationRoute(this.path);
}
