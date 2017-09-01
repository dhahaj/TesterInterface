/**
 *  Program
 *
 *  @brief Function which creates a new process for running the QW software
 */

Preferences p = Keys.GLOBAL_COUNT.getPrefs();

void Program () {

  // Do not program the device while testing is active
  if (testTimer.isRunning()) {
    showDialog("Testing is currently active!");
    return;
  } else if (currentDevice==null) {
    showDialog("Choose a firmware file to program.");
    return;
  } else if (arduino==null) {
    try {
      arduino.low(JArduino.TEST);  // Remove test jumper from ground
      arduino.low(JArduino.BATT);  // Make sure DC power is off before programming!
    } 
    catch(Exception e) {
      showDialog("Error communicating with tester.");
      return;
    }
  }

  String location = dataPath("")+"\\firmware"; //Keys.getString("FIRMWARE_FOLDER") + File.separator + currentDevice.getProgram().toString();

  // Set the arguments from the stored settings
  final String[] qw_args = new String[4];
  qw_args[0] = "C:\\pictools\\qw.exe";//Keys.getString("QW_PATH");
  qw_args[2] = "/A /D16F627";// Keys.getString("QW_ARUN") + " " + Keys.getString("QW_CHIP");
  qw_args[3] = "/X"; //Keys.getString("QW_AEXIT");

  String firmwareDirectoary = dataPath("firmware");

  // Add the file extension to the location string
  //  switch(currentDevice.getDevices()) {
  //  case EAX300:
  //    location += Keys.getString("EAX300_EXT");
  //    break;
  //  case EAX500:
  //    location += Keys.getString("EAX500_EXT");
  //    break;
  //  case EAX2500:
  //    location += Keys.getString("EAX2500_EXT");
  //    break;
  //  case EAX3500:
  //    location += Keys.getString("EAX3500_EXT");
  //    break;
  //  case V40:
  //    location += Keys.getString("V40_EXT");
  //    break;
  //  }

  debug("hex file location: " + location);
  if (!(fileExists(location))) {
    // Make sure you can access the target firmware
    showDialog("File not found:\n" + location);
    return;
  }

  // Path to the quickwriter control file
  final String ctrlFilePath = dataPath("QWControl.qwc");

  // Make sure the file exists
  if (!fileExists(ctrlFilePath)) {
    showDialog("Could not find QuickWriter control file.");
    return;
  }

  // Load the control file
  final File ctrlFile = new File(ctrlFilePath);
  String[] ctrlStrings = getContents(ctrlFile).split("\n");

  // Get the serial number and make sure it is not greater than 100
  //  (QW EEData Limitations)
  int lastSerialNumber = prefs.getInt("LAST_SERIAL", 0);
  if (lastSerialNumber % 100 ==0)
    lastSerialNumber = 0;

  final int newSerialNumber = lastSerialNumber + 1;

  // Create a hex formatted string
  String user_date_hex = parseHex(jUser, newSerialNumber);

  for (int i=0; i<ctrlStrings.length; i++) {

    // Change the hex file location in the control file
    if (ctrlStrings[i].contains("HEXFILE")) {
      ctrlStrings[i] = "HEXFILE=" + location;
      continue;
    }

    // Ensure we manualy control the serial numbering
    else if (ctrlStrings[i].contains("Auto=1")) {
      ctrlStrings[i] = "Auto=0";
      continue;
    }

    // Set the hex string for the EE Data Section
    else if (ctrlStrings[i].contains("last_a")) {
      // Put the serial number in the control file (hex format)
      ctrlStrings[i] = "last_a=" + user_date_hex;
      debug("Appending to control file: " + ctrlStrings[i]);
    }
  }

  // Save the modified control file
  try {
    setContents(ctrlFile, join(ctrlStrings, "\n"));
  }
  catch(Exception e) {
    showDialog("Couldn't save the control file!");
    println(e);
    return;
  }

  // Put the arg in qoutes to handle any whitespaces chars
  qw_args[1] = '"' + ctrlFilePath + '"';

  debug("Programming Args:");
  debug(join(qw_args, " "));

  if (arduino!=null) {
    arduino.low(JArduino.TEST);//, Arduino.LOW);  // Remove test jumper from ground
    arduino.low(JArduino.BATT);//, Arduino.LOW);  // Make sure DC power is off before programming!
  }

  // Open the QW Software and wait for an exit code
  // to determine if it programmed correctly
  Runnable runQuickWriter = new Runnable() {
    @Override
      public void run() {
      String args = join(qw_args, " ");
      debug("quickwriter args: " + args);
      Runtime r = Runtime.getRuntime();
      Process p = null;
      try {
        p = r.exec(args);
        p.waitFor();
      }
      catch(Exception e) {
        debug("error programming");
      }

      debug("QW return value: " + p.exitValue());
      short exitValue = (short)(p.exitValue());

      if (exitValue != 0) { // Returned with an error
        java.nio.ByteBuffer b = java.nio.ByteBuffer.allocate(4);
        b.putInt(exitValue);
        byte lowByte = b.get(3);
        String errMsg = null;
        switch(lowByte) {
        case 1:
          errMsg = "Error communicating with Port";
          break;
        case 2:
          errMsg = "Communication Timeout, Hardware not responding";
          break;
        case 4:
          errMsg = "Communication Error Detected, BAD data received";
          break;
        case 8:
          errMsg = "Current Programming Task Failed";
          break;
        case 10:
          errMsg = "Firmware update Required";
          break;
        case 20:
          errMsg = "Higher Transfer Speed Failed";
          break;
        case 40:
          errMsg = "User Aborted Task in progress";
          break;
        case 80:
        default:
          errMsg = "Unknown Error has Occurred";
          break;
        }

        byte highByte = b.get(2);
        debug("low byte = "+lowByte);
        debug("high byte = "+highByte);
        // byte[] result = b.array();
        // println(result);

        appendText("\nError: " + errMsg);
        log.warning("Error programming " + currentDevice.getProgram().toString()
          + ", " + errMsg);
        showDialog(errMsg);
      } else { // Programming was succesful

        sBuffer.append("\n\nProgramming Succesful! ");

        // Make a log entry
        log.info("Programming initiated by " + user.getUsername()
          + " -- " + currentDevice.getProgram().toString()
          + " Serial#:" + newSerialNumber + "(" + hex(newSerialNumber) + ")" );

        // Increment the user's programming count
        user.getUser().incrementCount(LoginThread.PROG_CNT);

        // Save the last used serial number
        Keys.LAST_SERIAL.setPref(newSerialNumber);
        debug("Saved serial number: " + Keys.getInt("LAST_SERIAL"));
      }
    }
  };
  runQuickWriter.run();
}

