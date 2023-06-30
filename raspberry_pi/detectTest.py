import argparse
import sys
import time

import cv2
from tflite_support.task import core
from tflite_support.task import processor
from tflite_support.task import vision
import utils


def run(model: str, camera_id: int, width: int, height: int, num_threads: int,
        enable_edgetpu: bool) -> None:

  # Variables to calculate FPS
  counter, fps = 0, 0
  start_time = time.time()
    
#   stream_url = "192.168.1.93:8081"

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

  base_options_model1 = core.BaseOptions(
    file_name=model[0], use_coral=enable_edgetpu, num_threads=num_threads) # 모델1
  detection_options_model1 = processor.DetectionOptions(
    max_results=3, score_threshold=0.5)
  options_model1 = vision.ObjectDetectorOptions(
    base_options=base_options_model1, detection_options=detection_options_model1)
  detector_model1 = vision.ObjectDetector.create_from_options(options_model1)

  base_options_model2 = core.BaseOptions(
    file_name=model[1], use_coral=enable_edgetpu, num_threads=num_threads) # 모델2
  detection_options_model2 = processor.DetectionOptions(
    max_results=3, score_threshold=0.5)
  options_model2 = vision.ObjectDetectorOptions(
    base_options=base_options_model2, detection_options=detection_options_model2)
  detector_model2 = vision.ObjectDetector.create_from_options(options_model2)



  # Initialize the object detection model
#   base_options = core.BaseOptions(
#       file_name=model, use_coral=enable_edgetpu, num_threads=num_threads) # 모델 파일이름, edge TPU 사용 여부, 스레드 수
#   detection_options = processor.DetectionOptions( # 객체 감지 결과 최대 결과 수, 결과 스코어
#       max_results=3, score_threshold=0.5)
#   options = vision.ObjectDetectorOptions( # detectOption & Object Detector -- 요녀석
#       base_options=base_options, detection_options=detection_options)
#   detector = vision.ObjectDetector.create_from_options(options) # 객체 감지 모델 추론 -- 요녀석

    

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
    # detection_result = detector.detect(input_tensor)
    detection_result_model1 = detector_model1.detect(input_tensor)
    detection_result_model2 = detector_model2.detect(input_tensor)


    # 분기처리
    # Check if both models have detected objects
    if detection_result_model1.has_detection and detection_result_model2.has_detection:
        if detection_result_model1.scores[0] > 0.7 and detection_result_model2.scores[0] > 0.7:
            print("통과")
        else:
            print("인식불가")
    else:
        print("인식불가")


    # Draw keypoints and edges on input image
    # image = utils.visualize(image, detection_result)
    image = utils.visualize(image, detection_result_model1)
    image = utils.visualize(image, detection_result_model2)


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
      default='test.tflite')
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
