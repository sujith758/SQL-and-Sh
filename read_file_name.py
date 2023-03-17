import os

source_path = "/home/hadoop/Pictures/5_Stores.csv"
file_name = os.path.basename(source_path)
file_name_split = file_name.split(".")
print(type(file_name_split))
id_ext = file_name_split[0].split("_")[0]
print(type(id_ext))
print(id_ext)







