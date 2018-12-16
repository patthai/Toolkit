
#Server
from flask import Flask, request, jsonify
import json

app = Flask(__name__)
@app.route('/args', methods=['POST'])
def args_fun():
	args = request.data
	print(args)
	my_json = args.decode('utf8').replace("'", '"')
	data = json.loads(my_json)
	print(data["dinosaur"])
	print(data["people"])
	
	#process data
	dinosaur_string = str(data["dinosaur"])
	people_string = str(data["people"])
	

	#Return
	return 'I love %s and %s \n' % (dinosaur_string, people_string)


if __name__ == '__main__':
    app.run(port=5001)
