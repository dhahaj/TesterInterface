/**
 * Main Interface GUI
 *
 * @author dmh
 */

import javax.swing.*;
import org.jdesktop.layout.*;
import java.awt.Color;
import java.awt.event.*;
import java.awt.event.KeyListener.*;
import java.util.EventListener;
import javax.swing.JOptionPane.*;

/**
 * Main Interface GUI
 * @author dmh
 */
public class InterfaceGUI extends JFrame implements loginInterface, WindowListener /*implements LoginThread.Callback*/ {

  // Variables declaration
  private javax.swing.JLabel jDeviceLabel;
  private javax.swing.JMenu jMenuAbout;
  private javax.swing.JMenuBar jMenuBar1;
  private javax.swing.JMenu jMenuDevice;
  private javax.swing.JMenu jMenuEAX2500;
  //  private javax.swing.JMenu jMenuEAX500;
  private javax.swing.JMenu jMenuEdit;
  private javax.swing.JMenu jMenuFile;
  private javax.swing.JMenuItem jMenuItem1;
  public javax.swing.JMenuItem jMenuItem2;
  public javax.swing.JMenuItem jMenuItem3;
  private javax.swing.JMenuItem jMenuItem4;
  public javax.swing.JMenuItem jMenuItem5;
  public javax.swing.JMenuItem jMenuItem6;
  public javax.swing.JMenuItem jMenuItemAdvanced;
  private javax.swing.JMenuItem jMenuItemChangelog;
  //  public javax.swing.JMenuItem jMenuItemEAX300;
  //  private javax.swing.JMenuItem jMenuItemEAX3500;
  private javax.swing.JMenuItem jMenuItemLogout;
  private javax.swing.JMenuItem jMenuItemQuit;
  private javax.swing.JMenuItem jMenuItemVersion;
  //  private javax.swing.JMenu jMenuV40;
  private javax.swing.JScrollPane jScrollPane1;
  private javax.swing.JScrollPane jScrollPane2;
  private javax.swing.JPopupMenu.Separator jSeparator1;
  public javax.swing.JTextArea jTextScreen;
  private javax.swing.JLabel jUserInfoLabel;
  private java.awt.Panel panel1;
  public javax.swing.JButton progButton;
  private java.awt.ScrollPane scrollPane1;
  private java.awt.Scrollbar scrollbar1;
  public javax.swing.JButton testButton;
  private DeviceMenuEvent deviceListener = null;
  public LoginThread loginThread = null;
  //  private WindowListener wl;

  /**
   * Creates new form SnapFrame
   */
  public InterfaceGUI(DeviceMenuEvent dme) {
    this.deviceListener = dme;
    deviceListener.setInterface(this);
    addWindowListener(this);
    initComponents();
    loginThread = new LoginThread(this);
    // addKeyListener(this);
  }

  @Override
    public void windowClosed(WindowEvent e) {
  }

  @Override
    public void windowClosing(WindowEvent e) {
    int exitChoice = javax.swing.JOptionPane.showConfirmDialog(this, "Are you sure you want to exit?", "Confirm exit", javax.swing.JOptionPane.YES_NO_OPTION );
    if (exitChoice==javax.swing.JOptionPane.YES_OPTION) {
      loginThread.logout();
      loginThread.quit();
      System.exit(0);
    }
    println("InterfaceGUI: windowClosingEvent, : " + e.toString());
    if (arduino!=null) {
      arduino.dispose();
    }
  }

  @Override
    public void windowDeactivated(WindowEvent e) {
  }

  @Override
    public void windowDeiconified(WindowEvent e) {
  }

  @Override
    public void windowOpened(WindowEvent e) {
  }

  @Override
    public void windowActivated(WindowEvent e) {
  }

  @Override
    public void windowIconified(WindowEvent e) {
  }

  @SuppressWarnings("unchecked")
    private void initComponents() {

      panel1 = new java.awt.Panel();
      scrollbar1 = new java.awt.Scrollbar();
      scrollPane1 = new java.awt.ScrollPane();
      jScrollPane2 = new javax.swing.JScrollPane();
      progButton = new javax.swing.JButton();
      testButton = new javax.swing.JButton();
      jDeviceLabel = new javax.swing.JLabel();
      jUserInfoLabel = new javax.swing.JLabel();
      jScrollPane1 = new javax.swing.JScrollPane();
      jTextScreen = new javax.swing.JTextArea();
      jMenuBar1 = new javax.swing.JMenuBar();
      jMenuFile = new javax.swing.JMenu();
      jMenuItemLogout = new javax.swing.JMenuItem();
      jSeparator1 = new javax.swing.JPopupMenu.Separator();
      jMenuItemQuit = new javax.swing.JMenuItem();
      jMenuEdit = new javax.swing.JMenu();
      jMenuItemAdvanced = new javax.swing.JMenuItem();
      jMenuDevice = new javax.swing.JMenu();
      //      jMenuItemEAX300 = new javax.swing.JMenuItem();
      //      jMenuV40 = new javax.swing.JMenu();
      jMenuItem1 = new javax.swing.JMenuItem();
      jMenuItem4 = new javax.swing.JMenuItem();
      jMenuEAX2500 = new javax.swing.JMenu();
      jMenuItem2 = new javax.swing.JMenuItem();
      jMenuItem5 = new javax.swing.JMenuItem();
      //      jMenuEAX500 = new javax.swing.JMenu();
      jMenuItem3 = new javax.swing.JMenuItem();
      jMenuItem6 = new javax.swing.JMenuItem();
      //      jMenuItemEAX3500 = new javax.swing.JMenuItem();
      jMenuAbout = new javax.swing.JMenu();
      jMenuItemVersion = new javax.swing.JMenuItem();
      jMenuItemChangelog = new javax.swing.JMenuItem();

      FormListener formListener = new FormListener();

      scrollbar1.setBackground(new java.awt.Color(240, 240, 240));

      scrollPane1.setBackground(java.awt.Color.lightGray);
      scrollPane1.setCursor(new java.awt.Cursor(java.awt.Cursor.N_RESIZE_CURSOR));
      scrollPane1.addInputMethodListener(formListener);

      org.jdesktop.layout.GroupLayout panel1Layout = new org.jdesktop.layout.GroupLayout(panel1);
      panel1.setLayout(panel1Layout);
      panel1Layout.setHorizontalGroup(
      panel1Layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
        .add(org.jdesktop.layout.GroupLayout.TRAILING, panel1Layout.createSequentialGroup()
        .add(0, 0, Short.MAX_VALUE)
        .add(scrollbar1, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE))
        .add(panel1Layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
        .add(org.jdesktop.layout.GroupLayout.TRAILING, panel1Layout.createSequentialGroup()
        .add(scrollPane1, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, 563, Short.MAX_VALUE)
        .addContainerGap()))
        );
      panel1Layout.setVerticalGroup(
      panel1Layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
        .add(org.jdesktop.layout.GroupLayout.TRAILING, scrollbar1, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
        .add(panel1Layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
        .add(scrollPane1, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, 598, Short.MAX_VALUE))
        );

      setDefaultCloseOperation(javax.swing.WindowConstants.DO_NOTHING_ON_CLOSE);
      setTitle(Keys.SOFTWARE_VERSION.toString());
      setBackground(java.awt.Color.orange);
      setMinimumSize(new java.awt.Dimension(400, 200));

      progButton.setFont(new java.awt.Font("Cambria", 1, 18)); // NOI18N
      progButton.setText("Program");
      progButton.setToolTipText("Press to begin programming a device");
      progButton.setBorder(javax.swing.BorderFactory.createEtchedBorder());
      progButton.setBorderPainted(false);
      progButton.setEnabled(false);
      progButton.setIconTextGap(2);
      progButton.addActionListener(formListener);

      testButton.setFont(new java.awt.Font("Cambria", 1, 18)); // NOI18N
      testButton.setText("Test");
      testButton.setToolTipText("Click to begin testing the device");
      testButton.setBorder(javax.swing.BorderFactory.createEtchedBorder());
      testButton.setBorderPainted(false);
      testButton.setEnabled(false);
      testButton.setIconTextGap(6);

      jDeviceLabel.setFont(new java.awt.Font("Cambria", 1, 18)); // NOI18N
      jDeviceLabel.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
      jDeviceLabel.setText("Select a device to begin");
      jDeviceLabel.setToolTipText("Current Device");
      jDeviceLabel.setBorder(javax.swing.BorderFactory.createEtchedBorder(javax.swing.border.EtchedBorder.RAISED));
      jDeviceLabel.setHorizontalTextPosition(javax.swing.SwingConstants.LEFT);

      jUserInfoLabel.setBackground(java.awt.SystemColor.windowText);
      jUserInfoLabel.setFont(new java.awt.Font("Tahoma", 1, 18)); // NOI18N
      jUserInfoLabel.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
      jUserInfoLabel.setText("Not Logged In");
      jUserInfoLabel.setHorizontalTextPosition(javax.swing.SwingConstants.RIGHT);

      jTextScreen.setEditable(false);
      jTextScreen.setBackground(new Color(51, 153, 255));
      jTextScreen.setColumns(20);
      jTextScreen.setFont(new java.awt.Font("Monospaced", 1, 22)); // NOI18N
      jTextScreen.setForeground(new Color(255, 255, 255));
      jTextScreen.setLineWrap(true);
      jTextScreen.setRows(5);
      jTextScreen.setText("Java Version: " + javaVersionName);
      jTextScreen.setToolTipText("");
      jTextScreen.setWrapStyleWord(true);
      jTextScreen.setBorder(javax.swing.BorderFactory.createEtchedBorder());
      jTextScreen.setSelectedTextColor(Color.magenta);
      jScrollPane1.setViewportView(jTextScreen);

      /********************************************/
      /*         FileMenu Setup                */
      /********************************************/
      jMenuFile.setText("File");

      jMenuItemLogout.setText("Logout");
      jMenuItemLogout.addActionListener(formListener);
      jMenuFile.add(jMenuItemLogout);
      jMenuFile.add(jSeparator1);

      jMenuItemQuit.setText("Quit");
      jMenuItemQuit.addActionListener(formListener);
      jMenuItemQuit.addMenuKeyListener(formListener);
      jMenuFile.add(jMenuItemQuit);

      jMenuBar1.add(jMenuFile);

      jMenuEdit.setText("Edit");

      jMenuItemAdvanced.setText("Advanced");
      jMenuItemAdvanced.addActionListener(formListener);
      jMenuEdit.add(jMenuItemAdvanced);

      jMenuBar1.add(jMenuEdit);


      /********************************************/
      /*         DeviceMenu Setup                */
      /********************************************/

      jMenuDevice.setText("Device");
      jMenuDevice.addActionListener(formListener);

      /* jMenuItemEAX300.setText("EAX300");
       jMenuItemEAX300.addActionListener(deviceListener);
       jMenuDevice.add(jMenuItemEAX300);
       jMenuDevice.add(jMenuV40);
       
       jMenuV40.setText("V40");
       for (String s : Programs.getProgramList (Devices.V40)) {
       JMenuItem menuItem = new JMenuItem(s);  
       menuItem.addActionListener(deviceListener);
       jMenuV40.add(menuItem);
       }
       
       jMenuEAX500.setText("EAX500");
       for (String s : Programs.getProgramList (Devices.EAX500)) {
       JMenuItem menuItem = new JMenuItem(s);  
       menuItem.addActionListener(deviceListener);
       jMenuEAX500.add(menuItem);
       }
       jMenuDevice.add(jMenuEAX500);
       */


      //      jMenuEAX2500.setText("EAX2500");
      for (String s : Programs.getProgramList (Devices.EAX2500)) {
        JMenuItem menuItem = new JMenuItem(s);  
        menuItem.addActionListener(deviceListener);
        jMenuDevice.add(menuItem);
      }

      //      jMenuDevice.add(jMenuEAX2500);


      //      jMenuItemEAX3500.setText("EAX3500");
      //      jMenuItemEAX3500.addActionListener(deviceListener);
      //      jMenuDevice.add(jMenuItemEAX3500); 
      //
      jMenuBar1.add(jMenuDevice);


      /********************************************/
      /*         AboutMenu Setup                  */
      /********************************************/
      jMenuAbout.setText("About");
      jMenuItemVersion.setText("Version");
      jMenuItemVersion.addActionListener(new ActionListener() {
        @Override
          public void actionPerformed(java.awt.event.ActionEvent evt) {
          JOptionPane.showMessageDialog(InterfaceGUI.this, "Tester Software revision 7.0.1\nCompiled on 02/28/2017", "Version", JOptionPane.INFORMATION_MESSAGE);
        }
      }
      );
      jMenuAbout.add(jMenuItemVersion);

      jMenuItemChangelog.setText("Changelog");
      jMenuItemChangelog.addActionListener(new ActionListener() {
        @Override
          public void actionPerformed(java.awt.event.ActionEvent evt) {
          JOptionPane.showMessageDialog(InterfaceGUI.this, "ChangeLog:\n  2/28/2017: Software rewritten for the new test fixtures\n  Allows configuration chnages by modifying ASCII files\n  New programmer ICD3 by MicroChip\n", "ChangeLog", JOptionPane.INFORMATION_MESSAGE);
        }
      }
      );
      jMenuAbout.add(jMenuItemChangelog);

      jMenuBar1.add(jMenuAbout);

      setJMenuBar(jMenuBar1);

      /********************************************/
      /*         Device Menu Setup                */
      /********************************************/
      org.jdesktop.layout.GroupLayout layout = new org.jdesktop.layout.GroupLayout(getContentPane());
      getContentPane().setLayout(layout);
      layout.setHorizontalGroup(
      layout.createParallelGroup(org.jdesktop.layout.GroupLayout.TRAILING)
        .add(layout.createSequentialGroup()
        .addContainerGap()
        .add(progButton, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 128, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
        .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
        .add(testButton, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 123, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
        .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED, 39, Short.MAX_VALUE)
        .add(jDeviceLabel)
        .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
        .add(jUserInfoLabel, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 129, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
        .addContainerGap())
        .add(org.jdesktop.layout.GroupLayout.LEADING, jScrollPane1)
        );
      layout.setVerticalGroup(
      layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
        .add(org.jdesktop.layout.GroupLayout.TRAILING, layout.createSequentialGroup()
        .add(jScrollPane1, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, 609, Short.MAX_VALUE)
        .addPreferredGap(org.jdesktop.layout.LayoutStyle.UNRELATED)
        .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
        .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.BASELINE)
        .add(progButton)
        .add(testButton, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 53, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE))
        .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.BASELINE)
        .add(jDeviceLabel, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 53, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
        .add(jUserInfoLabel, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 53, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)))
        .addContainerGap())
        );

      layout.linkSize(new java.awt.Component[] {
        jDeviceLabel, jUserInfoLabel
      }
      , org.jdesktop.layout.GroupLayout.VERTICAL);

      layout.linkSize(new java.awt.Component[] {
        progButton, testButton
      }
      , org.jdesktop.layout.GroupLayout.VERTICAL);

      pack();
    }

  // Code for dispatching events from components to event handlers.
  private class FormListener implements ActionListener, InputMethodListener, javax.swing.event.MenuKeyListener {

    FormListener() {
    }

    public void actionPerformed(java.awt.event.ActionEvent evt) {
      System.out.print("FormListener: ");
      println(evt.getActionCommand());

      if (evt.getSource() == progButton) {
        InterfaceGUI.this.progButtonActionPerformed(evt);
      } else if (evt.getSource() == jMenuItemLogout) {
        InterfaceGUI.this.jMenuItemLogoutActionPerformed(evt);
        //l.logout();
      } else if (evt.getSource() == jMenuItemQuit) {
        InterfaceGUI.this.jMenuItemQuitActionPerformed(evt);
      } else if (evt.getSource() == jMenuItemAdvanced) {
        InterfaceGUI.this.jMenuItemAdvancedActionPerformed(evt);
      } else if (evt.getSource() == jMenuItem1) {
        InterfaceGUI.this.jMenuItem1ActionPerformed(evt);
      } else if (evt.getSource() == jMenuItem5) {
        InterfaceGUI.this.jMenuItem5ActionPerformed(evt);
      }
    }

    public void caretPositionChanged(java.awt.event.InputMethodEvent evt) {
      if (evt.getSource() == scrollPane1) {
        InterfaceGUI.this.scrollPane1CaretPositionChanged(evt);
      }
    }

    public void inputMethodTextChanged(java.awt.event.InputMethodEvent evt) {
    }

    public void menuKeyPressed(javax.swing.event.MenuKeyEvent evt) {
    }

    public void menuKeyReleased(javax.swing.event.MenuKeyEvent evt) {
      //      if (evt.getSource() == jMenuItemQuit) {
      //InterfaceGUI.this.jMenuItemQuitMenuKeyReleased(evt);
      //      }
    }

    public void menuKeyTyped(javax.swing.event.MenuKeyEvent evt) {
    }
  }

  /**
   * Begins the device programming section
   *
   * @param evt
   */
  private void progButtonActionPerformed(java.awt.event.ActionEvent evt) {
    // TODO: Add call to console for programming
  }

  /**
   * Triggers a logout event
   *
   * @param evt
   */
  private void jMenuItemLogoutActionPerformed(java.awt.event.ActionEvent evt) {
    println(evt.getActionCommand());
    if (loginThread.loggedin()) {
      SwingUtilities.invokeLater(new Runnable() {
        @Override
          public void run() {
          loginThread.logout();
          loginThread.quit();
          loginThread = new LoginThread(eax2500_swing_test.InterfaceGUI.this);
          loginThread.setCallback(eax2500_swing_test.InterfaceGUI.this);
          loginThread.start();
        }
      }
      );
    }
  }

  private void jMenuItemAdvancedActionPerformed(java.awt.event.ActionEvent evt) {
    // TODO: add method to show a new dialog window
  }

  /**
   * Quit menu item was pressed
   *
   * @param evt
   */
  private void jMenuItemQuitActionPerformed(java.awt.event.ActionEvent evt) {
    int exitChoice = javax.swing.JOptionPane.showConfirmDialog(this, "Are you sure you want to exit?", "Confirm exit", javax.swing.JOptionPane.YES_NO_OPTION );
    if (exitChoice==javax.swing.JOptionPane.YES_OPTION) {
      loginThread.logout();
      loginThread.quit();
      System.exit(0);
    }
  }

  private void scrollPane1CaretPositionChanged(java.awt.event.InputMethodEvent evt) {
  }

  private void jMenuItem1ActionPerformed(java.awt.event.ActionEvent evt) {
    println("GUI MENU ACTI: " + evt.toString());
  }

  private void jMenuItem5ActionPerformed(java.awt.event.ActionEvent evt) {
    println(evt.toString());
  }

  public void setUserLabel(String s) {
    this.jUserInfoLabel.setText(s);
    this.jUserInfoLabel.setVisible(true);
  }

  public void setDeviceLabel(String s) {
    this.jDeviceLabel.setText(s);
    this.jDeviceLabel.setVisible(true);
  }

  public void setDeviceListener(DeviceMenuEvent dme) {
    this.deviceListener = dme;
  }

  public void doLogin() {
    loginThread = new LoginThread(this, log);
    loginThread.setCallback(this);
    loginThread.start();
  }

  @Override
    public void loggedIn(User u) {
    jUser = u;
    println("GUI: login callback: User = "+u.getName());
    setUserLabel(jUser.getName());
    //    testButton.setEnabled(true);
    //    progButton.setEnabled(true);
  }

  @Override
    public void loggedOut(User u) {
    jUser = null;
    println("GUI: logout callback");
    setUserLabel("Not logged in");
    testButton.setEnabled(false);
    progButton.setEnabled(false);
  }

  public void showInstructions(Devices device) {
    switch(device) {
      //    case EAX300:
      //    case EAX500:
    case EAX2500:

    default:
      break;
    }
    this.jTextScreen.setText(device.toString());
  }

  public void setScreenText(StringBuffer sb) {
    this.jTextScreen.setText(sb.toString());
  }
  
  public void appendText(String s){
    jTextScreen.append(s + "\n");
  }
}

