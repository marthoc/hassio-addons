# marthoc deCONZ

**IMPORTANT: This add-on is discontinued. Please switch to the deCONZ add-on in the Hass.io official repo. This add-on will not be updated past 2.05.66 and will eventually be deleted entirely. No fixes for any open issues will be forthcoming.**

## Migrating to the official Add-on

To migrate, backup your deCONZ config via the Phoscon WebUI, then restore that config after installing/reinstalling:

1. Open the Phoscon WebUI.
2. Open the hamburger menu.
3. Select 'Gateway'.
4. Select 'Backup Options'.
5. Select 'Create Backup'.
6. Select 'Start Download'.
7. Uninstall this add-on, then install the official deCONZ add-on and configure it.
8. Open the Phoscon WebUI, hamburger menu, Gateway, Backup Options.
9. Select 'Load Backup', then Next.
10. Browse for the file that downloaded in step 6.
11. Select 'Load Backup'.
12. Restart the official add-on.

_You must perform these steps or your Light and Group names and other data will be lost!_
