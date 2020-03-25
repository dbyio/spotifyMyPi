# A Docker image for Spotifyd on Raspberry Pi

_spotifyMyPi_ builds a Docker image of [Spotifyd](https://github.com/Spotifyd/spotifyd) from source, pulled from the master branch.
The base image is now based on [Alpine Linux](https://alpinelinux.org).


### Build it

```
git clone https://github.com/dbyio/spotifyMyPi
cd spotifyMyPi
chmod +x do.sh
sudo ./do.sh build
```

If you're satisfied with the result, you'll want to remove the intermediary _build_ image, which can grow rather extensively.
```
sudo docker image prune 
```

### Configure it

Copy then edit `conf/spotifyd.conf` in `/opt/spotifyd/etc`. You'll need to set your Spotify Premium accounts details, as well as your sound card Alsa identifier.

**Alignment of the _audio_ GUID
If you're running Docker on a debian-based system (typically Raspbian), you'll need to align the GUID of the _audio_ group on your host system with Alpine's. On your host system, run `sudo vigr` and change the GUID for _audio_ to 18. Failing to do so will result in the service not being able to access the soundcard device.
```
$ grep audio /etc/group
audio:x:18:
```


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

The following command will rebuild a new image using updated source code and base image.

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

The _spotifyd_ container should now be started when your DAC is powered on, stopped when powered off.
