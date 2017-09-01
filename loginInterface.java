/**
    Interface for issuing callbacks from the login thread. 
 */

public interface loginInterface {
  void loggedIn(User u);
  void loggedOut(User u);
}

