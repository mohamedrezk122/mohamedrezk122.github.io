import os 

files = os.listdir(os.getcwd())

i = 1
print(i)
for file in files:
    if ".jpg" in file:
        new = "0"+str(i) if i < 10 else str(i)
        os.rename(file, new+".jpg")
        print(new)
        i += 1
