import argparse
import sys
import time

import cv2
import numpy as np
from tflite_support.task import core
from tflite_support.task import processor
from tflite_support.task import vision
import utils



# Variables to calculate FPS
counter, fps = 0, 0
start_time = time.time()
    
# stream_url = "192.168.1.3:5000"

# Start capturing video input from the camera
cap = cv2.VideoCapture(0)
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)

# Visualization parameters
row_size = 20  # pixels
left_margin = 24  # pixels
text_color = (0, 0, 255)  # red
font_size = 1
font_thickness = 1
fps_avg_frame_count = 10

# Initialize the object detection model
base_options = core.BaseOptions(
    file_name="putItOn.tflite", use_coral=False, num_threads=4) # 모델 파일이름, edge TPU 사용 여부, 스레드 수
detection_options = processor.DetectionOptions( # 객체 감지 결과 최대 결과 수, 결과 스코어
    max_results=3, score_threshold=0.5)
options = vision.ObjectDetectorOptions( # detectOption & Object Detector 
    base_options=base_options, detection_options=detection_options)
detector = vision.ObjectDetector.create_from_options(options) # 객체 감지 모델 추론 


# Continuously capture images from the camera and run inference
while cap.isOpened():
    success, image = cap.read()

    

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
    if cv2.waitKey(1) == ord('q'):
      break
    cv2.imshow('put it on', image)

cap.release()
cv2.destroyAllWindows()
