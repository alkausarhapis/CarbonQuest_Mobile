enum NavigationRoute {
  mainRoute("/"),
  loginRoute("/login"),
  registerRoute("/register"),
  profileRoute("/profile"),
  settingsRoute("/settings"),
  changePasswordRoute("/change_password"),
  editProfileRoute("/edit_profile"),
  changePointTargetRoute("/change_point_target"),
  mockDataRoute("/mock_data"),
  quizRoot("/quiz"),
  quizQuestion("/quiz_question"),
  missionRoute("/mission"),
  articleListRoute("/article_list");

  final String path;
  const NavigationRoute(this.path);
}
