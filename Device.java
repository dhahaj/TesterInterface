import java.awt.event.*;
import java.awt.*;
import javax.swing.*;
import javax.swing.event.*;
import javax.swing.Timer;
import java.io.*;
import java.nio.*;
import processing.core.PApplet;
import java.nio.channels.FileChannel;
import java.util.*;
import java.awt.List;
import java.io.File;

/**
 * Enumeration of the devices.
 */
enum Devices {
  EAX2500;
}

/**
 * A Device class which handles all the work
 * in setting variables and getting instructions.
 * @author dmh
 */
public class Device {

  /**
   * Enumeration of the V40 models.
   */
  public enum Models {
    EHxR(1), EH(2), EBxW(3), EB(4), EHxRxLBM(5), EHxLBM(6), EBxLBM(7), EA(8), EBxW_L9SI(9), EH_L9SI(10);


    /** String containing the part number and name for this model. */
    final String part;


    /** Boolean variable which describe the features for each model. */
    boolean hasRelay = true;
    boolean hasMolex = false;
    boolean hasAC = true;
    boolean hasDC = true;
    boolean hasJack = false;
    boolean hasRemote = true;
    boolean hasWires = false;
    boolean hasPad = true;


    Models(int i) {

      // this.part = "104010-" + Integer.toString(this.ordinal()+1) +' '+ this.name();
      this.part = "104010-" + i + ' ' + this.name();


      switch ( i ) {
      case 1: //  EHxR selected
      case 8:  //  EA selected
        hasMolex = true;
        break;
      case 2: //  EH selected
        hasRelay = false;
        break;
      case 3: //  EBxW selected
        hasWires = true;
        hasAC = false;
        break;
      case 7: //  EBxLBM selected
        hasJack = true; // no break, same as EB model
      case 4: //  EB selected
        hasRelay = false;
        hasAC = false;
        break;
      case 5: //  EHxRxLBM selected
        hasMolex = true;
        hasJack = true;
        break;
      case 6: //  EHxLBM selected
        hasRelay = false;
        hasJack = true;
        break;
      case 9: // EBxW L9SI selected
        hasWires = true;
        hasAC = false;
        break;
      case 10: // EH L9SI selected
        hasRelay = false;
        hasDC = false;
        break;
      }
    }
  }

  private Devices d = null;
  private Programs p = null;
  /** The model for this device instance (only used on V40 devices). */
  private Models m = null;

  public Device() {
    this.d = null;
    this.p = null;
    this.m = null;
  }

  static String className = null;

  void setClassName(String className) {
    this.className = className;
  }

  public Device(String device, String prog) {
    this.d = Devices.valueOf(device);
    this.p = Programs.valueOf(prog);
    // if(d==Devices.V40) selectV40Model();
    //else testSetup(this.d);
  }

  public Device(int device, String prog) {
    if (device<0 || device>31) {
      System.err.println("Invalid Device Selection!");
      return;
    }
    Devices dev = null;
    //    if (device==0) dev = Devices.EAX300;
    //    else if (device<13) dev = Devices.EAX500;
    //if (device<22) 
    dev = Devices.EAX2500;
    //    else if (device<31) dev = Devices.V40;
    //    else dev = Devices.EAX3500;
    this.d = dev;
    this.p = Programs.valueOf(prog);
    // if(d==Devices.V40) selectV40Model();
    // else testSetup(this.d);
  }

  /**
   * Constructs a new device
   * @param d the device
   * @param p the program
   */
  public Device(Devices d, Programs p) {
    this.d = d;
    this.p = p;
    //    if (d==Devices.V40) selectV40Model();
    //else testSetup(this.d);
  }

  /**
   * Constructs a new device
   * @param d the device (should be a V40 device)
   * @param p the program
   * @param m the model
   */
  public Device(Devices d, Programs p, Models m) {
    this.d = d;
    this.p = p;
    //    if (d==Devices.V40) this.m = m;
  }

  public String getDevice() {
    if (d==null) return null;
    return d.toString();
  }

  public Devices getDevices() {
    return this.d;
  }

  /**
   * Returns the model of a V40 device.
   * @return The model.
   */
  public String getModelName() {
    return this.m.name();
  }

  public Programs getProgram() {
    return this.p;
  }


  public String toString() {
    String text = new String();
    if (d!=null)  text = "Device: " + d.toString() + " Program: " + p.toString();
    if (m!=null) text += " Model: " + m.toString();
    return text;
  }

  /**
   * Sets the device for this object
   * @param d the device
   */
  public void setDevice(Devices d) {
    this.d = d;
  }

  /**
   * Sets the program for this object
   * @param p the program
   */
  public void setProgram(Programs p) {
    this.p = p;
  }

  /**
   * Shows a dialog to select a V40 model upon selecting a V40 Device
   */
  public void selectV40Model() {
    SwingUtilities.invokeLater(new Runnable() {
      public void run() {
        ArrayList<Object> v40models = new ArrayList<Object>();
        /*for(int i=0;i<Models.values().length;i++) {
         v40models.add ( Models.values()[i].part + " " + Models.values()[i].name() );
         }*/
        for (Models m : Models.values ()) {
          v40models.add(m.part);
        }
        JComboBox v40ComboBox = new  JComboBox(v40models.toArray());
        JPanel panel = new JPanel(new GridLayout(2, 2));
        panel.add( new JLabel( "V40 Models:") );
        panel.add( v40ComboBox );
        JOptionPane.showConfirmDialog(null, panel, "Select V40 Model: ", JOptionPane.OK_CANCEL_OPTION);
        setModel( Models.values()[v40ComboBox.getSelectedIndex()] );
      }
    }
    );
  }


  public boolean getV40ModelDialog() {
    ArrayList<Object> v40models = new ArrayList<Object>();
    for (Models m : Models.values ()) {
      v40models.add(m.part);
    }
    JComboBox v40ComboBox = new  JComboBox(v40models.toArray());
    JPanel panel = new JPanel(new GridLayout(2, 2));
    panel.add( new JLabel( "V40 Models:") );
    panel.add( v40ComboBox );
    JOptionPane.showConfirmDialog(null, panel, "Select V40 Model: ", JOptionPane.OK_CANCEL_OPTION);
    setModel( Models.values()[v40ComboBox.getSelectedIndex()] );
    return true;
  }

  public void setModel(Models m) {
    System.out.println("Selected model: " + m.toString());
    this.m = m;
  }

  static boolean flag = false, running = false;
  //static boolean hasRelay, hasRemote, hasAC, hasDC, hasJack, hasMolex, hasWires, hasPad;
  static String instructionPath = null;
  static String EAX500_Filename =  "EAX300_EAX500inst.txt";
  static String EAX2500_Filename =  "EAX2500inst.txt";
  static String EAX3500_Filename =  "EAX3500inst.txt";
  static String V40_Filename =  "V40inst.txt";

  /**
   * Gets the setup instructions for the current device.
   * @param filePath The path to the file containing the instruction document,
   *     or null to use the static filePath
   * @return The String with the instructions
   */
  public StringBuffer getTestingSetup(String filePath) {
    if (this.d==null)
      return new StringBuffer("No device is selected");

    String path = "";
    if (filePath==null) {
      if (instructionPath!=null)
        path = instructionPath;
      else {
        System.err.println("No path to instructions!");
        return null;
      }
    } else {
      path = filePath;
    }
    path += File.separator;

    StringBuffer testSetup = new StringBuffer();

    switch (this.d) {
    case EAX2500:
      path += EAX2500_Filename;
      break;
    default:
      System.err.println("Error getting test setup instructions");
      return new StringBuffer("Error getting test setup instructions");
    }

    System.out.println("Loading instructions from: " + path);

    // Load the text document
    testSetup.append(getFile(path));
    return testSetup;
  }

  /**
   * Get the default testing instructions for the current device
   * @return The testing instructions
   */
  public StringBuffer getTestingSetup() {
    return getTestingSetup(null);
  }

  public Models getModel() {
    return this.m;
  }

  public String getTiming() {
    return this.p.timing;
  }

  private void println(Object s) {
    PApplet.println(s);
  }

  private static void println(Object[] s) {
    String str = "";
    for (int i=0; i<s.length; i++) {
      str+=(String)s[i]+'\n';
    }
    System.out.println(str);
  }

  static String getFile(String path) { // reads a file and returns as a string
    FileInputStream fIn;
    FileChannel fChan;
    long fSize;
    MappedByteBuffer mBuf;
    String s;
    try {
      // First, open a file for input.
      fIn = new FileInputStream(path);
      // Next, obtain a channel to that file.
      fChan = fIn.getChannel();
      // Get the size of the file.
      fSize = fChan.size();
      // Now, map the file into a buffer.
      mBuf = fChan.map(FileChannel.MapMode.READ_ONLY, 0, fSize);
      char[] c = new char[(int)fSize];
      // Read bytes from the buffer.
      for (int i=0; i < fSize; i++) {
        c[i]=(char)mBuf.get();
      }
      fChan.close(); // close channel
      fIn.close(); // close file
      s = new String(c);

      // return s; // return the String
    }
    catch (Exception exc) {
      System.out.println(exc);
      s = "error loading file";
    }
    return s;
  }

  static String[] getStrings() {
    ArrayList<String> list = new ArrayList<String>();
    for (Devices d : Devices.values ()) {
      list.add(d.toString());
    }
    return list.toArray(new String[list.size()]);
  }
}



