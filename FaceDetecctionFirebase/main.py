import numpy as np
import cv2
import firebase_admin
from firebase_admin import credentials,storage
import mediapipe as mp

def detect_faces_from_images(total_screen_time,queue,face_capture_interval):

    bucket = storage.bucket()

    #blob = bucket.get_blob("FaceImages/Woman2.jpg")
    blobs_org = list(bucket.list_blobs(prefix='FaceImages/')) 
    # sorting blobs (can avoid this if stored as oldest first while uploading)
    blobs = sorted(blobs_org, key=lambda x: x.time_created)
    
    for blob in blobs:
        if "image" in blob.content_type:
            arr = np.frombuffer(blob.download_as_string(),np.uint8)
            img = cv2.imdecode(arr,cv2.COLOR_BGR2BGR555)
            #cv2.imshow('image',img)
            #cv2.waitKey(0)

            with mp_face_detection.FaceDetection(
                model_selection=1, min_detection_confidence=0.7) as face_detection:
                
                # Convert the BGR image to RGB and process it with MediaPipe Face Detection.
                results = face_detection.process(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
                if results.detections : # and len(results.detections) > 0
                    queue.append(1)
                    total_screen_time += face_capture_interval
                else:
                    queue.append(0)

                if len(queue) > 5:
                    queue.pop(0)
                if sum(queue) > 2:
                    #send notification to user
                    print("Take a break from the screen")

                print("screen time till now : {}".format(total_screen_time))
                
                #annotated_image = img.copy()
                #for detection in results.detections:
                    #mp_drawing.draw_detection(annotated_image, detection)
                    
            blob.delete()
            #cv2.imshow('image',annotated_image)
            #cv2.waitKey(0)
    #detect_faces_from_images(total_screen_time,queue,face_capture_interval)
    return total_screen_time,queue


if __name__ == "__main__":
    cred = credentials.Certificate("./key.json")
    app = firebase_admin.initialize_app(cred, {"storageBucket" : "facedetection-3bff8.appspot.com"})
    mp_face_detection = mp.solutions.face_detection
    mp_drawing = mp.solutions.drawing_utils
    total_screen_time = 0
    face_capture_interval = 5
    # Assuming we need to send notification to user for more than 10 seconds of continous screen time
    # Assuming we have some errors in face detection we will send notification 
    # when we get 3 face detections out of the last 5 where each face detection interval is 5 seconds 
    queue = []
    # need to maintain queue,total_screen_time
    while True:
        total_screen_time,queue = detect_faces_from_images(total_screen_time,queue,face_capture_interval)
