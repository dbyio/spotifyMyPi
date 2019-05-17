# A Docker image for Spotifyd on Raspberry Pi

Built image relies on pre-compiled binaries pulled from https://github.com/Spotifyd/spotifyd.


### Build it

```
git clone https://github.com/dbyio/spotifyMyPi
cd spotifyMyPi
chmod +x do.sh
sudo ./do.sh build
```


### Configure it

Copy then edit `conf/spotifyd.conf` in `/opt/spotifyd/etc`. You'll need to set your Spotify Premium accounts details, as well as your sound card Alsa identifier.


### Run it

**Option 1:**
```
sudo ./do.sh run
```

**Option 2:** run with **systemd**
```
sudo cp conf/spotifyd.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable spotifyd
sudo systemctl start spotifyd
```


### Update the image

The following command will rebuild a new image using the latest Spotifyd binaries and an updated base image.

```
sudo ./do.sh update
```


## Bind the service to an external DAC's power status

If you want the Spotifyd container to start/stop when you switch on/off your external USB DAC, use systemd to bind the service to the relevant device unit.

Use the following command to identify the device unit related to your DAC:
```
sudo systemctl  list-units --type=device
```

Edit the *Unit* and *Install* sections of the spotifyd.service file as follows:
```
[Unit]
BindsTo=docker.service [your DAC's device unit name here]
After=docker.service [your DAC's device unit name here]
StopWhenUnneeded=true

[...]

[Install]
WantedBy=multi-user.target [your DAC's device unit name here]
```

Please note that modifying the *Install* section of an existing unit file will require re-enabling the unit, not just daemon-reloading systemd.

The Spotifyd container should now be started when your DAC is powered on, stopped when powered off.
