## A Docker image for Spotifyd daemon on Raspberry Pi

The built image relies on pre-compiled binaries pulled from https://github.com/Spotifyd/spotifyd.


### Build it

```
git clone https://github.com/dbyio/spotifyMyPi
cd spotifyMyPi
chmod +x do.sh
sudo ./do.sh build
```


### Configure it

Copy then edit `conf/spotifyd.conf` in `/opt/spotifyd/etc`

You'll need to set your Spotify Premium accounts details in there, as well as your sound card Alsa identifier.


### Run it

Simple way:
```
sudo ./do.sh run
```

#### OR

Run with **systemd** (recommended):
```
sudo cp conf/spotifyd.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable spotifyd
sudo systemctl start spotifyd
```


### Update the image

The following command will build a new image using the latest Spotifyd binaries and upgrade the system base image.

```
sudo ./do.sh update
```

You'll then need to (re)start the image manually (using *./do.sh* or systemctl).
