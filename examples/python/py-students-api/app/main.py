import ssl
from flask import Flask
from flask_restful import Resource, Api, reqparse
parser = reqparse.RequestParser()
app = Flask(__name__)
api = Api(app)
STUDENTS = [
    {'1': {'name': 'John Smith', 'age': 23, 'specialty': 'Math'}},
    {'2': {'name': 'Rich Brown', 'age': 25, 'specialty': 'Science'}},
    {'3': {'name': 'Jane Doe', 'age': 26, 'specialty': 'geo'}},
    {'4': {'name': 'Will Smith', 'age': 24, 'specialty': 'CS'}},
    {'5': {'name': 'Robert Decaprio', 'age': 32, 'specialty': 'History'}},
    {'6': {'name': 'Julia Roberts', 'age': 62, 'specialty': 'Engineering'}},
    {'7': {'name': 'Emmie Watkins', 'age': 14, 'specialty': 'Dance'}},
    {'8': {'name': 'Julia Childs', 'age': 17, 'specialty': 'Music'}},
    {'9': {'name': 'Brandon James', 'age': 44, 'specialty': 'Education'}},
]


class StudentsList(Resource):
    def get(self):
        return STUDENTS

def post(self):
    parser.add_argument("name")
    parser.add_argument("age")
    parser.add_argument("specialty")
    args = parser.parse_args()
    student_id = int(max(STUDENTS.keys())) + 1
    student_id = '%i' % student_id
    STUDENTS[student_id] = {"name": args["name"],
                            "age": args["age"],
                            "specialty": args["specialty"],
                            }
    return STUDENTS[student_id], 201

api.add_resource(StudentsList, '/students/')
# context = ssl.SSLContext()
# context.load_cert_chain('cert.pem', 'key.pem')
if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=False) #, ssl_context=context)
