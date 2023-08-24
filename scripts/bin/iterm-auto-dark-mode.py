""" ----------------------------------------
* Creation Time : Sun 29 May 11:57:21 2022
* Last Modified : Wed Jun  8 08:38:22 2022
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
----------------------------------------"""

#!/usr/bin/env python3

import asyncio
import iterm2
import os
import subprocess


async def main(connection):
    async with iterm2.VariableMonitor(
        connection, iterm2.VariableScopes.APP, "effectiveTheme", None
    ) as mon:
        try:
            output = subprocess.check_output(
                "defaults read -g AppleInterfaceStyle", shell=True
            )

            if output.decode("utf-8").strip() == "Dark":
                preset = await iterm2.ColorPreset.async_get(connection, "tokyo-night")
            else:  # this shouldn't trigger because "light" gives a shell error
                preset = await iterm2.ColorPreset.async_get(
                    connection, "rose-pine-dawn"
                )
        except subprocess.CalledProcessError as e:
            preset = await iterm2.ColorPreset.async_get(connection, "rose-pine-dawn")

        # Update the list of all profiles and iterate over them.
        profiles = await iterm2.PartialProfile.async_query(connection)
        for partial in profiles:
            # Fetch the full profile and then set the color preset in it.
            profile = await partial.async_get_full_profile()
            await profile.async_set_color_preset(preset)

        while True:
            # Block until theme changes
            theme = await mon.async_get()

            # Themes have space-delimited attributes, one of which will be light or dark.
            parts = theme.split(" ")
            if "dark" in parts:
                preset = await iterm2.ColorPreset.async_get(connection, "tokyo-night")
            else:
                preset = await iterm2.ColorPreset.async_get(
                    connection, "rose-pine-dawn"
                )

            # Update the list of all profiles and iterate over them.
            profiles = await iterm2.PartialProfile.async_query(connection)
            for partial in profiles:
                # Fetch the full profile and then set the color preset in it.
                profile = await partial.async_get_full_profile()
                await profile.async_set_color_preset(preset)


iterm2.run_forever(main)
