enum NavigationRoute {
  mainRoute("/"),
  loginRoute("/login"),
  registerRoute("/register"),
  profileRoute("/profile"),
  quizRoot("/quiz"),
  quizQuestion("/quiz_question"),
  missionRoute("/mission"),
  articleListRoute("/article_list");

  final String path;
  const NavigationRoute(this.path);
}
