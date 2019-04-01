from requests import get
from requests.exceptions import RequestException
from contextlib import closing
from bs4 import BeautifulSoup
from nltk.tokenize import sent_tokenize
import re

def simple_get(url):
	"""
	Attempts to get the content at `url` by making an HTTP GET request.
	If the content-type of response is some kind of HTML/XML, return the
	text content, otherwise return None.
	"""
	try:
		with closing(get(url, stream=True)) as resp:
			if is_good_response(resp):
				return resp.content
			else:
				return None

	except RequestException as e:
		log_error('Error during requests to {0} : {1}'.format(url, str(e)))
		return None


def is_good_response(resp):
	"""
	Returns True if the response seems to be HTML, False otherwise.
	"""
	content_type = resp.headers['Content-Type'].lower()
	return (resp.status_code == 200 
			and content_type is not None 
			and content_type.find('html') > -1)


def log_error(e):
	"""
	It is always a good idea to log errors. 
	This function just prints them, but you can
	make it do anything.
	"""
	print(e)

def get_questions(content):
	"""
	Given a string of all content to parse, returns a list of the questions found in the document.
	"""
	# extract only the content text from the webpage
	soup = BeautifulSoup(content, 'html.parser')
	for i in soup(["script", "style"]):
		i.extract()
	text = soup.get_text()

	# get sentences array
	sentences = sent_tokenize(text)
	sentences = [s.strip("\n") for s in sentences]

	# extract the questions from the text
	questions = []
	for s in sentences:
		if re.findall("\?$", s):
			questions.append(s)

	return questions


def output_csv(arr):
	"""
	Outputs a csv file filled with content from param list
	"""
	return csv.writer(arr)


a = simple_get("https://conversationstartersworld.com/philosophical-questions/")
print(get_questions(a))

# def request_handler(request):
#     if 'topic' not in request['args'] or 'len' not in request['args']:
#         return '-1'
		
#     topic = request['values']['topic']
#     length = int(request['values']['len'])
	
#     to_send = "https://en.wikipedia.org/w/api.php?titles={}&action=query&prop=extracts&redirects=1&format=json&exintro=".format(topic)
#     r = requests.get(to_send)
#     data = r.json()

#     try:
#         html_doc = data['query']['pages'][list(data['query']['pages'].keys())[0]]['extract']
#         soup = BeautifulSoup(html_doc, 'html.parser')
#         text = soup.get_text()
		
#         result = ""
#         for s in text.split('.'):
#             actual_s = s.strip()
#             if len(actual_s) < length:
#                 print(len(actual_s.split(' ')))
#                 if len(actual_s.split(' '))==1:
#                     result += actual_s + '.'
#                 else:
#                     result += ' ' + actual_s + '.'
#                     length -= len(actual_s)
#             else:
#                 break
		
#         return result.strip()
		
#     except:
#         return '-1'