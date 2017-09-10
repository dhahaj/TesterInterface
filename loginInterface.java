/**
    Interface for issuing callbacks from the login thread. 
 */

public interface loginInterface {
  static final boolean LOGIN = 0;
  static final boolean LOGOUT = -1;
  void loggedIn(User u);
  void loggedOut(User u);
}

