from os import walk
from time import time, sleep
import vk
import json
import requests

# set variables
with open('config.json') as cfg:
	config = json.load(cfg)

token = config['token']
group_id = config['group_id']
posted = config['posted']
posting_speed = config['posting_speed']
img_path = 'manual/'

def post(img):
    session = vk.Session(access_token=token)
    api = vk.API(session, v='6.85')

    upload_url = api.photos.getWallUploadServer(group_id=group_id)['upload_url']
    request = requests.post(upload_url, files={'photo': open(img_path + img, "rb")})
    params = {'server': request.json()['server'],
          'photo': request.json()['photo'],
          'hash': request.json()['hash'],
          'group_id': group_id}

    data = api.photos.saveWallPhoto(**params)
    photo_id = data[0]['id']
    attachments = {'photo' + str(data[0]['owner_id']) + '_' + str(photo_id)}

    params = {'attachments' : attachments,
          'message': '',
          'owner_id': '-' + group_id,
          'from_group' : '1'}

    print(api.wall.post(**params))


# auto posting
while True:
	dir = walk(img_path)
	for adress, dirs, files in dir:
		for img in files:
			if img not in posted:
				try:
					post(img)
				except:
					sleep(30)
				else:
					posted += img + ';'
					config['posted'] = posted
					with open('config.json', w) as cfg:
						json.dump(config, cfg)
					sleep(posting_speed)
                