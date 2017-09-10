import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.io.StreamCorruptedException;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.*;
import java.text.*;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.lang.Object;
import javax.swing.Timer;
import javax.swing.*;
import javax.swing.event.*;
import java.awt.event.*;
import java.awt.*;
import com.dhahaj.*;
import java.util.logging.*;
import processing.data.*;
import processing.core.*;

class LoginThread extends Thread implements Serializable {

  private static final long serialVersionUID = 488622392452789817L;
  private static final String userConfigFile = eax2500_swing_test.dataPath + "\\users.json";
  private final boolean DEBUG = eax2500_swing_test.DEBUG;
  private boolean running;
  private boolean loggedIn;
  private User thisUser;
  private ArrayList<User> userArrayList = null;
  private final String filename = eax2500_swing_test.dataPath + File.separator + "users.dat";
  private String currentUser;
  final static int TOTAL_CNT = 0, FAILED_CNT = 1, PASSED_CNT = 2, PROG_CNT = 3;
  private Timer loginTimer;
  static Frame f = null;
  private eax2500_swing_test.InterfaceGUI st;
  private loginInterface iface;
  private JSONObject users;
  private JSONArray userArray;

  void init() {

    userArrayList = new ArrayList();

    users = PApplet.loadJSONObject(new File(userConfigFile));
    System.out.println(users.toString());

    for (Object s : users.keys ()) {
      System.out.println(s);
      String p = users.getString((String)s);
      User u = new User((String)s, p);
      userArrayList.add(u);
    }
  }

  public LoginThread(eax2500_swing_test.InterfaceGUI st) {
    this.st = st;
    running = false;
    loggedIn = false;
    this.iface=null;
    init();
  }

  public LoginThread(eax2500_swing_test.InterfaceGUI st, Logger log) {
    this.st=st;
    running = false;
    loggedIn = false;
    this.iface=null;
    init();
  }

  public void setCallback(loginInterface iface) {
    this.iface = iface;
  }
  
  public void doCallback(boolean eventType){
	  if(iface!=null){
		  if(eventType==loginInterface.LOGIN){
			  iface.loggedIn(thisUser);
		  } else if(eventType == loginInterface.LOGOUT)[
			  iface.loggedOut(thisUser);
		  ]
	  }
  }

  private ArrayList<User> getUsers() {
    return userArrayList;
  }

  public void start() {
    running=true; // Start the run loop
    super.start();
  }

  /*
   MAIN LOOP
   */
  //@Override
  public void run() {
    loginTimer = new Timer(1800000, new ActionListener() {
      public void actionPerformed(ActionEvent evt) {
        eax2500_swing_test.log.info("\nUser "+getUsername()+" auto-eax2500_swing_test.log off\t");
        logout();
      }
    }
    );

    // Outer Loop
    while (running) {

      // Inner Loop
      while (!loggedIn) {

        ArrayList<String> usernames = new ArrayList<String>();
        //userArrayList = loadUsers();

        for ( User u : userArrayList)
          usernames.add(u.getName());

        final JComboBox userid = new  JComboBox(usernames.toArray(new String[usernames.size()]));
        int previousIndex = (Integer)Keys.LAST_USER.value;

        try { // try incase the index is out of bounds
          userid.setSelectedIndex( (Integer)Keys.LAST_USER.value );
        }
        catch (Exception e) {
          e.printStackTrace();
        }

        final JPasswordField pwd = new JPasswordField(10);
        pwd.addAncestorListener( new RequestFocusListener() );
        final JPanel panel = new JPanel(new GridLayout(2, 2));
        panel.add( new JLabel( "UserID:") );
        panel.add( userid );
        panel.add( new JLabel( "Password:") );
        panel.add( pwd );

        int action = JOptionPane.showConfirmDialog(f, panel, "LOGIN", JOptionPane.OK_CANCEL_OPTION);

        if (action==JOptionPane.OK_OPTION) { // OK button pressed, verify the password

          // Get the user selected from the list
          final User selectedUser = userArrayList.get(userid.getSelectedIndex());

          // Store selected user
          Keys.LAST_USER.setPref(userid.getSelectedIndex());

          // Check the password
          final String pass = new String(pwd.getPassword());
          if (selectedUser.checkPassword(pass)) { // Password Accepted!
            thisUser = selectedUser;
            MyLogger.User = thisUser.getName();
            loggedIn = true;
            //new UserEvent();
            //            Callback c = new Callback();
            //            loggedIn(thisUser);
            loginTimer.start();
            //if (this.iface!=null) iface.loggedIn (thisUser);
			doCallback(loginInterface.LOGIN);
            //enableMenu(thisUser.isAdmin());
            break;
          } else { // Display a bad password notification
            try {
              SwingUtilities.invokeAndWait(new Runnable() {
                public void run() {
                  JOptionPane.showMessageDialog(f, "Incorrect Password!", "Error", JOptionPane.ERROR_MESSAGE );
                }
              }
              );
            }
            catch (Exception e) {
              e.printStackTrace();
            }
          }
        } else { // Cancel or escape was pressed. Prompt to either login or close software.
          try {
            SwingUtilities.invokeAndWait( new Runnable() {
              public void run() {
                int exitChoice = JOptionPane.showConfirmDialog(f, "Are you sure you want to exit?", "Confirm exit", JOptionPane.YES_NO_OPTION );
                if (exitChoice != JOptionPane.YES_OPTION) return;
                eax2500_swing_test.log.info("Software closed");
                quit();
                System.exit(0);
              }
            }
            );
          }
          catch (Exception e) {
            e.printStackTrace();
          }
        }
      } // END_INNER_LOOP
    } // END_OUTER_LOOP
  }

  boolean loggedin() {
    return loggedIn;
  }

  void logout() {
    if (loggedIn) {
      // if (iface!=null)
        // iface.loggedOut(thisUser);
	  doCallback(loginInterface.LOGOUT);
      synchronized(this) {
        eax2500_swing_test.log.info("\nUser " + thisUser.getName()
          + " logged off\n\t*devices passed: "  + thisUser.getCount(PASSED_CNT)
          + "\n\t*devices failed: "             + thisUser.getCount(FAILED_CNT)
          + "\n\t*total devices tested: "       + thisUser.getCount(TOTAL_CNT)
          + "\n\t*devices programmed: "         + thisUser.getCount(PROG_CNT)
          + "\n\t*" );
      }
      MyLogger.User = getUsername();
      loggedIn = false;
    }
    //    loggedOut(thisUser);
    // Stop the timer if running
    if (loginTimer.isRunning())
      loginTimer.stop();
  }

  void restartTimer() {
    if (loggedIn)
      loginTimer.restart();
  }

  String getUsername() {
    if (loggedIn && thisUser.getName()!=null)
      return thisUser.getName();
    else
      return null;
  }

  User getUser() {
    return this.thisUser;
  }

  // Our method that quits the thread
  void quit() {
    // Stop the timer
    try {
      if (loginTimer.isRunning())
        loginTimer.stop();
    }
    catch (Exception t) {
      t.printStackTrace();
    }
    loggedIn = false;
    running = false;  // Setting running to false ends the loop in run()
    if (DEBUG) System.out.println("LoginThread is stopping.");
    // if (iface!=null) {
      // iface.loggedOut(thisUser);
    // }
	doCallback(loginInterface.LOGOUT);
  }

  /*public void addNewUser(String name, String pass, boolean admin) {
   User newUser = new User(name, pass, admin);
   userArrayList.add(newUser);
   storeData(filename, userArrayList.toArray());
   }*/

  public String removeUser(int index) {
    // Remove the user from the list
    User removedUser = userArrayList.remove(index);

    // Save the modified list
    //    storeData(this.filename, userArrayList.toArray());

    // Return the name of the removed user
    return removedUser.getName();
  }

  public boolean isAdmin() {
    return thisUser.isAdmin();
  }

  boolean running() {
    return running;
  }

  public class RequestFocusListener implements AncestorListener {
    private boolean removeListener;
    public RequestFocusListener() {
      this(true);
    }
    public RequestFocusListener(boolean removeListener) {
      this.removeListener = removeListener;
    }
    public void ancestorAdded(AncestorEvent e) {
      JComponent component = e.getComponent();
      component.requestFocusInWindow();
      if (removeListener)
        component.removeAncestorListener( this );
    }

    public void ancestorMoved(AncestorEvent e) {
    }

    public void ancestorRemoved(AncestorEvent e) {
    }
  }

  private static boolean dataFileExists(String filename) { // Checks for the existance of a file
    try {
      FileInputStream stream = new FileInputStream( new File( filename ) );
      if (stream != null) {
        try {
          stream.close();
        }
        catch (IOException e) {
          e.printStackTrace();
        }
        return true;
      }
    }
    catch (FileNotFoundException e) {
      return false;
    }
    return false;
  }
}

