from nunchuck import nunchuck
from time import sleep
 
wii = nunchuck()
 
while True:
  print wii.button_c()
  sleep(0.2)