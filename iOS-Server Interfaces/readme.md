# 1) Run the Server side
## 1.1 Signup for tunneling service via https://ngrok.com/
## 1.2 $python server-example.py
## On the new terminal 
## 1.3 $./ngrok authtoken <Your own nrok authentication code>
## 1.4 $./ngrok http 5001

# 2) Open the iOS side
## 2.1 Change -> var apiBaseURL: String = "https://62ba5783.ngrok.io" to the nrok URL
