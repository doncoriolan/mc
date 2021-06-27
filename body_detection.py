import cv2
import numpy as np 
# Importing the sendemail script
import sendemail1
# Download a Human Body Haar cascade and call it below
human_cascade = cv2.CascadeClassifier('haarcascade_fullbody.xml')

# Enter the camera URL
cap = cv2.VideoCapture("rtsp://10.1.10.1:554/video1")
# number of frames a person passes
person_counter = 0
# If there is a person
possible_person = False
# Frames there is no one
notaperson_counter = 0
while True:
    ret, frame = cap.read()
    if ret:
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

        human = human_cascade.detectMultiScale(gray, 1.1, 4)
        for (x,y,w,h) in human:
            cv2.rectangle(frame,(x,y), (x+w, y+h), (0,0,220),3)
            person_counter +=1
            possible_person = True
            # we saw a person for 15 frames
            if person_counter == 15:
                notaperson_counter = 0
                person_counter = 0
                print("reset not person counter")
                # Add your own script to send email then call it in the script.
                exec("sendemail1") 
        if len(human) == 0:
            possible_person = False
        # if we don't see anyone restart the
        if possible_person == False:
            notaperson_counter +=1
        # we don't see someone for 15 frames
        if notaperson_counter > 15:
            person_counter = 0
           # reset not person counter
            notaperson_counter = 0
            print("reset not person counter")
            print("reset person counter")
        cv2.imshow('frame',frame)
    k = cv2.waitKey(30) & 0xff
    if k == 27:
     break

cap.release()
cv2.destroyALLWindows()
