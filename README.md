# Sneaker

Sneaker is a browser-based radar and GCI simulation designed for use with [Tacview]() and [DCS: World](https://www.digitalcombatsimulator.com/en/). Users are presented with a simulated radar scope that provides air, sea and optionally land targets with speed/altitude/type information. Additionally Sneaker provides some GCI-specific functionality:

- Configure per-aircraft or profile based threat and warning radius's that provide visual and auditory cues for trespasses.
- Searching, tagging, and watching flights allows you to reduce workload and allow a controller to work across many flights and packages.
- Mission clock and hack timers for command and coordination.

A live example of Sneaker can be viewed [here](https://sneaker.precontact.net/).

![UI preview](https://i.imgur.com/KB2yzC3.png)

## Conventional installation

1. Download the latest released version [from here](https://github.com/Special-K-s-Flightsim-Bots/sneaker/releases/latest).
2. Create a configuration file based off the [example](/example.config.json), replacing the required information (and optionally adding multiple servers to the array)
3. Run the executable with the configuration path: `sneaker.exe --config config.json`
4. Browse to http://localhost:7788 to access Sneaker GCI. To make the website available over the network, specify the bind parameter like so: `sneaker.exe --config config.json --bind 0.0.0.0:7788`

## Docker installation

A minimum viable product Docker image has been created which can be used as follows:

1. Create a configuration file based off the [example](/example.config.json), replacing the required information (and optionally adding multiple servers to the array) and place in a folder of your choice, e.g. ``/tmp/config/config.json``
2. Run the Docker command ``docker run -it -p 7788:7788 -e CONFIG_FILE_NAME=config.json -e PORT=7788 -e BIND_IP=0.0.0.0 -e DEBUG=0 -e TIMEOUT=30 -v /tmp/config/:/config/  aterfax/sneaker-webgci``
3. Browse to http://yourDockerMachineHostname:7788 to access Sneaker GCI.

This image has been created with the requirement that the user bind mount the config file, or a directory with the config file to the Docker container at the path ``/config`` with the ``-v`` Docker argument. The user must also supply the correct config file name given with the ``CONFIG_FILE_NAME`` environment variable all as shown above.

The user can choose to change the internal Sneaker daemon selected port with the ``PORT`` environment variable, but must also match this with the correct ``-p`` Docker arguments if changed.

The bind IP can be changed as required to only bind a particular IP address, or all IP addresses with ``0.0.0.0`` as shown with the ``BIND_IP`` environment variable.

The ``DEBUG`` environment variable can be set to ``1`` or ``0``, to show or hide extended logging info and environment variable dumps to the console.

The ``TIMEOUT`` environment variable can be set to any positive value of seconds in whole numbers and controls how often the running Docker container will check if the Sneaker daemon is still online, and restart it if it isn't.


### Discord Integration

Sneaker features a built-in Discord integration which provides basic server information and GCI duty tracking via Discord slash-commands.

1. Create a new [Discord Application](https://discord.com/developers/applications) and configure the `Interactions Endpoint URL` to point at your Sneaker installations `/api/discord/interactions` endpoint.
2. Add a Bot to the application (this is used to DM users about GCI duty timeouts)
3. Add the bot to your server by opening a link generated [here](https://discord.com/developers/applications/935306685692674078/oauth2/url-generator). You only need the `applications.commands` scope.
4. Add the following to your `config.json`:
```json
"discord": {
  "application_id": "<discord application id, bunch of numbers>",
  "application_key": "<discord public key, bunch of letters/numbers>",
  "token": "<discord bot token>",
  "state_path": "<optional path to a location to save GCI duty state between restarts>",
  "timeout": "<number of minutes before gci is automatically logged off duty, default = 60>",
  "reminder": "<number of minutes before timeout to warn gci via discord, default = 5>"
}
```

## Documentation

- [API](/docs/API.md) provides information on the internal Sneaker API.

## Web UI

The Sneaker web UI presents an emulated radar scope over top a [Open Street Map](https://openstreetmap.org) rendered via [maptalks](https://maptalks.org). The web UI is updated at a configurable simulated refresh rate (by default 5 seconds).

### Bullseye

Bullseye information for the current cursor position is displayed in the bottom right corner of the screen, additionally the bullseye icon is rendered in its position on the map.

### BRAA

A BRAA line can be drawn by right clicking anywhere on the map and dragging. Additionally if you press the "s" (snap) key while starting the BRAA line on-top of an existing track the starting point will be locked to the tracks position.

### Mission Timer & Hack Timers

The mission timer is available in the bottom left corner. Clicking on the timer will create a new hack timer which will display above. 
