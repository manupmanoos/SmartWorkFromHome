import numpy as np
import cv2
import firebase_admin
from firebase_admin import credentials,storage,db,firestore
import mediapipe as mp
from datetime import datetime


class FaceDetection:
    total_screen_time = 0
    safe_posture_distance = 9 #change as required

    # init method or constructor 
    def __init__(self):
        #self.cred = credentials.Certificate("./key.json")
        #self.app = firebase_admin.initialize_app(self.cred, {"storageBucket" : "facedetection-3bff8.appspot.com","databaseURL" : "https://facedetection-3bff8-default-rtdb.europe-west1.firebasedatabase.app/"})
        
        self.face_capture_interval = 10 
        self.queue = []
        self.queue_posture = []

        # firestore creds
        self.cred = credentials.Certificate("./IOT_GROUP_KEY.json")
        self.app = firebase_admin.initialize_app(self.cred, {"storageBucket" : "iotproject-a9f1b.appspot.com","databaseURL" : "https://iotproject-a9f1b-default-rtdb.europe-west1.firebasedatabase.app/"})
        self.mp_face_detection = mp.solutions.face_detection
        self.mp_drawing = mp.solutions.drawing_utils
        
        
        #initialization of firestore
        db = firestore.client()
        # getting all the data
        self.data = db.collection(u'iot').document(u'iotrix').get()._data
        #intializing today
        init_docref = db.collection(u'iot').document(u'iotrix')
        self.today = datetime.now().strftime("%B %d, %Y")
        if "screenTime" not in self.data:
            init_docref.update({
                "screenTime" :{}
            })
        if "LastPickup" not in self.data:
            init_docref.update({
                "LastPickup":0
            })
        if "waterLevelHistory" not in self.data:
            init_docref.update({
                "waterLevelHistory" :{}
            })
        if "postureHistory" not in self.data:
            init_docref.update({
                "postureHistory" :{}
            })
        if "wrongPostureTime" not in self.data:
            init_docref.update({
                "wrongPostureTime" :0
            })
        if "continousScreenTime" not in self.data:
            init_docref.update({
                "continousScreenTime" :0
            })

        self.data = db.collection(u'iot').document(u'iotrix').get()._data
        if self.today in self.data['screenTime']:
            FaceDetection.total_screen_time = self.data['screenTime'][self.today]
        else:
            FaceDetection.total_screen_time = 0   

        waterhistory = 0
        if self.today in self.data['waterLevelHistory'] :
            waterhistory = self.data['waterLevelHistory'][self.today]

        posturehistory = 0
        if self.today in self.data['postureHistory'] :
            posturehistory = self.data['postureHistory'][self.today]
        
        #initializin in firebase
        init_docref.update({
           "waterLevelHistory."+db.field_path(self.today) :waterhistory,
           "today":self.today,
           "screenTime."+db.field_path(self.today) :FaceDetection.total_screen_time,
           "postureHistory."+db.field_path(self.today) :posturehistory
        })
        
    def detect_faces_from_images(self,total_screen_time,queue,face_capture_interval):

        bucket = storage.bucket()

        #blob = bucket.get_blob("FaceImages/Woman2.jpg")
        blobs_org = list(bucket.list_blobs(prefix='')) 
        # sorting blobs (can avoid this if stored as oldest first while uploading)
        blobs = sorted(blobs_org, key=lambda x: x.time_created)
        db = firestore.client()
        iotrix_ref =  db.collection(u'iot').document(u'iotrix')
        iotrix_data = iotrix_ref.get()._data
        for blob in blobs:
            if "image" in blob.content_type:
                arr = np.frombuffer(blob.download_as_string(),np.uint8)
                if arr is not None:
                    img = cv2.imdecode(arr,cv2.COLOR_BGR2BGR555)

                with self.mp_face_detection.FaceDetection(
                    model_selection=1, min_detection_confidence=0.7) as face_detection:
                    
                    if img is not None:
                        # Convert the BGR image to RGB and process it with MediaPipe Face Detection.
                        results = face_detection.process(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
                        if results.detections : # and len(results.detections) > 0
                            queue.append(1)
                            total_screen_time += face_capture_interval                       
                            iotrix_ref.update({ "screenTime."+db.field_path(self.today) : total_screen_time})
                            
                        else:
                            queue.append(0)

                        if len(queue) > 5:# update to the number we need
                            queue.pop(0)

                        if sum(queue) > 2:# update to the number we need
                            iotrix_ref.update({u'continousScreenTime': iotrix_data['continousScreenTime']+(3*face_capture_interval) })
                        elif sum(self.queue[3]) > 1 and self.queue[-1] == 0 :
                            self.queue = [0] * 5
                        else:
                            iotrix_ref.update({u'continousScreenTime': 0 })
            
                     
                        
                # blob.delete()
               
        return total_screen_time,queue


    #if __name__ == "__main__":
    def detect(self):
        FaceDetection.total_screen_time,self.queue = self.detect_faces_from_images(FaceDetection.total_screen_time,self.queue,self.face_capture_interval)
        #delay(5000)
           
           
    def detect_water(self):
        db = firestore.client()
        self.data = db.collection(u'iot').document(u'iotrix').get()._data
        today = datetime.now().strftime("%B %d, %Y")
        waterDoc = db.collection(u'FSR').document(u'iotrix')
        waterCollection = waterDoc.get()._data

        new_water_level = waterCollection['Water_Frequency'] 
        doc_ref = db.collection(u'iot').document(u'iotrix')
        localData = db.collection(u'iot').document(u'iotrix').get()._data

        # if data changes in the backend db value is automatically initializes to 0
        # new water level history is pushed.
        if(today != self.today):
            self.today = today
            doc_ref.update({
            "waterLevelHistory."+db.field_path(self.today) :0,
            "today":today
            })
        
        if new_water_level == 0:
            #notify user- update push water notification
            #doc_ref.update({u'PushWaterNotification': True})
            #doc_ref.update({u'PushWaterNotification': False})
            doc_ref.update({u'LastPickup': self.data['LastPickup'] + 1})
        else:
            waterDoc.update({
                "Water_Frequency":0
            })
            doc_ref.update({
            "waterLevelHistory."+db.field_path(self.today) :localData['waterLevelHistory'][today] +1
            })
            doc_ref.update({u'LastPickup': 0})
            

    def detect_posture(self):
        db = firestore.client()
        data = db.collection(u'Ultrasonic').document(u'iotrix').get()._data
        new_distance = data['PostureDistance']
        doc_ref = db.collection(u'iot').document(u'iotrix')
        doc_ref_data = doc_ref.get()._data
        if new_distance != 0: # in his seat
            if new_distance > FaceDetection.safe_posture_distance:
            #new_count = data['PostureCorrectionCount'] #increment this from esp 32 when distance greater than safety distance
            #if FaceDetection.posture_count != new_count :
                #incorrect posture
                self.queue_posture.append(1)
                #FaceDetection.posture_count = new_count
                today = datetime.now().strftime("%B %d, %Y")
                new_val = doc_ref_data['postureHistory'][today] + 1 
                doc_ref.update({'postureHistory.'+db.field_path(self.today): new_val})
            else:
                #correct posture
                self.queue_posture.append(0)

            if len(self.queue_posture) > 5:
                self.queue_posture.pop(0)

            if sum(self.queue_posture)> 2:
                doc_ref.update({u'wrongPostureTime': doc_ref_data['wrongPostureTime']+(3*5) }) # 3* scheduler interval
            elif sum(self.queue_posture[3]) > 1 and self.queue_posture[-1] == 0 :
                self.queue_posture = [0] * 5
            else :
                doc_ref.update({u'wrongPostureTime': 0 })
        else:
            self.queue_posture.append(0)
            if len(self.queue_posture) > 5:
                self.queue_posture.pop(0)