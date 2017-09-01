import processing.serial.*;

/*
 * Tester Interface Main Window  Rev7.0
 *  12/7/2016
 *  author: DMH
 */

import com.dhahaj.*;
import java.util.logging.*;
import java.util.Calendar;
import java.awt.event.*;
import java.util.prefs.Preferences;
import java.io.*;
import java.math.*;
import static java.nio.charset.Charset.defaultCharset;
import java.text.*;
import java.lang.instrument.*;

public final static boolean DEBUG = true;
public final static String VERSION = "Tester Interface - Rev 2.0.1";
public static String dataPath = null; 
static Logger log;
Timer testTimer;
Device currentDevice = null;
JArduino arduino = null;
private User jUser = null;
private InterfaceGUI i;
private DeviceMenuEvent deviceEvent;
Preferences prefs = null;
XML xml;


void setup() {
  loadConfig();
  Keys version = Keys.SOFTWARE_VERSION;
  dataPath = dataPath("");
  MyLogger.FilePath = dataPath("Log");
  log = Logger.getLogger(this.getClass().toString());
  try {
    MyLogger.setup();
  } 
  catch (IOException e) {
    throw new RuntimeException("Problems with creating the log files");
  } 
  finally {
    log.info("Program started");
  }


  deviceEvent = new DeviceMenuEvent();
  i = new InterfaceGUI(deviceEvent);
  frameRate(4);
  addShutDownHook();

  arduino = new JArduino(this, JArduino.list()[0]);

  SwingUtilities.invokeLater(new Runnable() {
    public void run() {
      while (frame.getWindowListeners ().length == 0); // wait for it
      ChangeWindowListener(); // Change the window listener
      i.setVisible(true);
      i.doLogin();
    }
  }
  );
}

void draw() {
  frame.setVisible(false);
  noLoop();
}


// Add shutdown hook to perform actions upon closing the software
public void addShutDownHook() {
  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
    @Override
      public void run() {
      //      Keys.LAST_DELAY.setPref(sdr1.getValue());
      if (DEBUG) println("shutdown hook");
      try {
        if (arduino!=null) arduino.digitalWrite(13, JArduino.LOW);
      } 
      catch (Exception e) {
        //e.printStackTrace();
      } 
      if (DEBUG) println("closing");
    }
  }
  ));
}


public void serialError() {
  println("serial error");
}

public void serialAvailable() {
}

public void setUser(User u) {
  jUser = u;
}

User getUser() {
  return jUser;
}

void ChangeWindowListener() {  // Needed for confirming an exit 
  WindowListener[] wls = frame.getWindowListeners();
  frame.removeWindowListener(wls[0]); // Suppose there is only one...
  frame.addWindowListener(
  new WindowAdapter() {
    public void windowClosing(WindowEvent we) {
      if (DEBUG) println("Should be closing!");
      confirmExit();
    }
    public void windowActivated(WindowEvent e) {
      //jUser.restartTimer();
      if (DEBUG) println("window activated!");
    }
  }
  );
}

// Loads the XML Config file
void loadConfig() {
  xml = loadXML(dataPath("config.xml"));
  XML[] children = xml.getChildren("User");
  User[] users = new User[children.length];
  for (int i = 0; i < children.length; i++) {
    XML n = children[i].getChild("name"), 
    p = children[i].getChild("pass"), 
    a = children[i].getChild("admin");
    try {
      User u = new User(n.getContent(), p.getContent(), a.getIntContent());
      users[i] = u;
    }
    catch(Exception e) {
    }
  }
  XML[] c = xml.getChildren("Properties");
  for ( XML x : c) {
    println(x.getContent().trim());
  }
}

public void confirmExit() {
  int exitChoice = javax.swing.JOptionPane.showConfirmDialog(this, "Are you sure you want to exit?", "Confirm exit", javax.swing.JOptionPane.YES_NO_OPTION );
  if (exitChoice==javax.swing.JOptionPane.YES_OPTION) {
    //    loginThread.logout(); loginThread.quit();
    this.dispose();
    System.exit(0);
  }
}

void showDialog(String s) { // Runs a swing error dialog
  final String msg = s;
  SwingUtilities.invokeLater( new Runnable() {
    public void run() {
      javax.swing.JOptionPane.showMessageDialog(frame, msg, "Error", javax.swing.JOptionPane.ERROR_MESSAGE );
    }
  }
  );
}

public boolean fileExists(String f) {
  File file = new File(f);
  return (file.exists() && !file.isDirectory() );
}

public String getContents(File f) {
  String s = "";
  java.nio.file.Path path = f.toPath();

  byte[] fileArray;
  try {
    fileArray = java.nio.file.Files.readAllBytes(path);
    for (int i=0; i<fileArray.length; i++) {
      s += (char)fileArray[i];
    }
  } 
  catch(Exception e) {
  }
  return s;


  //  ArrayList<String> list = java.nio.file.Files.readAllLines(path, java.nio.charset.);//path.readAllLines(path);
  //  Iterator<String> i = list.iterator();
  //  while (i.hasNext ()) {
  //    ;
  //  }
  //  return s;
}


public static String strToHex(String arg) {
  String s = String.format("%04x", new BigInteger(1, arg.getBytes(defaultCharset())));
  return s;
}

/**
 * Returns a string of the combination of the date, the current user
 *  and the serial numbner. This is used for storing info into the EE
 *  data section of the mictrocontroller. 
 */
public static String parseHex(User u, int serialNum) {
  SimpleDateFormat sdf = new SimpleDateFormat("MMdd");
  String date = sdf.format(Calendar.getInstance().getTime());

  String userName = u.getName();
  if (userName.length() > 2) {
    userName = userName.substring(0, 1) + userName.substring(2, 3);
  }
  String eeString = userName + date + serialNum;
  // Convert to a charactar array
  char[] origChars = eeString.toCharArray();
  // Flip the charactars in the array
  char[] newChars = reverse(origChars);
  // Rejoin the chars to make a String
  String newEEData = join(str(newChars), "");
  debug("Original string: " + eeString);
  debug("Flipped charactars: " + newEEData);
  // Convert to hex string
  String user_date_hex = strToHex(newEEData);
  debug("String converted to hex: " + user_date_hex);
  return user_date_hex;
}

static public void setContents(File aFile, String aContents)
throws FileNotFoundException, IOException {
  if (aFile == null) {
    throw new IllegalArgumentException("File should not be null.");
  }
  if (!aFile.exists()) {
    throw new FileNotFoundException ("File does not exist: " + aFile);
  }
  if (!aFile.isFile()) {
    throw new IllegalArgumentException("Should not be a directory: " + aFile);
  }
  if (!aFile.canWrite()) {
    throw new IllegalArgumentException("File cannot be written: " + aFile);
  }

  //use buffering
  Writer output = new BufferedWriter(new FileWriter(aFile));
  try {
    //FileWriter always assumes default encoding is OK!
    output.write( aContents );
  }
  finally {
    output.close();
  }
}
