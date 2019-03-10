#pip install --upgrade google-api-python-client
#pip install SpeechRecognition
#brew install portaudio
#pip install pyaudio 

import speech_recognition as sr
 
# Record Audio
r = sr.Recognizer()

for index, name in enumerate(sr.Microphone.list_microphone_names()):
    print("Microphone with name \"{1}\" found for `Microphone(device_index={0})`".format(index, name))

 
def listen():
	#Microphone(device_index=MICROPHONE_INDEX)
    
    with sr.Microphone() as source:
        print("Say something!")
        audio = r.record(source, duration = 2)
    try:
    # for testing purposes, we're just using the default API key
    # to use another API key, use `r.recognize_google(audio, key="GOOGLE_SPEECH_RECOGNITION_API_KEY")`
    # instead of `r.recognize_google(audio)`
        print("You said: " + r.recognize_google(audio))
        listen()
    except sr.UnknownValueError:
        print("Google Speech Recognition could not understand audio")
        listen()
    except sr.RequestError as e:
        print("Could not request results from Google Speech Recognition service; {0}".format(e))
        listen()
 
listen()