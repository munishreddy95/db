import threading
import subprocess
#subprocess.run(["ls", "-l"])
def printit():
  threading.Timer(900.0, printit).start()
  #print("Hello, World!")
  #git commands
 # subprocess.run([" git add ."])
 # subprocess.run([" git commit -m change"])
  #subprocess.run([" git push "])
  subprocess.call(['bash','./mysql_backup.sh'])

printit()
