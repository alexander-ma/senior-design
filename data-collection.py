import os
import subprocess

dir_list = [ name for name in os.listdir(os.getcwd()) if os.path.isdir(os.path.join(os.getcwd(), name)) ]
while True:
    inp = input('Enter directory name: ')
    shortened_dir_list = [name for name in dir_list if name.startswith(inp) or name == inp]
    if inp == 'ls':
        print(dir_list)

    elif len(shortened_dir_list) == 1:
        app_name = shortened_dir_list[0]
        app_scripts = os.listdir(app_name)
        print("Scripts: " + str(app_scripts))
        inp = input('Enter script name: ')
        if inp in app_scripts:
            subprocess.run(os.path.join('./', app_name, inp))
