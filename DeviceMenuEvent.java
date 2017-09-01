import java.awt.*;
import javax.swing.*;
import java.util.*;

public class DeviceMenuEvent implements java.awt.event.ActionListener {

  private eax2500_swing_test.InterfaceGUI i;
  private Programs p;
  private Device device;
  private Devices d;

  DeviceMenuEvent() {
  }

  public void setInterface(eax2500_swing_test.InterfaceGUI itf) {
    i=itf;
  }

  @Override
    public void actionPerformed(java.awt.event.ActionEvent evt) {
    String s = evt.getActionCommand();
    System.out.println(s);
    p = Programs.valueOf(s);
    System.out.println(p.toString());
    d = p.device;
    i.setDeviceLabel(s);
    i.progButton.setEnabled(true);
    i.testButton.setEnabled(true);
    device = new Device(d, p);
    StringBuffer sb = device.getTestingSetup(eax2500_swing_test.dataPath);
    i.setScreenText(sb);
  }
}


