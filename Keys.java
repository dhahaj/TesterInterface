import java.io.File;
import java.util.prefs.Preferences;

public enum Keys {

  SOFTWARE_VERSION("7.0.1"), 
  GLOBAL_COUNT(0), 
  BATCH_FILE("runIPE.bat"), 
  FIRMWARE_FOLDER(eax2500_swing_test.dataPath),
  BATCH_Path(eax2500_swing_test.dataPath + "\\data"), 
  LAST_SERIAL(0), // The last serial number used
  
  EAX300_REV("5.9"), 
  EAX500_REV("5.9.1"), 
  EAX2500_REV("7.3"), 
  V40_REV("5.4"), 
  EAX3500_REV("A0"), 


  EAX300_PATH("\\EAX300_5.9.OBJ"), 
  EAX300_FILE("EAX300_5.9.OBJ"), 
  EAX300_EXT("_5.9.OBJ"), 

  EAX500_PATH("C:\\EAX_500_v5.9.1\\EAX500_591.OBJ"), 
  EAX500_FILE("EAX500_591.OBJ"), 
  EAX500_EXT("_591.OBJ"), 

  EAX2500_PATH("C:\\EAX_2500_V73\\EAX2500_73.OBJ"), 
  EAX2500_FILE("EAX2500_73.OBJ"), 
  EAX2500_EXT("_73.OBJ"), 

  EAX3500_PATH("C:\\EAX_3500_A0\\EAX3500_A0.OBJ"), 
  EAX3500_FILE("EAX3500_A0.OBJ"), 
  EAX3500_EXT("_A0.OBJ"), 

  V40_PATH("C:\\v40_ver4_0\\V40xx00_40.OBJ"), 
  V40_FILE("V40xx00_54.OBJ"), 
  V40_EXT("_54.OBJ"), 

  LAST_USER(10), 
  LAST_DELAY(594), 
  COM_PORT("COM 1"), 
  COM(1);

  Object value;
  Object defaultValue;
  private Preferences prefs = Preferences.userNodeForPackage(eax2500_swing_test.class);
  static String absolutePath = new File("").getAbsolutePath();
  java.util.logging.Logger jLog;

  // Constructors:
  Keys(String defVal) {
    jLog = java.util.logging.Logger.getLogger(this.getClass().toString());
    if (defVal==null) {
      this.defaultValue = "";
    } else if (defVal.contains("\\")) {
      this.defaultValue= defVal;
    } else {
      this.defaultValue = defVal;
    }
    this.value = (String)prefs.get(this.name(), defVal);
    System.out.println("Loaded " + this.name() + ": " + this.value);
  }

  Keys(int defVal) {
    jLog = java.util.logging.Logger.getLogger(this.getClass().toString());
    this.defaultValue = defVal;
    //this.value = ((Integer)(prefs.getInt(this.name(), defVal))).intValue();
  }

  Keys(boolean defVal) {
    jLog = java.util.logging.Logger.getLogger(this.getClass().toString());
    this.defaultValue = defVal;
    //    this.value = ((Boolean)(prefs.getBoolean(this.name(), defVal))).booleanValue();
  }

  public Preferences getPrefs() {
    return prefs;
  }

  static Preferences getPrefs(Class name) {
    return Preferences.userNodeForPackage(name);
  }

  public void setPref(String value) {
    this.prefs.put(this.name(), (String) value);
    this.value = value;
  }

  public void setPref(int value) {
    this.prefs.putInt(this.name(), value);
    this.value = value;
  }

  public void clearPref() {
    this.value = defaultValue;
    if ( defaultValue instanceof Integer)
      this.setPref((Integer) defaultValue);
    else if ( defaultValue instanceof String )
      this.setPref((String) defaultValue);
  }

  static void clearAllPrefs() {
    for ( Keys key : Keys.values () )
      key.clearPref();
  }

  public String toString() {
    return this.name() + ": " + this.value;
  }
}

