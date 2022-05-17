from flask import Flask,request,jsonify
from face_detection import FaceDetection as fd
from apscheduler.schedulers.background import BackgroundScheduler
import threading
app = Flask(__name__)

face_detect = fd()
def detect_screen_time():
        print('started detect_screen_time\n')
        face_detect.detect()

def detect_water_level():
        print('started detect_water\n')
        face_detect.detect_water()

def detect_postures():
        print('started detect_posture\n')
        face_detect.detect_posture()

#thr = threading.Thread(target=face_detect.detect_water, args=(), kwargs={})   
#thr.start()   
schedulers = BackgroundScheduler()
# schedulers.add_job(start_stop_work, 'interval', seconds=10)
schedulers.add_job(detect_screen_time, 'interval', seconds=10)
schedulers.add_job(detect_water_level, 'interval', seconds=10)# change to the time intervals we need to check
schedulers.add_job(detect_postures, 'interval', seconds=5)
schedulers.start()


@app.route('/screentime',methods = ['GET'])
def screentime(): # need to be removed and need to fetch screentime from database
    d={}
    answer = fd.total_screen_time
    d['output'] = str(answer)
    return d


if __name__ == '__main__':
    app.run(debug =True,use_reloader=False)