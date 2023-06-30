import cv2
import numpy as np
import datetime
import time
import firebase_admin
import RPi.GPIO as GPIO
import pygame.mixer
from firebase_admin import credentials, storage, db
from tflite_support.task import processor

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)

# 적외선 센서, R,G,B GPIO 지정
PIR = 26
red = 18
green = 23
blue = 24
GPIO.setup(PIR, GPIO.IN)
GPIO.setup(red, GPIO.OUT)
GPIO.setup(green, GPIO.OUT)
GPIO.setup(blue, GPIO.OUT)


# 각 색상별로 LED 켜기/끄기 함수 정의
def color(r, g, b):
    GPIO.output(red, r)
    GPIO.output(green, g)
    GPIO.output(blue, b)

# 오디오 파일 경로 설정
wait = "/home/pi/Music/wait.mp3"
passs = "/home/pi/Music/passs.mp3"
retry = "/home/pi/Music/retry.mp3"





# pygame 초기화
pygame.mixer.init()

# 오디오 재생 함수
def play_sound_wait(wait):
    pygame.mixer.music.load(wait)
    pygame.mixer.music.play()
    print("잠시만 기다려주세요.")
    
def play_sound_pass(passs):
    pygame.mixer.music.load(passs)
    pygame.mixer.music.play()
    print("확인 되었습니다.")


def play_sound_retry(retry):
    pygame.mixer.music.load(retry)
    pygame.mixer.music.play()
    print("다시 시도합니다.")
    

_MARGIN = 10  # pixels
_ROW_SIZE = 10  # pixels
_FONT_SIZE = 1
_FONT_THICKNESS = 1
_TEXT_COLOR = (0, 0, 255)  # red

# Firebase 인증 정보 로드하기
cred = credentials.Certificate("putiton-firebase-adminsdk.json")
firebase_admin.initialize_app(cred, {"storageBucket": f"putiton-65905.appspot.com",
                                     "databaseURL": "https://putiton-65905-default-rtdb.firebaseio.com"})
bucket = storage.bucket()
now = datetime.datetime.now()
# Firebase Realtime Database 레퍼런스 생성
ref = db.reference('current_time')




global triggered

###########################################################



def visualize(
    image: np.ndarray,
    detection_result: processor.DetectionResult,
) -> np.ndarray:
  """Draws bounding boxes on the input image and return it.

  Args:
    image: The input RGB image.
    detection_result: The list of all "Detection" entities to be visualize.

  Returns:
    Image with bounding boxes.
  """
  
  # Firebase에서 저장될 시간대
  timestamp = now.strftime("%Y-%m-%d_%H-%M-%S")
  filename = "capture_{}.jpg".format(timestamp)
  helmet_score = None
  vest_score = None
  triggered = False
  
  for detection in detection_result.detections:
    # Draw bounding_box
    bbox = detection.bounding_box
    start_point = bbox.origin_x, bbox.origin_y
    end_point = bbox.origin_x + bbox.width, bbox.origin_y + bbox.height
    cv2.rectangle(image, start_point, end_point, _TEXT_COLOR, 3)

    # Draw label and score
    category = detection.categories[0]
    category_name = category.category_name
    category_score = category.score
    
    if category_name == 'helmet':
        helmet_score = category_score
    elif category_name == 'vest':
        vest_score = category_score
        
    
    probability = round(category.score, 2)
    result_text = category_name + ' (' + str(probability) + ')'
    text_location = (_MARGIN + bbox.origin_x,
                     _MARGIN + _ROW_SIZE + bbox.origin_y)
    cv2.putText(image, result_text, text_location, cv2.FONT_HERSHEY_PLAIN,
                _FONT_SIZE, _TEXT_COLOR, _FONT_THICKNESS)

    if cv2.waitKey(1) == ord('t') :
        cv2.imwrite(filename, image)
        # Firebase Storage에 이미지 업로드하기
        blob = bucket.blob(filename)
        blob.upload_from_filename(filename)
        # 현재 시간을 Firebase Realtime Database에 저장
        ref.push(now.strftime("%Y-%m-%d %H:%M:%S"))
        print("Image uploaded to Firebase Storage.")    
    
    if GPIO.input(PIR) == GPIO.HIGH and not triggered:
        triggered = True  # 센서 감지됨
        color(0, 0, 1)  # 파란색
        play_sound_wait(wait)
        time.sleep(2)
            
        if triggered == True:
            if (helmet_score is not None and helmet_score > 0.5) and (vest_score is not None and vest_score > 0.5):
                #cv2.imwrite(filename, image)
                # Firebase Storage에 이미지 업로드하기
                #blob = bucket.blob(filename)
                #blob.upload_from_filename(filename)
                # 현재 시간을 Firebase Realtime Database에 저장
                #ref.push(now.strftime("%Y-%m-%d %H:%M:%S"))
                #print("Image uploaded to Firebase Storage.")
                play_sound_pass(passs)
                time.sleep(0.7)
                
                color(0, 1, 0) # 초록색
                #time.sleep(2)
                triggered = False
                color(0, 0, 1)  # 불 꺼져
            else:
                color(1, 0, 0) # 빨간색
                #play_sound_retry(retry)
                #time.sleep(2)
                triggered = False
                color(0, 0, 1)  # 불 꺼져
                
    else:
        triggered = False
        color(0, 0, 1)  # 불 꺼져
 
      
    
  return image




