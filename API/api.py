from flask import Flask, request, jsonify
import boto3
import os
from dotenv import load_dotenv

load_dotenv()
app = Flask("__name__")

s3 = boto3.client(
    's3',
    aws_access_key_id=os.getenv('AWS_ACCESS_KEY_ID'),
    aws_secret_access_key=os.getenv('AWS_SECRET_ACCESS_KEY'),
    region_name=os.getenv('us-east-1')
)

IMG_BUCKET = os.getenv('IMG_BUCKET')
MODEL_BUCKET = os.getenv('MODEL_BUCKET')

@app.route('/uploadIMG', methods=['POST'])
def upload_image():
    data = request.json
    if not data or 'name' == '' or 'path' == '':
        return jsonify({"error": "Bad Format"}), 400
    file_name = data['fileName']
    path = data['path']
    try:
        s3.upload_file(path, IMG_BUCKET, file_name)
        return jsonify({"message": "File uploaded to AWS"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/getModel/<filename>', methods=['GET'])
def get_image_url(filename):
    try:        
        file_url = s3.generate_presigned_url(
            'get_object',
            Params={
                'Bucket': MODEL_BUCKET,
                'Key': f'uploads/{filename}'
            },
            ExpiresIn=3600  
        )
        
        return jsonify({"file_url": file_url}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)