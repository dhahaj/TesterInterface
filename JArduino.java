
/**
 * Together with the Firmata 2 firmware (an Arduino sketch uploaded to the
 * Arduino board), this class allows you to control the Arduino board from
 * Processing: reading from and writing to the digital pins and reading the
 * analog inputs.
 */
public class JArduino {

  public static final int RELAY=9, BATT=4, LOW_BATT=2, DOOR=6, REMOTE=5, TEST=3, OKC=8;

  public static final int INPUT = 0;
  public static final int OUTPUT = 1;
  public static final int LOW = 0;
  public static final int HIGH = 1;

  eax2500_swing_test parent;
  JSerial serial;
  SerialProxy serialProxy;
  Firmata firmata;

  // We need a class descended from PApplet so that we can override the
  // serialEvent() method to capture serial data.  We can't use the Arduino
  // class itself, because PApplet defines a list() method that couldn't be
  // overridden by the static list() method we use to return the available
  // serial ports.  This class needs to be public so that the Serial class
  // can access its serialEvent() method.
  public class SerialProxy extends eax2500_swing_test {
    public SerialProxy() {
    }

    public void serialEvent(JSerial which) {
      try {
        // Notify the Arduino class that there's serial data for it to process.
        while (which.available () > 0)
          firmata.processInput(which.read());
      } 
      catch (Exception e) {
        e.printStackTrace();
        throw new RuntimeException("Error inside Arduino.serialEvent()");
      }
    }
  }

  public class FirmataWriter implements Firmata.Writer {
    public void write(int val) {
      serial.write(val);
      //      System.out.print("<" + val + " ");
    }
  }

  public void dispose() {
    this.serial.dispose();
  }

  /**
   * Get a list of the available Arduino boards; currently all serial devices
   * (i.e. the same as Serial.list()).  In theory, this should figure out
   * what's an Arduino board and what's not.
   */
  public static String[] list() {
    return JSerial.list();
  }

  /**
   * Create a proxy to an Arduino board running the Firmata 2 firmware at the
   * default baud rate of 57600.
   *
   * @param parent the Processing sketch creating this Arduino board
   * (i.e. "this").
   * @param iname the name of the serial device associated with the Arduino
   * board (e.g. one the elements of the array returned by Arduino.list())
   */
  public JArduino(eax2500_swing_test parent, String iname) {
    this(parent, iname, 57600);
  }

  public JArduino(eax2500_swing_test parent) {
    this(parent, JArduino.list()[0], 57600);
  }

  /**
   * Create a proxy to an Arduino board running the Firmata 2 firmware.
   *
   * @param parent the Processing sketch creating this Arduino board
   * (i.e. "this").
   * @param iname the name of the serial device associated with the Arduino
   * board (e.g. one the elements of the array returned by Arduino.list())
   * @param irate the baud rate to use to communicate with the Arduino board
   * (the firmata library defaults to 57600, and the examples use this rate,
   * but other firmwares may override it)
   */
  public JArduino(eax2500_swing_test parent, String iname, int irate) {
    this.parent = parent;
    this.firmata = new Firmata(new FirmataWriter());
    this.serialProxy = new SerialProxy();
    this.serial = new JSerial(serialProxy, iname, irate);

    parent.registerMethod("dispose", this);

    try {
      Thread.sleep(1500); // let bootloader timeout
    } 
    catch (InterruptedException e) {
    }
    firmata.init();
  }

  /**
   * Returns the last known value read from the digital pin: HIGH or LOW.
   *
   * @param pin the digital pin whose value should be returned (from 2 to 13,
   * since pins 0 and 1 are used for serial communication)
   */
  public int digitalRead(int pin) {
    return firmata.digitalRead(pin);
  }

  public int read(int p) {
    return digitalRead(p);
  }

  /**
   * Set a digital pin to input or output mode.
   *
   * @param pin the pin whose mode to set (from 2 to 13)
   * @param mode either Arduino.INPUT or Arduino.OUTPUT
   */
  public void pinMode(int pin, int mode) {
    try {
      firmata.pinMode(pin, mode);
    } 
    catch (Exception e) {
      e.printStackTrace();
      throw new RuntimeException("Error inside Arduino.pinMode()");
    }
  }

  public void mode(int p, int m) {
    pinMode(p, m);
  }

  public void output(int p) {
    mode(p, OUTPUT);
  }

  public void input(int p) {
    mode(p, INPUT);
  }

  /**
   * Write to a digital pin (the pin must have been put into output mode with
   * pinMode()).
   *
   * @param pin the pin to write to (from 2 to 13)
   * @param value the value to write: Arduino.LOW (0 volts) or Arduino.HIGH
   * (5 volts)
   */
  public void digitalWrite(int pin, int value) {
    try {
      firmata.digitalWrite(pin, value);
    } 
    catch (Exception e) {
      e.printStackTrace();
      throw new RuntimeException("Error inside Arduino.digitalWrite()");
    }
  }

  public void write(int p, int v) {
    digitalWrite(p, v);
  }

  public void low(int p) {
    write(p, LOW);
  }

  public void high(int p) {
    write(p, HIGH);
  }

  public void toggle(int p) {
    if (read(p)==HIGH) write(p, LOW);
    else write(p, HIGH);
  }
}

