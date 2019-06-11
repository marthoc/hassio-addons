# Upgrading RaspBee and ConBee firmware

Firmware upgrades from the web UI will fail silently. Instead, an interactive utility script is provided as part of the Hass.io add-on image that you must use to flash your device's firmware. Follow these instructions to upgrade your firmware.

## Step 1 - Enable SSH access to the Hass.io host

Follow the steps outlined here to enable SSH access: https://developers.home-assistant.io/docs/en/hassio_debugging.html.

## Step 2 - Run the firmware upgrade script

**Note: You may need to remove other USB devices (e.g. a Z-Wave stick) temporarily while flashing Conbee if the update process below fails.**

1. Check your deCONZ add-on logs for the update firmware file name. Look for lines near the beginning of the log that look like this, noting the .CGF file name listed (you'll need this later):
```
GW update firmware found: /usr/share/deCONZ/firmware/deCONZ_Rpi_0x261e0500.bin.GCF
GW firmware version: 0x261c0500
GW firmware version shall be updated to: 0x261e0500
```

Alternatively you can log into your Hass.io host over SSH (set up in step 1) and run this command to extract the GCF line:
```
docker ps | grep deconz | awk '{print $NF}' | while read cont; do echo "Searching in $cont"; docker logs $cont 2>&1 | grep 'GCF\|firmware version'; done

Searching in addon_a0d7b954_deconz
23:59:37:341 GW update firmware found: /usr/share/deCONZ/firmware/deCONZ_Rpi_0x262f0500.bin.GCF
23:59:38:534 Device firmware version 0x261F0500
00:01:47:443 GW firmware version: 0x261f0500
```

2. Stop the deCONZ add-on.
3. Log in to your Hass.io host over SSH (set up in step 1).
4. Invoke the firmware upgrade script:  
```
docker run -it --rm --device=/dev/ttyUSB0 --privileged --cap-add=ALL -v /lib/modules:/lib/modules --entrypoint "/firmware-update.sh" marthoc/hassio-addon-deconz-armhf
```
Where:  
`/dev/ttyUSB0` is the name your device has been assigned (/dev/ttyAMA0 for RaspBee).  
`marthoc/hassio-addon-deconz-armhf` or `marthoc/hassio-addon-deconz-aarch64` or `marthoc/hassio-addon-deconz-amd64` to match the platform you’re running on (Raspberry Pi = armhf; Raspberry Pi 3B+ = aarch64; other platforms = amd64).  

5. Follow the prompts:

- Enter C for Conbee, or R for RaspBee.
- If flashing Conbee, then enter the number that corresponds to the Conbee device in the listing.
Type or paste the full file name that corresponds to the file name that you found in the deCONZ container logs in step 1 (or, select a different filename, but you should have a good reason for doing this).
- If the device/number and file name look OK, type Y to start flashing!

6. You should receive a success message if the flashing is OK. Exit your SSH session and restart the deCONZ add-on.
