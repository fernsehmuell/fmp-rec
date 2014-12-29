import smbus
import time

bus = smbus.SMBus(1)
button_c = False
button_z = False
button_c_last=False
button_z_last=False

bus.write_byte_data(0x52,0x40,0x00)
time.sleep(0.1)

while True:
	try:
		bus.write_byte(0x52,0x00)
		time.sleep(0.1)
		data0 =  bus.read_byte(0x52)
		data1 =  bus.read_byte(0x52)
		data2 =  bus.read_byte(0x52)
		data3 =  bus.read_byte(0x52)
		data4 =  bus.read_byte(0x52)
		data5 =  bus.read_byte(0x52)
		#joy_x = data0
		#joy_y = data1
		buttons = data5 & 0x03
		button_c = (buttons == 0) or (buttons == 1)
		button_z = (buttons == 0) or (buttons == 2)

		if (button_c) and (button_c_last==False):
			print 'Button C wurde gedrueckt'
		if (button_c==False) and (button_c_last):
			print 'Button C wurde losgelassen'
		button_c_last=button_c
		
		if (button_z) and (button_z_last==False):
			print 'Button Z wurde gedrueckt'
		if (button_z==False) and (button_z_last):
			print 'Button Z wurde losgelassen'
		button_z_last=button_z
	
	except IOError as e:
		print e