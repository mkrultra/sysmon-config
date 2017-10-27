# sysmon-config | A fork of the original, wonderful, Swift on Security-built sysmon configuration. It Just Works™.

This is a Microsoft Sysinternals Sysmon configuration file template with default high-quality event tracing.

The instructions here include deployment via GPO.

Original notes:

The file provided should function as a great starting point for system change monitoring in a self-contained package. This configuration and results should give you a good idea of what's possible for Sysmon. Note that this does not track things like authentication and other Windows events that are also vital for incident investigation.

Because virtually every line is commented and sections are marked with explanations, it should also function as a tutorial for Sysmon and a guide to critical monitoring areas in Windows systems.

Note: Exact syntax and filtering choices are deliberate to catch appropriate entries and to have as little performance impact as possible. Sysmon's filtering abilities are different than the built-in Windows auditing features, so often a different approach is taken than the normal static listing of every possible important area.

## Use

### Deployment via Group Policy
#### Major thanks to Pablo Delgado at Syspanda for his excellent work on sysmon deployment via Group Policy

1. Create batch file for the sysmon install. This will be placed in the root domain folder that is accessible to each domain client.

The .bat file included within this repo copies sysmon-config.xml and sysmon.exe to "C:\Windows\", and if sysmon isn't running, it will install it using that configuration.

2. Create a folder on your domain that will be replicated by other domain controllers and copy in the following files:
* sysmon.bat
* [sysmon.exe](https://technet.microsoft.com/en-us/sysinternals/sysmon)
* sysmon-config.xml

3. Launch the Group policy utility and follow these actions:
* Right-click your domain and
  1. **Create GPO in this domain, and link it here**
  2. Provide a name (like **Sysmon Deployment**), click OK
  3. Right-click your newly-created GPO (**Sysmon Deployment**) and select **Edit**
  4. Navigate to **Computer configuration>Preferences>Scheduled Tasks**
  5. Right-click **Scheduled Tasks** and click on **Scheduled Tasks (At Least Windows 7)**. (Note: this should work for Win7, Win10, and Server 2008/2012)
  6. Under the *General* tab set the following:
    * When running the task, use the following user account: **NT AUTHORITY\System**
    * Configure for: **Windows 7**
  7. Under the *Trigger* tab click on **New**
    * Set schedule for daily, running every hour between 0730 and 1930. You can set this for your own production hours when you expect to make changes to the sysmon config. This will allow all your clients to constantly check for an updated version of the config.
    * Click **OK** when done
  8. Under the *Actions* tab click on **New**
    * **Program/script: \\domain.com\directory\sysmon_install.bat**
  9. Optional: Under the *Settings* tab, you can check **Allow task to be run on demand** (which allows you to manually trigger the scheduled task on an endpoint when you login. This helps with initial testing).
  10. Once done, click **OK**
4. Exit out of Group Policy

At this point, all your endpoints are installing sysmon and checking it for updates. Neat, right?

### Original install instructions
Run with administrator rights
~~~~
sysmon.exe -accepteula -i sysmonconfig-export.xml
~~~~

### Update existing configuration ###
Run with administrator rights
~~~~
sysmon.exe -c sysmonconfig-export.xml
~~~~

### Uninstall ###
Run with administrator rights
~~~~
sysmon.exe -u
~~~~

## Required actions ##

### Prerequisites ###
Highly recommend using [Notepad++](https://notepad-plus-plus.org/) to edit this configuration. It understands UNIX newline format and does XML syntax highlighting, which makes this very understandable. I do not recommend using the built-in Notepad.exe.

### Customization ###
You will need to install and observe the results of the configuration in your own environment before deploying it widely. For example, you will need to exclude actions of your antivirus, which will otherwise likely fill up your logs with useless information.

The configuration is highly commented and designed to be self-explanatory to assist you in this customization to your environment.

### Design notes ###
This configuration expects software to be installed system-wide and NOT in the C:\Users folder. 

If your users install Chrome themselves, you should deploy the [Chrome MSI](https://enterprise.google.com/chrome/chrome-browser/), which will automatically change the shortcuts to the machine-level installation. Your users will not even notice anything different.
