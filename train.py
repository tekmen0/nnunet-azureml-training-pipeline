# training python script : train.py
import os
import sys
import subprocess

# prepare directories
nnUNet_raw_data_base=os.getenv('nnUNet_raw_data_base')
nnUNet_preprocessed=os.getenv('nnUNet_preprocessed')
RESULTS_FOLDER=os.getenv('RESULTS_FOLDER')

try :
  os.makedirs(os.path.join(nnUNet_raw_data_base, 'nnUNet_raw_data'))
  os.makedirs(nnUNet_preprocessed)
  os.makedirs(RESULTS_FOLDER)
except FileExistsError:
  pass

result1 = subprocess.run(['gdown', 'https://drive.google.com/uc?id=1vvgcavq_Za42T5YUVQZ2U6wgg4idq6Wy&confirm=t'], stdout=subprocess.PIPE)
print(result1.stdout.decode('ascii'))

#os.chdir("nnUNet_raw_data_base/nnUNet_raw_data/")
result2 = subprocess.run(['tar', '-xf', "Task05_Prostate.tar"], stdout=subprocess.PIPE)
print(result2)
print(result2.stdout.decode('ascii'))
os.chdir("../..")

result3 = subprocess.run(['nnUNet_convert_decathlon_task', '-i', f'{nnUNet_raw_data_base}/nnUNet_raw_data/Task05_Prostate', '-p', '4'], stdout=subprocess.PIPE)
print(result3)
print(result3.stdout.decode('ascii'))
result4 = subprocess.run(['nnUNet_plan_and_preprocess', '-t', '5', '--verify_dataset_integrity'], stdout=subprocess.PIPE)
print(result4)
print(result4.stdout.decode('ascii'))
result5 = subprocess.run(['nnUNet_train', '3d_fullres', 'nnUNetTrainerV2', 'Task005_Prostate', '0', '--npz'], stdout=subprocess.PIPE)
print(result5)
print(result5.stdout.decode('ascii'))
