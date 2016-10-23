ECHO OFF
CLS
SET PATH=C:\Program Files (x86)\Google\Cloud SDK\google-cloud-sdk\bin;%PATH%;
cd C:\Users\Benjamin\Desktop\College\Pitt\5thSemester\CSCapstone\CapstoneQuiz
ECHO Welcome to the Google Cloud SDK! Run "gcloud -h" to get the list of available commands.
ECHO Running PharmQuiz.
ECHO ---
ECHO ON
python "C:\Program Files (x86)\Google\Cloud SDK\google-cloud-sdk\bin\dev_appserver.py" .