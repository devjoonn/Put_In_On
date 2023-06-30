import argparse
import sys
import time

import cv2
import numpy as np
import datetime
import firebase_admin
from firebase_admin import credentials, storage, db
from tflite_support.task import core
from tflite_support.task import processor
from tflite_support.task import vision
import utils


def run(model: str, camera_id: int, width: int, height: int, num_threads: int,
        enable_edgetpu: bool) -> None:

  # Firebase 인증 정보 로드하기
  cred = credentials.Certificate("putiton-firebase-adminsdk.json")
  firebase_admin.initialize_app(cred, {"storageBucket": f"putiton-65905.appspot.com",
                                     "databaseURL": "https://putiton-65905-default-rtdb.firebaseio.com"})
  bucket = storage.bucket()

  # Firebase Realtime Database 레퍼런스 생성
  ref = db.reference('current_time')
    
  # 현재 시간을 Firebase Realtime Database에 저장
  now = datetime.datetime.now()
  ref.push(now.strftime("%Y-%m-%d %H:%M:%S"))
 ###########################################################

  # Variables to calculate FPS
  counter, fps = 0, 0
  start_time = time.time()
    

  # Start capturing video input from the camera
  cap = cv2.VideoCapture(0)
  cap.set(cv2.CAP_PROP_FRAME_WIDTH, width)
  cap.set(cv2.CAP_PROP_FRAME_HEIGHT, height)

  # Visualization parameters
  row_size = 20  # pixels
  left_margin = 24  # pixels
  text_color = (0, 0, 255)  # red
  font_size = 1
  font_thickness = 1
  fps_avg_frame_count = 10

  # Initialize the object detection model
  base_options = core.BaseOptions(
      file_name=model, use_coral=enable_edgetpu, num_threads=num_threads) # 모델 파일이름, edge TPU 사용 여부, 스레드 수
  detection_options = processor.DetectionOptions( # 객체 감지 결과 최대 결과 수, 결과 스코어
      max_results=3, score_threshold=0.5)
  options = vision.ObjectDetectorOptions( # detectOption & Object Detector 
      base_options=base_options, detection_options=detection_options)
  detector = vision.ObjectDetector.create_from_options(options) # 객체 감지 모델 추론 

    

  # Continuously capture images from the camera and run inference
  while cap.isOpened():
    success, image = cap.read()

    # Firebase에서 저장될 시간대
    timestamp = now.strftime("%Y-%m-%d_%H-%M-%S")
    filename = "capture_{}.jpg".format(timestamp)

    if not success:
      sys.exit(
          'ERROR: Unable to read from webcam. Please verify your webcam settings.'
      )

    counter += 1
    image = cv2.flip(image, 1)

    # Convert the image from BGR to RGB as required by the TFLite model.
    rgb_image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

    # Create a TensorImage object from the RGB image.
    input_tensor = vision.TensorImage.create_from_array(rgb_image)

    # Run object detection estimation using the model. 
    detection_result = detector.detect(input_tensor) # 입력 이미지에서 객체 감지 추론을 실행해서 저장


    # print(detection_result) 를 하면 나오는 값
    # DetectionResult(detections=[
    #                             Detection(bounding_box=BoundingBox(origin_x=67, origin_y=207, width=276, height=273), 
    #                                       categories=[Category(index=1, score=0.88671875, display_name='', category_name='vest')]
    #                                       ),
    #                             Detection(bounding_box=BoundingBox(origin_x=119, origin_y=42, width=140, height=112), 
    #                                       categories=[Category(index=0, score=0.78125, display_name='', category_name='helmet')]
    #                                       )
    #                             ]
    #                 )

    # 분기처리
    if cv2.waitKey(1) == ord('t') :
        cv2.imwrite(filename, image)
        # Firebase Storage에 이미지 업로드하기
        blob = bucket.blob(filename)
        blob.upload_from_filename(filename)
        print("Image uploaded to Firebase Storage.")

    # Draw keypoints and edges on input image
    image = utils.visualize(image, detection_result) # 이미지에 감지된 객체의 경계 상자와 레이블을 그리고 출력

    # Calculate the FPS
    if counter % fps_avg_frame_count == 0:
      end_time = time.time()
      fps = fps_avg_frame_count / (end_time - start_time)
      start_time = time.time()

    # Show the FPS
    fps_text = 'FPS = {:.1f}'.format(fps)
    text_location = (left_margin, row_size)
    cv2.putText(image, fps_text, text_location, cv2.FONT_HERSHEY_PLAIN,
                font_size, text_color, font_thickness)

    # Stop the program if the ESC key is pressed.
    if cv2.waitKey(1) == 27:
      break
    cv2.imshow('put it on', image)

  cap.release()
  cv2.destroyAllWindows()


def main():
  parser = argparse.ArgumentParser(
      formatter_class=argparse.ArgumentDefaultsHelpFormatter)
  parser.add_argument(
      '--model',
      help='Path of the object detection model.',
      required=False,
      default='tensorModel.tflite')
  parser.add_argument(
      '--cameraId', help='Id of camera.', required=False, type=int, default=0)
  parser.add_argument(
      '--frameWidth',
      help='Width of frame to capture from camera.',
      required=False,
      type=int,
      default=640)
  parser.add_argument(
      '—frameHeight',
      help='Height of frame to capture from camera.',
      required=False,
      type=int,
      default=480)
  parser.add_argument(
      '—numThreads',
      help='Number of CPU threads to run the model.',
      required=False,
      type=int,
      default=4)
  parser.add_argument(
      '—enableEdgeTPU',
      help='Whether to run the model on EdgeTPU.',
      action='store_true',
      required=False,
      default=False)
  args = parser.parse_args()

  run(args.model, int(args.cameraId), args.frameWidth, args.frameHeight,
      int(args.numThreads), bool(args.enableEdgeTPU))


if __name__ == '__main__':
  main()
