""" ----------------------------------------
* Creation Time : Tue Jul  4 11:35:42 2023
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
----------------------------------------"""

import pyautogui
import datetime

# Get current date
current_date = datetime.datetime.now().strftime("%Y%m%d")

# Type the date
pyautogui.write(current_date)
